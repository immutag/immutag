#!/bin/bash

# $ add *name* file tags...

immutag_path="$HOME/immutag"

input="$*"

name=$(echo "$input" | cut -d " " -f 1)

file=$(echo "$input" | cut -d " " -f 2)
file_abs_path=$("$immutag_path"/stage/"$file")

echo "file abs path"
echo "$file_abs_path"
echo ""

# Exit script here if we can't find the file to be added to the store.
if [ ! -f "$file_abs_path" ];then
    echo "Can't find file."
    exit
fi

## To add file name and extension to tag.
#fullfilename="$file"
#filename=$(basename "$fullfilename")
#fname="${filename%.*}"
#ext="${filename##*.}"
#
#tags=$(echo "$input" | cut -d " " -f 3-)
#metadata=$(echo "$fname" "$ext" "$tags")

tags=$(echo "$input" | cut -d " " -f 3-)
metadata=$(echo "$tags")

echo "add file: $file"
echo "tags: $metadata"

addr=$(eval _imt_print_list_only | _imt_new_index_addr | _imt_append_list "$metadata")

# Get file/* into an array and fail if new file already exists.
echo "test"
arr=("$immutag_path"/"$name"/files/*)
for ((i=0; i<${#arr[@]}; i++)); do
    echo "${arr[$i]}"
    cmp --silent "$file_abs_path" "${arr[$i]}" && echo "File already exists." && exit
done

# cmp each agains file to see if already exists

mv "$file_abs_path" files/"$addr"

_imt_commit "$name"
