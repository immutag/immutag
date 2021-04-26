#!/usr/bin/env bash

name="$1"
addr="$2"
file="$3"

immutag_path="$HOME/immutag"

mv $file "$immutag_path"/"$name"/files/"$addr"
echo "update file: $file"
_imt_commit "$name"
