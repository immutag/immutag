#!/usr/bin/env bash

git symbolic-ref --short HEAD
branch_res=$(eval echo $?)

if [ "$branch_res" != "0" ];then
    list_oid=$(git log | head -n 1 | cut -d ' ' -f 2)
    git update-ref refs/heads/master "$list_oid"
    git checkout master

    cd files

    git symbolic-ref --short HEAD

    branch_res=$(eval echo $?)

    if [ "$branch_res" != "0" ];then
        store_oids=$(cat ../store-addresses | jq '.git_annex.addr')
        store_oid_1=$(echo "$store_oids" | cut -d ' ' -f 1 | sed 's/"//g')
        store_oid_2=$(echo "$store_oids" | cut -d ' ' -f 2 | sed 's/"//g')

        git update-ref refs/heads/master "$store_oid_1"
        git update-ref refs/heads/git-annex "$store_oid_2"

	git checkout master

	# Do files list now that we know store must exit checkout.
    fi
fi
