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

_imt_print_list_only | _imt_new_index_addr | _imt_append_list "$metadata" | _imt_add_file "$file"
