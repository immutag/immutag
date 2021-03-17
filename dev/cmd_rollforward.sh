#!/usr/bin/env bash
name="$1"

immutag_path="$HOME/immutag"

cd $immutag_path
cd $name

# Get git annex branch oids before rollback.
store_oids_a=$(cat store-addresses | jq '.git_annex.addr')
#oid_a_1=$(echo "$store_oids_a" | cut -d ' ' -f 1 | sed 's/"//g')
#oid_a_2=$(echo "$store_oids_a" | cut -d ' ' -f 2 | sed 's/"//g')

git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout

store_oids_b=$(cat store-addresses | jq '.git_annex.addr')
if [ "$store_oids_a" != "$store_oids_b" ]; then
    cd files/

    # We can't rollforward the git-annex branch also, but if we do make the changes permanent, we can.
    git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout

fi
#echo "$oid_1"
#echo "$oid_2"

# Permanent
#git update-ref refs/heads/master $oid_1
#git update-ref refs/heads/git-annex $oid_2
