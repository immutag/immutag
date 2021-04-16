#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"

cd "$immutag_path" || exit
cd "$name" || exit

# Send file-list git
wormhole send .git
