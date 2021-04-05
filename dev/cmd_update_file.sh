#!/usr/bin/env bash

name="$1"
addr="$2"
file="$3"

immutag_path="$HOME/immutag"

cd $immutag_path
cd $name


mv $file files/"$addr"
echo "update file: $file"
_imt_commit "$name"
