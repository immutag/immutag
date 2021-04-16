#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"

cd "$immutag_path" || exit
cd "$name" || exit

mkdir /tmp/immutag-git
cp -r .git /tmp/immutag-git/.git

cd /tmp/immutag-git
git reset HEAD --hard

git checkout --orphan temp
git add -A
git commit -am "update"
git branch -D master && git branch -m master

# Send file-list git
wormhole send .git
