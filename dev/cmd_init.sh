#!/usr/bin/env bash

dir_path="$1"

mkdir "$dir_path"
mkdir "$dir_path"/files
touch "$dir_path"/file-list.txt

cd "$dir_path"
git init
cd  files
git init
git annex init
