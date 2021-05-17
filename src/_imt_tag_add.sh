#!/usr/bin/env bash

input="$@"

filelist=$(echo "$input" | cut -d " " -f 1)
tags=$(echo "$input" | cut -d " " -f 2-)

addr="$(</dev/stdin)"
line="$(eval rg $addr $filelist)"
#echo "$line"
line_old_tags="$(eval echo "$line" | cut -d ' ' -f 2-)"
echo "$line_old_tags $tags"

sed -i "s/$line/$line $tags/" $filelist
