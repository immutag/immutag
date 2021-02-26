#!/bin/bash

arg="$1"

output=$(cat file-list.txt | fzf | cut -d " " -f 2)

if [ "$arg" = "addr" ]; then
    echo "$output"
else
    echo "$PWD/files/$output"
fi
