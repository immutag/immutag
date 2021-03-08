#!/bin/bash

# $ add *name* file tags...

name="$1"

immutag_path="$HOME/immutag"

cd "$immutag_path"
cd "$name"

get_gen() {
    tmp_file_name=$(eval cat file-list.txt | sha256sum | head -c 64)

    generation_sha256=$(eval cp store-addresses /tmp/immutag-state-"$tmp_file_name" && cat file-list.txt >> /tmp/immutag-state-"$tmp_file_name" | cat /tmp/immutag-state-"$tmp_file_name" | sha256sum | head -c 64)

    echo "$generation_sha256"
}

get_gen
