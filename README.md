# Immutag

An experimental immutable and distributed filesystem that can be searched by tags and other metadata. The software's components are interchangeable so that users and developers aren't locked-down. The software's protocol can be rewritten in any language for use by servers, web browsers, or embedded devices.

Files and tags can be seperately pushed to distributed stores (e.g. ipfs) or ledgers (e.g. bitcoin) making them globally discoverable. However, the user can choose to keep all or some of the data offline or on a local network. And file authors can cryptographically prove the authenticity and chronology of their creations.

This is a working prototype glued together with bash scripts, but it's modular, functional in style, and tested. A pivot in the design of underlying protocol would have resulted in a laborous re-write in a compiled language. See 7db9a/immutag.

**WARNING**: this readme may not always accurately reflect the state of the software as this is a work-in-progress.

## Example

Initialize an immutag content directory with a bitcoin mnemonic.

`imt init <dir> <mnemonic>`

`imt init my-dir "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"`

Add a music file with tags that can be used to find it later.

`imt add <file> <tags...>`

`imt add Vivaldi\ -\ Four\ Seasons.mp3 music vivaldi classical`

1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2

1Akbr is the file name to immutag. It's copied into a immutag's file store, which is simply a directory versioned by git-annex.

Finalize changes.

`imt commit`

Since we likely won't remember the long global file address, we can search for it by tag or metadata.

`imt find`

A menu of all the files will appear. Start typing terms such as, `mp3`, `vivaldi`, `music`, or `classical` to find it. When you select the one you want, imt will spit out the full file name 1AkbrXgctNNu7VBfSk8XZgCKRAV7HtTcj2, in this case. That can be pipped into whatever you want or copied to open it up.

For example, open a file with xdg-open.

`xdg-open $(imt find)`

Actually, the find file menu may appear familiar. It's fzf: a cli utility to find files.

## Install (dev)

Clone this repo, change into it, and then

```
docker volume create --name=immutag-cargo-data
docker build -t immutag:0.0.2 .
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

`imt push <distributed-ledger>`

each immutag address records a message stating it's an immutag address and what version of the protocol it's using. The only other messages (unless the protocol is updated) will be the content-addressable hash (versions) of the file-list. When a user fetches the data from the distributed-ledger, it only needs the single content-addressable hash to immutably build all the metadata and files. That way only the bare-minimum has to be pushed to a distributed ledger. All the data is pulled from a distributed file network, such as ipfs. As few or much of the versions (content addresses) can be pushed to the ledger.

### Versioning

Every file version can be cryptographically reconstructed. The local file store uses git-annex. That also gives the user a distributed versioned file system and sharing. There are plans to make ipfs work out-of-the-box, but developers can drop-it-in on their own. The metadata and tags are stored locally on a single file. It's versioned with git. That means any updates to the tags or metadata can be cryptographically mapped to a specific version of the file (remember, it's on git-annex).

A user can roll the state of immutag backwards and forward and also show the generations.

`imt rollback [generation]`

`imt generation`

`imt rollforward [generation]`

immutag is made up of two version controlled directories: metadata and store. immutag looks up the store hash from the file list. immutag automatically records the store's hash on each tagging operation to the file-list header.

### Directory and file structure

An immutag directory has the following structure and includes everything needed for immutag to work. The idea is to allow the user to initialize immutag wherever they please on the host filesystem, like with git. It may be best to avoid having a global vs local install system, which adds complications. Perhaps the user just chooses how they want to set it up. If they want a global-like setup, they can earmark a specific immutag directory that will be for systemwide efforts.

```
$HOME/immutag
├── account
│   ├── wallet_info.json| Bitcoin wallet seed, including mnemonic.
├── metadata
│   ├── file-list.txt | Maps globally addressed files to metadata.
│   ├── .git          | Content hashes found by traversing tree.
├── store             | Store of globally addressed files.
    ├── 17nZVxS
    ├── 1CaKbES
    ├── ...
    ├── .git          | Version and distrubtion via git-annex,
        ├── git-annex | but ipfs or other can be dropped in on top.
```

The metadata/file-list has the following entries for each tagging operation.

`<index> <address> <store-hash> <tags..>`

In addition to this, there is a permanent two-line header on the file recording the store's content addressable hash and its git oid. When immutag rolls backwards or forward, it can then checkout the store's repo at the correct commit height.

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
