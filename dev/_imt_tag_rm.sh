#!/usr/bin/env bash

filelist="$1"
addr="$(</dev/stdin)"
line="$(eval rg $addr $filelist)"
echo "$line"
line_no_tags="$(eval echo "$line" | cut -d ' ' -f 1-2)"
echo "$line_no_tags"

sed -i "s/$line/$line_no_tags/" $filelist
