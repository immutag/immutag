#!/usr/bin/env bash

addr="$(</dev/stdin)"

immutag_path="$HOME/immutag"

input="$@"
name=$(echo "$input" | cut -d " " -f 1)
tags=$(echo "$input" | cut -d " " -f 2-)

cd $immutag_path
cd $name

echo "$addr" | _imt_tag_replace file-list.txt "$tags"
