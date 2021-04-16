#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"

cd "$immutag_path" || exit

cd "$name" || exit

mv wallet-info /tmp/immutag-wallet-info

cd .. && rm -r "$name"

mkdir "$name"

cd "$name" || exit

# Receive .git
wormhole receive

# Make sure there is nothing but .git here
git reset HEAD --hard

mv /tmp/immutag-wallet-info wallet-info
