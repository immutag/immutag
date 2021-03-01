#!/usr/bin/env bash

name="$1"
immutag_path="$HOME/immutag"

cd $immutag_path
cd $name

_imt_update_list_store_hashes

imt_commit_list
imt_commit_store
