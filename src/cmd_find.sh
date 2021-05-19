#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"
find_type="$2"

cd $immutag_path
cd $name


output=$(_imt_print_list_only | fzf --layout=reverse| cut -d " " -f 2)

file_path=$(eval realpath files/"$output")

if [ "$find_type" = "addr" ]; then
    echo "$output"
else
    echo "$file_path"
fi
