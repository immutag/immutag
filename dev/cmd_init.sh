#!/usr/bin/env bash

dir_path="$1"
mnemonic="$2"

mkdir "$HOME"/immutag

cd "$HOME"/immutag || exit

mkdir "$dir_path" || exit
mkdir "$dir_path"/files
echo "immutag version: 0.0.5" > "$dir_path"/file-list.txt
echo "immutag software sha256: <sha256>" >> "$dir_path"/file-list.txt
echo "" >> "$dir_path"/file-list.txt

cd "$dir_path" || exit
echo "$mnemonic" | _imt_create_wallet_info_file_from_mnemonic
git init
git config user.email "immutag"
git config user.name "immutag"
cd  files || exit
git config user.email "immutag"
git config user.name "immutag"
git init
git annex init

# Add new name to config

in_config=$(rg --multiline "${dir_path}\n" "$HOME"/.immutag_config)
if [ "$in_config" ]; then
    echo "$dir_path already exists"
else
    echo "$dir_path" >> "$HOME"/.immutag_config
fi
