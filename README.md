# Immutag

- [ ] Test

**CAVEATS** This readme may not always accurately reflect the state of the software as this is a work-in-progress. The software is experimental and in alpha stage. If the design choices and code structure seems confusing to you, please jump [here to learn more about the rationale](#code-structure-and-development-rationale).

Immutag is an experimental content-addressable file manager. Users add files with tags. Files are found by searching tags. Files can be stored and shared on network or locally. The software's components are interchangeable so that users and developers aren't locked-down. The software's protocol can be rewritten in any language for use by servers, web browsers, or embedded devices.

Metadata can be pushed to distributed stores (e.g. ipfs) or ledgers (e.g. bitcoin), making them globally discoverable. However, it works well for purely offline use.

You don't need to acquire any bitcoin or tokens or use the bitcoin network if you choose. You can keep all or some of the data offline or on a local network. If you choose to make use of bitcoin's network, you can cryptographically prove the authenticity and chronology of your creations.

This is a working prototype glued together with bash scripts, but it's modular and refactorable. A pivot in the design of underlying protocol would have resulted in a laborous re-write in a compiled language. See 7db9a/immutag.


## Usage and examples

Again, you dont' need to buy or use bitcoin to make use of most of the features of immutag, so go right ahead and jump in.

**Create an immutag store with a bitcoin mnemonic.**

`imt create STORE_NAME MNEMONIC`

`imt create "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"`

(You'll need to retreive or generate the mnemonic from elsewhere, such as with you bitcoin wallet app. It should be a wallet specifically designated from immutag use and not have 'money' on it. At the moment, immutag stores the wallet insecurely for development purposes. In the future, immutag will encrypt the wallet in addition to creating local api endpoints that can accept bitcoin addresses without the need for storing private keys or mnemonics.)

**Add a music file with tags that can be used to find it later.**

`imt add STORE_NAME FILE TAGS...`

`imt add "vivaldi-four-seasons.mp3" music vivaldi classical`

1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2

1Akbr is the file name to immutag. It's copied into a immutag's file store, which is simply a directory versioned by git-annex.

If you don't want to add the original name and extension of the file as tags, then do:

`imt add --no-default-name STORE_NAME FILE TAGS...`

To find files by tags.

`imt find`

A menu of all the files will appear. Start typing terms such as, `mp3`, `vivaldi`, or `classical` to find it. When you select the one you want, imt will spit out the full file name 1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2, in this case. That can be pipped into whatever you want or copied to open it up.

For example, open a file with xdg-open.

`xdg-open $(imt find)`

Actually, the find file menu may appear familiar. It's fzf: a cli utility to find files.

**To add a tag to a file already tagged.**

`imt add-tag STORE_NAME FILE_ADDR TAGS...`

So for example to add the tag 'name=four-seasons' to our vivaldi four seasons song:

`imt add-tag music "$(imt find --address main)" name=four-seasons`

If we happen to remember the name, we can just search

`name=four-seasons` or something thereabouts with `imt find music`

**To replace all the tags with new ones for the file.**

`imt replace-tags FILE_ADDR TAGS...`

You'll select the file from the menu.

`imt replace-tags $(imt find --address music) renaissance orchestral italy`

**To update a file.**

`imt update [--store-name NAME] FILE_ADDR`

***The high-level commands for searching, pulling, and pushing metadata and files in a network are forthcoming.***

## Install (dev)

Clone the repo and depending on the version of git you have...

`git clone --recursive -j8 https://github.com/immutag/immutag`

or

`git clone --recursive-submodules -j8 https://github.com/immutag/immutag`


You'll need docker installed.

```
docker volume create --name=immutag-cargo-data
docker volume create --name=nix-data
docker build -t immutag:0.0.4 .
```

At the moment, the install is for a development environment and not for user distribution.

## Dev workflow

It's recommended that run tests first. To jump to test info, see [here](#test).

To launch.

```
docker-compose up -d
docker exec -it immutag_environment_1 bash
```

Once the container is running, you can edit the code base from the host without rebuilding the image. However, if you update the install script, while inside the container in the host mounted directory, you must run:

`./install`

The install script places the immutag scripts in the user's path.

To stop.

`docker-compose stop`


## How it works

### Global address

All files have a bitcoin (global) address. The user supplies their own public key, private keys or mnemonic. Bitcoin can be interchanged with something else, such as Ethereum. Various low-fee and reliable bitcoin forks are the targets for the distributed ledger.

### Distribution and sharing

The files are discoverable on a distributed file network created with git-annex, but ipfs or something else can be used. Again, everything can be kept as local as the user wants and can be kept offline. The files are found by author created tags and metadata. Anyone can copy files (i.e., forking) that are pushed to the internet and create their own tags, but the chronology will always show who was the early author.

If pushed to a distributed ledger:

`imt push STORE_NAME LEDGER_NAME`

each immutag address records a message stating it's an immutag address and what version of the protocol it's using. The only other messages (unless the protocol is updated) will be the content-addressable hash (versions) of the file-list. When a user fetches the data from the distributed-ledger, it only needs the single content-addressable hash to immutably build all the metadata and file. That way only the bare-minimum has to be pushed to a distributed ledger. All the data is pulled from a distributed file network, such as ipfs. As few or much of the versions (content addresses) can be pushed to the ledger.

### Versioning

Every file version can be cryptographically reconstructed. The local file store uses git-annex. That also gives the user a distributed versioned file system and sharing. There are plans to make ipfs work out-of-the-box, but developers can drop-it-in on their own. The metadata and tags are stored locally on a single file. It's versioned with git. That means any updates to the tags or metadata can be cryptographically mapped to a specific version of the file (remember, it's on git-annex).

A user can roll the state of immutag backwards and forwards and list the generations.

`imt rollback STORE_NAME`

`imt list-generations STORE_NAME`

`imt rollforward STORE_NAME`

immutag is made up of two version controlled directories: metadata and store. immutag looks up the store hash from the file list. immutag automatically records the store's hash on each tagging operation to the file-list header.

### Directory and file structure

An immutag directory has the following structure and includes everything needed for immutag to work.

```
$HOME/immutag
├── account
│   ├── wallet-info| Bitcoin wallet seed, including mnemonic.
├── metadata
│   ├── entries       | The tags of the files.
│   ├── store-snapshot| Cryptographic snapshot of the files store.
│   ├── .git          | Content hashes found by traversing tree.
├── store             | Store of globally addressed files.
    ├── 17nZVxS
    ├── 1CaKbES
    ├── ...
    ├── .git          | Version and distrubtion via git-annex,
        ├── git-annex | but ipfs or other can be dropped in on top.
```

### Code structure and development rationale

Immutag was originally written in rust. However, after a design pivot it became clearer that the aim is be more explicitly agnostic towards it's database (currently text files), metadata versioning (currently git), blob versioning (currently git-annex), blockchain, and other technologies it uses. Therefore, the program is glued together with command line apps and shell scripts. That also means the software can be under and MIT license even though it may call copy-left programs. While efforts may be made in alternate implementations to move functionality into libraries in whole or in part, at the moment there is no urgent plans to do so. However, because everything is so modular other developers can break of little pieces of immutag for refactoring and radually transition the software towards their requirements.

All of the shell scripts are in `src/`. Everything mostly works together using pipes. Again, that means conservatively it can be remain under MIT license and not depend on any code that is under GPL.

## File list: the metadata
The metadata/file-list has the following entries for each tagging operation.


`<index> <address> <store-hash> <tags..>`

Default content-address headers are below. (Future versions will allow the user to easily add other content-addresses).

```
sha256: <sha256>
ipfs <version>: <ipfs-addr>
git-annex <version>: <commit-master> <commit-git-annex>
```

Each line can have as many hashes as is needed. For example, in addition to git-annex oid, it's useful to include the git-annex metadata oid.

Rollbacks are enabled with git-annex. Remember, each generation of the file list also contains the store's sha256 and ipfs addr.

### Use cases

It's immediately useful for managing your media files, such as images, music, and video. However, it has broad use. For example, it can act as distributed sofware repo if the directory of the repo is flattened into a single file, likely .tar before getting copied into it's store. Really it can used on any type of files, whether version control is needed or not.

Other possibilities:

* Web app and software distribution.

* Distributed software repo hosting.

* Package management.

* Archive services.

There all sorts of other uses cases that are yet envisioned.

## Test

Make sure you are in the `tests/` directory before running tests, otherwise tests will fail.

**Run all tests**

`./test.sh run all --sudo --hard-start`

If you don't need sudo to run docker, omit the sudo flag. `--hard-start` restarts the docker container for fresh test runs.

**Run specific test**

`./test.sh run TEST_CASE [--sudo] [--hard-start]`

See `test.sh` for a list of test cases.

## Useful info

While in fzf, find tags with exact matches use single quote ('). Say you want to find a file with a `foo` and `bar` tag:

`imt find`

...now in fzf:

`'foo 'bar`

Suggestion: to open a file, use xdg-open or some other automtic file-opener.

`xdg-open $(imt find)`

## Works with

* hal: 0.7.2
* sed: 4.2.2
* cut (GNU coreutils) 8.25
* git: 2.3
* git-annex: 8.20210127
* jq: 1.5

## Other possibilities

This may open up creating a modular nix type of file management for 'free'. That is immutag can be instantiated in more than one place, like git, if the user is allowed to modify the bin directory with symlinks of their own from the file store. The version of the bin files can be ascertained from the metadata and searched like any other immutag file. The exact content hashes of each file version can be extracted from git-annex's tree.

See how the file store opens up a similar setup as nix. Below is the jq binary symlink relationship (`ls -l`) of jq (a json cli tool) on a system running a nix package manager.

lrwxrwxrwx 1 7db9a wheel 61 Dec 31  1969 /nix/store/q4q25qih2ychclzggwhw715p7v3jbn9g-user-environment/bin/jq -> /nix/store/hjcxlrdbw1v07y4wp19vm5k1i3l1l5bz-jq-1.6-bin/bin/jq


## Todo

- [ ] Add or update ipfs addr in store-addresses file on each file add or update.
- [ ] Rollback or forward to when a specific file was changed.
- [ ] High-level commands to sync files between imt users: `imt rollback --file ADDR`
- [ ] List generations by specific file: `imt list-generations --file ADDR`.
- [ ] Remove file and tags (address stays): `imt remove-file`
- [ ] High-level commands to sync metadata and files between users.
- [ ] Add ipfs support.

## Notes

Metadata (file list) and data (store) should be seperate. The file list should have all the relevant store hashes. That way there is a single point of entry from a file address.

```
ledger:
    address:
       ipfs-address ----> store's ipfs-address and sha256
       sha256       ----> verify store.
```
The user can then fetch the metadata from that. From the metadata, the hashes of the the store can be found.

There is no way to convert an ipfs hash directly from a sha256. ipfs chunks the files in a particular way. Additionally, there's nothing preventing different ipfs versions from chunking differently.

https://www.reddit.com/r/ipfs/comments/6qw39w/convert_sha256_to_ipfs_hash/
