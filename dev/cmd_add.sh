#!/bin/bash

# $ add file tags...

input="$@"

file=$(echo "$input" | cut -d " " -f 1)

fullfilename="$file"
filename=$(basename "$fullfilename")
fname="${filename%.*}"
ext="${filename##*.}"

tags=$(echo "$input" | cut -d " " -f 2-)
metadata=$(echo "$fname" "$ext" "$tags")

echo "$file"
echo "$metadata"

cat file-list.txt | ./new_index_addr.sh | ./append_list.sh "$metadata" | ./add_file.sh "$file"
