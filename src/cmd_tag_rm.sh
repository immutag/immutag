#!/usr/bin/env bash

addr="$(</dev/stdin)"
name="$1"

immutag_path="$HOME/immutag"

cd $immutag_path
cd $name

echo "$addr" | _imt_tag_rm file-list.txt

_imt_commit "$name"
