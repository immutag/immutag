#!/bin/bash

index_addr="$(</dev/stdin)"
tags="$@"

echo "$index_addr $tags" >> $HOME/projects/work/immutag-nu/dev/file-list.txt

new_addr=$(echo "$index_addr" | cut -d " " -f 2)

echo "$new_addr"
