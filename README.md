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

The files are discoverable on on a distributed file network created with git-annex, but ipfs or something else can be used. Again, everything can be kept as local as the user wants and can be kept offline. The files are found by author created tags and metadata. Anyone can copy files that are pushed to the internet and create their own tags, but the chronology will always show who was the early author.

### Versioning

Every file version can be cryptographically reconstructed. The local file store uses git-annex. That also gives the user a distributed versioned file system and sharing. There are plans to make ipfs work out-of-the-box, but developers can drop-it-in on their own. The metadata and tags are stored locally on a single file. It's versioned with git. That means any updates to the tags or metadata can be cryptographically mapped to a specific version of the file (remember, it's on git-annex).

## Use cases

It's excellent for managing media files, such as images, music, and video but it can be used for any files, including software repositories (immutag will flatten them into a single file, likely .tar) before copying it into it's store. Really it can used on any type of files, whether version control is needed or not.

## Test

`./add_file_test.sh`

## Overview

An initialized immutag content directory has the following structure.

```
.immutag
├── metadata
│   ├── file-list.txt | Maps globally addressed files to metadata.
│   ├── .git          | Content hashes found by traversing tree.
├── files             | Store of globally addressed files.
│   ├── 17nZVxS       | Version and distrubtion via git-annex,
│   └── 1CaKbES       | but ipfs or other can be drop-in-replace.
│   └── ...
│   ├── .git
│       ├── git-annex
├── wallet_info.json  | Bitcoin wallet seed, including mnemonic.
```

Immutag's scripts have the following directory structure. The scripts pipe from one another, making it functional and easy to upgrade, refactor, and maintain.

```
.immutag-share
├── bin
    ├── add_file.sh
    ├── address_create_pubkey.sh
    ├── append_list.sh
    ├── bip32_derive.sh
    ├── bip32_derive_m44_hd.sh
    ├── bip39_get_seed.sh
    ├── bip44_info_derive_from_xpriv.sh
    ├── cmd_add.sh
    ├── create_wallet_info_file_from_mnemonic.sh
    ├── find_fuzzy.sh
    ├── generate_bip39.sh
    ├── generate_from_24_word_mnemonic.sh
    ├── get_bip44_address_from_xpriv.sh
    ├── get_rid_of_quotation_marks.sh
    ├── get_xpriv_from_wallet_info.sh
    ├── json_parse_p2pkh_address.sh
    ├── new_addr.sh
    ├── new_index_addr.sh
```

The above directory will be added to the users path.

## Useful info

While in fzf, find tags with exact matches use `'`: say you want to find a file with a `foo` and `bar` tag.

`imt find`

`'foo 'bar`

Suggestion: to open a file, use xdg-open or some other clever file-opener.

`xdg-open $(imt find)`

## Works with

* hal (rust hal): 0.7.2
* sed (GNU sed) 4.2.2
* cut (GNU coreutils) 8.25
