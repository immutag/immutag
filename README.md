# Immutag

Immutag is an experimental distributed file manager. Users add content-addressed files with tags. Files are found by searching tags. Files can be stored and shared on network or locally. The software's components are interchangeable so that users and developers aren't locked-down. The software's protocol can be rewritten in any language for use by servers, web browsers, or embedded devices. Full implentation will use bitcoin and ipfs, but other services can be dropped in its place. Right now, sharing is possible 'directly'.


**CAVEATS** This readme may not always accurately reflect the state of the software as this is a work-in-progress. The software is experimental and in alpha stage. In fact, it's prototype glued together with shellscripts. If the design choices and code structure seems confusing to you, please jump [here to learn more about the rationale](#code-structure-and-development-rationale).

Again, you dont' need to buy or use bitcoin to make use of most of the features of immutag, so go right ahead and jump in.

**Create an immutag store with a bitcoin mnemonic.**

`imt create "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"`

Give immutag dir permissions.

`sudo chmod -R 777 ~/immutag`

You can also create named stores and do operations against named stores with `--store-name NAME`.

For actual use, please retreive or generate the mnemonic from elsewhere, such as with you bitcoin wallet app. It should be a wallet specifically designated from immutag use and not have 'money' on it. At the moment, immutag stores the wallet insecurely for development purposes. In the future, immutag will encrypt the wallet in addition to creating local api endpoints that can accept bitcoin addresses without the need for storing private keys or mnemonics.

**Add a music file with tags that can be used to find it later.**

`imt add "vivaldi-four-seasons.mp3" music vivaldi classical`

1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2

1Akbr is the file name to immutag. It's copied into a immutag's file store, which is simply a directory versioned by git-annex.

**To find files by tags.**

`imt find`

A menu of all the files will appear. Start typing terms such as, `mp3`, `vivaldi`, or `classical` to find it. When you select the one you want, imt will spit out the full file name 1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2, in this case. That can be pipped into whatever you want or copied to open it up.

For example, open a file with xdg-open.

First select the file

`imt find`

Then open it by symlink.

`xdg-open $(cat ~/immutag/file)`

At the moment the 2 steps above to open a file are neccessary because immutag is containerized for closs-platorm. The plan is to elimate this soon so that all one needs to do is something like `xdg-open $(imt find)`.

Actually, the find file menu may appear familiar. It's fzf: a cli utility to find files.

**To add a tag to a file already tagged.**

So for example to add the tag 'name=four-seasons' to our vivaldi four seasons song:

`imt find --addr`

`imt add-tag music "$(cat ~/immutag/addr)" name=four-seasons`

If we happen to remember the name, we can just search

`name=four-seasons` or something thereabouts with `imt find music`

**To replace all the tags with new ones for the file.**

`imt replace-tags FILE_ADDR TAGS...`

You'll select the file from the menu.

`imt find --addr`

`imt replace-tags $(cat ~/immutag/addr) renaissance orchestral italy`

**To update a file.**

`imt update ADDR FILE`

Let's say we remastered that vivaldi track and we want to update the file to latest.

Select the file so that it get's outputed to a file called addr.

`imt find --addr`

Now update file with that address.

`imt update $(cat ~/immutag/addr) remaster-vivaldi-four-seasons.mp3`

By the way, all of this operations can be rolled back and forward with `imt rollback` and `imt rollforward`.

**Sharing store's with others**

Metadata can be pushed to distributed stores (e.g. ipfs) or ledgers (e.g. bitcoin), making them globally discoverable. However, it works well for purely offline use. Full implementation is forthcoming.

Right now you can do it without bitcoin and share 'direct' with your friends thanks to [magic-wormhole](https://github.com/magic-wormhole/magic-wormhole) (a non-cloud file sharing tool). However, other 'direct' file sharing tools can be dropped in place by developers, including new forks of magic-wormhole.

The sender.

`imt wormhole-send --store-name NAME`

The sender immediately gets code they can message to the receiver. Just use your favorite messaging app or even do it over the phone. Once the the receiver downloads, the code is no longer is useable.


The receiver must first create an empty store that can be used to receive. The receiver can name their store whatever they want and doesn't need to match the sender.
```
imt create --store-name NAME "MNEMONIC"
imt wormhole-recv --store-name NAME
```

## Install

Clone the immutag and the cli and depending on the version of git you have...

`git clone --recursive -j8 https://github.com/immutag/immutag`

`git clone --recursive -j8 https://github.com/immutag/imt-cli`

or

`git clone --recursive-submodules -j8 https://github.com/immutag/immutag`

`git clone --recursive-submodules -j8 https://github.com/immutag/imt-cli`


You'll need docker installed.

```
cd immutag
docker volume create --name=immutag-cargo-data
docker volume create --name=nix-data
docker build -t immutag:0.0.11 .
```

`cd ../imt-cl`
`cargo build --bin imt-cli`

Copy the binary somewhere in your $PATH.

`cp target/debug/imt-cli ~/.local/bin/imt`


At the moment, the install is for a development environment and not for user distribution.

### Install (dev test)

You'll need docker installed.


```
mv Dockerfile.cli Dockerfile
docker build -t immutag-test:0.0.1 .
```

```
docker volume create --name=immutag-cargo-data
docker volume create --name=immutag-cargo-data-b
docker volume create --name=nix-data
docker volume create --name=nix-data-b
docker build -t immutag-test:0.0.1 .
```

To run all tests

```
cd tests
./test.sh run all --sudo --hard-start
```

Make sure to restore the Dockerfiles with `git restore Dockefile.cli Dockerfile` when not testing.

## Dev workflow

It's recommended that run tests first. To jump to test info, see [here](#test).

To run all tests (make sure you followed dev test install instructions).

```
cd tests
./test.sh run all --sudo --hard-start
```

Omit the sudo flag if you don't require sudo to run docker.

Every time you edit the code base,

`docker build -t immutag-test:0.0.1 .`

if your testing or if your using the cli

`docker build -t immutag-test:0.0.11 .`

To launch and work wth imt in the container.

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

At the moment, users can share 'directly' with one another thanks to [magic-wormhole](https://github.com/magic-wormhole/magic-wormhole). The commands are `imt wormhole-send` and `imt wormhole-recv`.

No blockchain records or cloud service. However, by immutag's nature, files can be made discoverable on a distributed file network.

If push or publish a store to a distributed ledger will soon look something like this

`imt push --store-name STORE_NAME LEDGER_NAME`

The files won't be stored on the blockchain, just the content-addresses. That way ipfs can be used to distribute files.

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

You don't need to acquire any bitcoin or tokens or use the bitcoin network if you choose. You can keep all or some of the data offline or on a local network. If you choose to make use of bitcoin's network, you can cryptographically prove the authenticity and chronology of your creations.

This is a working prototype glued together with bash scripts, but it's modular and refactorable. A pivot in the design of underlying protocol would have resulted in a laborous re-write in a compiled language. See 7db9a/immutag.

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
* rsync: 3.1.3
* magic-wormhole: 0.12.0

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

### Docker app

Put the `imt_host` script somewhere in the host's path as `imt`.

`cp imt_host ~/.local/bin/imt`

Build the image for docker app.
```
mv Dockerfile.cli Dockerfile
sudo docker build -t immutag:0.0.11 .
```

Create default store.
```
sudo docker run \
-v /home/daveamd/immutag:/root/immutag \
immutag:0.0.11 \
create "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"
```

Give host permission over immutag stores.

`sudo chmod -R 777 ~/immutag`

Add command must be ran from imt_host script.

`imt add FILE TAGS`

Find command must be ran from imt_host script.

`imt find`
