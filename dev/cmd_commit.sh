#!/usr/bin/env bash

name="$1"
immutag_path="$HOME"/immutag

cd "$immutag_path" || exit
cd "$name" || exit


imt_commit_store
_imt_update_list_store_hashes "$name"
imt_commit_list
# Only does so if checked out from a rollback or rollforward.
_imt_exit_checkout
