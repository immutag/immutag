#!/bin/bash

arg="$1"

output=$(_imt_print_list_only | fzf | cut -d " " -f 2)

if [ "$arg" = "addr" ]; then
    echo "$output"
else
    echo "$PWD/files/$output"
fi
