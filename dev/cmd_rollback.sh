#!/usr/bin/env bash
name="$1"

immutag_path="$HOME/immutag"

cd $immutag_path
cd $name

git checkout HEAD~1

# Get git annex branch oids off of rolled back file list, and then checkout those out
store_oids=$(cat store-addresses | jq '.git_annex.addr')

oid_1=$(echo "$store_oids" | cut -d ' ' -f 1 | sed 's/"//g')
oid_2=$(echo "$store_oids" | cut -d ' ' -f 2 | sed 's/"//g')

cd files/

# We can't rollback the git-annex branch also, but if we do make the changes permanent, we can.
git checkout HEAD~1

#echo "$oid_1"
#echo "$oid_2"

# Permanent
#git update-ref refs/heads/master $oid_1
#git update-ref refs/heads/git-annex $oid_2

#git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
