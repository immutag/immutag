#!/usr/bin/env bash

dir_path="$1"
mnemonic="$2"


mkdir "$dir_path"
mkdir "$dir_path"/files
echo "store sha256" > "$dir_path"/file-list.txt
echo "\nstore oid:" >> "$dir_path"/file-list.txt
echo "" >> "$dir_path"/file-list.txt

cd "$dir_path"
echo "$mnemonic" | _imt_create_wallet_info_file_from_mnemonic
git init
cd  files
git init
git annex init
