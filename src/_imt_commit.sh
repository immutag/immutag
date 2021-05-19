#!/usr/bin/env bash

name="$1"
immutag_path="$HOME"/immutag

cd "$immutag_path" || exit
cd "$name" || exit

imt_commit_store > /dev/null 2>&1
_imt_update_list_store_hashes "$name" > /dev/null 2>&1
config_path=$immutag_path/$name/store-addresses
exists="1"

if [ -s "$config_path" ];then
    # exists
    exists="0"
else
    # doesn't exist
    exists="1"
fi

while [ $exists == "1" ]
do
   git restore store-addresses > /dev/null 2>&1
   _imt_update_list_store_hashes "$name" > /dev/null 2>&1
    if [ -s "$config_path" ];then
        # exists
        exists="0"
    else
        # doesn't exist
        exists="1"
    fi
done
imt_commit_list > /dev/null 2>&1
# Only does so if checked out from a rollback or rollforward.
_imt_exit_checkout > /dev/null 2>&1
