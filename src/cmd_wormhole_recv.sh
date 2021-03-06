#!/bin/bash
immutag_path="$HOME/immutag"

name="$1"

cd "$immutag_path" || exit

# Move out wallet-info from user previously created store.
mv "$name"/wallet-info /tmp/immutag-1492

# Receive store.
mkdir /tmp/immutag-"$name"
cd /tmp/immutag-"$name"
wormhole receive

# Remove old store
cd "$immutag_path" || exit
rm -r "$name"

# Move in received store
mv /tmp/immutag-"$name"/immutag-wormhole "$name"

# Copy over wallet info into new store.
rsync -a /tmp/immutag-1492 "$name"/
mv /tmp/immutag-1492 "$name"/wallet-info
rm "$name"/immutag-1492


# Initial version control.
cd "$immutag_path"/"$name"

git init > /dev/null 2>&1
git config user.email "immutag"
git config user.name "immutag"
cd  files || exit
git config user.email "immutag"
git config user.name "immutag"
git init > /dev/null 2>&1
git annex init > /dev/null 2>&1

_imt_commit "$name"
