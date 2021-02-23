#!/bin/bash

output=$(cat file-list.txt | fzf | cut -d " " -f 2)

echo "$PWD/files/$output"
