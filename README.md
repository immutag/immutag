# Immutag

An experimental immutable and distributed metadata system that can be used to search and fetch files on local and distributed filesystems. Users find files with tags they create. The software's components are interchangeable so that users and developers aren't locked-down. The software's protocol can be rewritten in any language for use by servers, web browsers, or embedded devices.

Metadata is be seperately pushed to distributed stores (e.g. ipfs) or ledgers (e.g. bitcoin), making them globally discoverable. However, the user can choose to keep all or some of the data offline or on a local network. And file authors can cryptographically prove the authenticity and chronology of their creations.

This is a working prototype glued together with bash scripts, but it's modular, functional in style, and tested. A pivot in the design of underlying protocol would have resulted in a laborous re-write in a compiled language. See 7db9a/immutag.

**WARNING**: this readme may not always accurately reflect the state of the software as this is a work-in-progress.

## Example

Create an immutag store with a bitcoin mnemonic.

`imt create <store-name> <mnemonic>`

`imt create music "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"`

Add a music file with tags that can be used to find it later.

`imt add <store-name> <file> <tags...>`

`imt add music Vivaldi\ -\ Four\ Seasons.mp3 music vivaldi classical`

1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2

1Akbr is the file name to immutag. It's copied into a immutag's file store, which is simply a directory versioned by git-annex.

`imt find music`

A menu of all the files will appear. Start typing terms such as, `mp3`, `vivaldi`, `music`, or `classical` to find it. When you select the one you want, imt will spit out the full file name 1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2, in this case. That can be pipped into whatever you want or copied to open it up.

For example, open a file with xdg-open.

`xdg-open $(imt find music)`

Actually, the find file menu may appear familiar. It's fzf: a cli utility to find files.

To add a tag to a file already tagged.

`imt add-tag <store-name> <file-addr> <tags...>`

So for example to add the tag 'name=four-seasons' to our vivaldi four seasons song:

`imt add-tag music "$(imt find --address main)" name=four-seasons

If we happen to remember the name, we can just search

`name=four-seasons` or something thereabouts with `imt find music`

## Install (dev)

Clone this repo, change into it, and then

```
docker volume create --name=immutag-cargo-data
docker build -t immutag:0.0.3 .
```

At the moment, the install is for a development environment and not for user distribution.

## Dev workflow

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

To jump to test info, see [here](#test).

## How it works

### Global address

All files have a bitcoin (global) address. The user supplies their own public key, private keys or mnemonic. Bitcoin can be interchanged with something else, such as Ethereum. Various low-fee and reliable bitcoin forks are the targets for the distributed ledger.

### Distribution and sharing

The files are discoverable on a distributed file network created with git-annex, but ipfs or something else can be used. Again, everything can be kept as local as the user wants and can be kept offline. The files are found by author created tags and metadata. Anyone can copy files (i.e., forking) that are pushed to the internet and create their own tags, but the chronology will always show who was the early author.

If pushed to a distributed ledger:

`imt push <store-name> <distributed-ledger>`

each immutag address records a message stating it's an immutag address and what version of the protocol it's using. The only other messages (unless the protocol is updated) will be the content-addressable hash (versions) of the file-list. When a user fetches the data from the distributed-ledger, it only needs the single content-addressable hash to immutably build all the metadata and files. That way only the bare-minimum has to be pushed to a distributed ledger. All the data is pulled from a distributed file network, such as ipfs. As few or much of the versions (content addresses) can be pushed to the ledger.

### Versioning

Every file version can be cryptographically reconstructed. The local file store uses git-annex. That also gives the user a distributed versioned file system and sharing. There are plans to make ipfs work out-of-the-box, but developers can drop-it-in on their own. The metadata and tags are stored locally on a single file. It's versioned with git. That means any updates to the tags or metadata can be cryptographically mapped to a specific version of the file (remember, it's on git-annex).

A user can roll the state of immutag backwards and forwards and list the generations.

`imt rollback <store-name>`

`imt list-generations <store-name>`

`imt rollforward <store-name>`

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

## File list: this metadata
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

Setup, run, and teardown tests

`test/.<script> hard-start`

For a faster dev and test cycle, run against an already running container from `hard-start`.

`test/.<script>`


## Useful info

While in fzf, find tags with exact matches use `'`: say you want to find a file with a `foo` and `bar` tag:

`imt find`

...now in fzf:

`'foo 'bar`

Suggestion: to open a file, use xdg-open or some other clever file-opener.

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
