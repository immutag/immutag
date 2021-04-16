#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"

cd "$immutag_path" || exit
rsync -a --copy-links "$name" /tmp/ \
--exclude wallet-info \
--exclude .git \
--exclude files/.git \

wormhole send "$name"
