# Immutag

An experimental immutable and distributed filesystem that can be searched using tags and other metadata. Files are globally discoverable, but it can be kept to a local network or even a single machine. Files can be distributed in a like manner. File authors can cryptographically prove the authenticity and chronology of their creations. Worldwide. No vendor-lock. All the parts are interchangeable and it's useful to an individual or a community. It's really a protocol so it can be written in any language for use by servers to web browsers to embedded devices.

This is a working prototype glued together with bash scripts, but it's modular, functional in style, and tested. A pivot in the design of underlying protocol would have resulted in a laborous re-write in a compiled language. See 7db9a/immutag.

**WARNING**: this readme may not always accurately reflect the state of the software as this is a work-in-progress.

## Example

Add a music file with tags that can be used to find it later.

`imt add Vivaldi\ -\ Four\ Seasons.mp3 music vivaldi classical`

1F2qMp82j3BLopARtHM91SqvEgXWzKNoDB

What we did in general.

`imt add <file> <tags...>`

1F2qM is the file name to immutag. It's copied into a immutag's file store, which is simply a directory versioned by git-annex.

Since we likely won't remember the long global file address, we can search for it by tag or metadata.

`imt find`

A menu of all the files will appear. Start typing terms such as, `mp3`, `vivaldi`, `music`, or `classical` to find it. When you select the one you want, imt will spit out the full file name 1F2qMp82j3BLopARtHM91SqvEgXWzKNoDBA, in this case. That can be pipped into whatever you want or copied to open it up.

For examaple, open it up with xdg-open (automatically opens the file with the appropriate default or user defined software, such as a browser.)

`xdg-open $(imt find)`

Actually, the find file menu may appear familiar. It's literally fzf, a cli utility to find files.

## Installation

Coming soon..

## How it works

### Global address

All files have a bitcoin (global) address. The user supplies their own private keys or mnemonic. Bitcoin can be interchanged with something else, such as Ethereum. A user can even avoid supplying immutag with private info if they don't mind manually entering bitcoin addresses from their wallets. The idea is to make it work with one of those hardware wallets as well. At the moment, various low-fee and reliable bitcoin forks are the target.

### Distribution and sharing

The files are discoverable on a distributed file network created with git-annex, but ipfs or something else can be used. Again, everything can be kept as local as the user wants and can be kept offline. The files are found by author created tags and metadata. Anyone can copy files (i.e., forking) that are pushed to the internet and create their own tags, but the chronology will always show who was the early author.

### Versioning

Every file version can be cryptographically reconstructed. The local file store uses git-annex. That also gives the user a distributed versioned file system and sharing. There are plans to make ipfs work out-of-the-box, but developers can drop-it-in on their own. The metadata and tags are stored locally on a single file. It's versioned with git. That means any updates to the tags or metadata can be cryptographically mapped to a specific version of the file (remember, it's on git-annex).

## Use cases

It's excellent for managing media files, such as images, music, and video but it can be used for any files, including software repositories (immutag will flatten them into a single file, likely .tar) before copying it into it's store. Really it can used on any type of files, whether version control is needed or not.

## Test

`./add_file_test.sh`

## Overview

An immutag directory has the following structure and includes everything needed for immutag to work. The idea is to allow the user to initialize immutag wherever they please on the host filesystem, like with git. To keep it simple and consistent, even if the immutag source code exists in one directory already, it will be included in any other initialized directories. Likely there will be no global vs local install system, which adds complications. Perhaps the user just chooses how they want to set it up. If they want a global-like setup, they can earmark a specific immutag directory that will be for systemwide efforts.

```
$HOME/immutag
├── account
│   ├── wallet_info.json| Bitcoin wallet seed, including mnemonic.
├── metadata
│   ├── file-list.txt | Maps globally addressed files to metadata.
│   ├── .git          | Content hashes found by traversing tree.
├── files             | Store of globally addressed files.
    ├── 17nZVxS
    ├── 1CaKbES
    ├── ...
    ├── .git          | Version and distrubtion via git-annex,
        ├── git-annex | but ipfs or other can be dropped in on top.
├── bin
    ├── $addr/add_file
    ├── $addr/address_create_pubkey
    ├── $addr/append_list
    ├── $addr/bip32_derive
    ├── $addr/bip32_derive_m44_hd
    ├── $addr/bip39_get_seed
    ├── $addr/bip44_info_derive_from_xpriv
    ├── $addr/cmd_add
    ├── $addr/create_wallet_info_file_from_mnemonic
    ├── $addr/find_fuzzy
    ├── $addr/generate_bip39
    ├── $addr/generate_from_24_word_mnemonic
    ├── $addr/get_bip44_address_from_xpriv
    ├── $addr/get_rid_of_quotation_marks
    ├── $addr/get_xpriv_from_wallet_info
    ├── $addr/json_parse_p2pkh_address
    ├── $addr/new_addr
    ├── $addr/new_index_addr
```

The bin directory will be added to the user's path. These immutag bin files should be symlinked from the file store. The exact versions of immutag can now be determinstically rolled backwards and forward. This may open up [other possibilities](#other-possibilities).

## Useful info

While in fzf, find tags with exact matches use `'`: say you want to find a file with a `foo` and `bar` tag.

`imt find`

`'foo 'bar`

Suggestion: to open a file, use xdg-open or some other clever file-opener.

`xdg-open $(imt find)`

## Works with

* hal: 0.7.2
* sed: 4.2.2
* cut (GNU coreutils) 8.25
* git: 2.3
* git-annex: 8.20210127

## Other possibilities

This may open up creating a modular nix type of file management for 'free'. That is immutag can be instantiated in more than one place, like git, if the user is allowed to modify the bin directory with symlinks of their own from the file store. The version of the bin of the bin files can be ascertained from the metadata and searched like any other immutag file. The exact content hashes of each file version can be extracted from git-annex's tree.

See how the file store opens up a similar setup as nix. Below is the jq binary symlink relationship (`ls -l`) of jq (a json cli tool) on a system running a nix package manager.

lrwxrwxrwx 1 7db9a wheel 61 Dec 31  1969 /nix/store/q4q25qih2ychclzggwhw715p7v3jbn9g-user-environment/bin/jq -> /nix/store/hjcxlrdbw1v07y4wp19vm5k1i3l1l5bz-jq-1.6-bin/bin/jq
