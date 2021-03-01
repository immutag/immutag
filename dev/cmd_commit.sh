#!/usr/bin/env bash

name="$1"
immutag_path="$HOME/immutag"

cd $immutag_path
cd $name

imt_commit_list
imt_commit_store
