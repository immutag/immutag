#!/bin/bash

# $ add *name* file tags...

name="$1"

immutag_path="$HOME/immutag"

cd "$immutag_path"
cd "$name"

get_gen() {
    tmp_file_name=$(eval cat file-list.txt | sha256sum | head -c 64)

    tar -cvf /tmp/immutag-state-"$tmp_file_name" file-list.txt store-addresses &> /dev/null
    generation_sha256=$(echo /tmp/immutag-state-"$tmp_file_name" | sha256sum | head -c 64)

    echo "$generation_sha256"
}

get_gen
