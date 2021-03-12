#!/bin/bash

# $ add *name* file tags...

immutag_path="$HOME/immutag"

input="$@"

name=$(echo "$input" | cut -d " " -f 1)

file=$(echo "$input" | cut -d " " -f 2)
file_abs_path=$(eval realpath "$file")

fullfilename="$file"
filename=$(basename "$fullfilename")
fname="${filename%.*}"
ext="${filename##*.}"

tags=$(echo "$input" | cut -d " " -f 3-)
metadata=$(echo "$fname" "$ext" "$tags")

echo "$file"
echo "$metadata"

cd "$immutag_path" || exit
cd "$name" || exit


addr=$(eval _imt_print_list_only | _imt_new_index_addr | _imt_append_list "$metadata")

cp "$file_abs_path" files/"$addr"
