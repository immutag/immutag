#!/usr/bin/env bash

name="$1"
addr="$2"
file="$3"

immutag_path="$HOME/immutag"

# Compares files and gives appropriate exit_update code.
cmp --silent "$file" "$immutag_path"/"$name"/files/"$addr" && exit_update="2" || exit_update="0"

if [ "$exit_update" = "0" ];then
    mv $file "$immutag_path"/"$name"/files/"$addr"
    echo "update file: $file"
    _imt_commit "$name"
else
    echo "Update failed: already the current file version."
fi
