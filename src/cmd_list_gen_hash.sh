#!/bin/bash

name="$1"

initial_oids_store=$(git rev-parse HEAD git-annex 2> /dev/null)

while :
do

        gitrev_oids_store_1=$(git rev-parse HEAD git-annex 2> /dev/null)
        gitrev_oid_a_store_1=$(echo "$gitrev_oids_store_1" | sed -n '1p')
        gitrev_oid_b_store_1=$(echo "$gitrev_oids_store_1" | sed -n '2p')
        imt_rollforward "$name" > /dev/null 2>&1
	gitrev_oids_store_2=$(git rev-parse HEAD git-annex 2> /dev/null)
        gitrev_oid_a_store_2=$(echo "$gitrev_oids_store_2" | sed -n '1p')
        gitrev_oid_b_store_2=$(echo "$gitrev_oids_store_2" | sed -n '2p')

	# Rolling forward in vain.
	if [ "$gitrev_oids_store_1" = "$gitrev_oids_store_2" ];then
		break

	fi
done

_imt_exit_checkout > /dev/null 2>&1

while :
do
	imt_gen_hash "$name" 2> /dev/null
        imt_rollback "$name" > /dev/null 2>&1
	status=$(echo "$?")

	if [ "$status" != "0" ];then
		break
	fi
done

while :
do

        gitrev_oids_store_1=$(git rev-parse HEAD git-annex 2> /dev/null)
        gitrev_oid_a_store_1=$(echo "$gitrev_oids_store_1" | sed -n '1p')
        gitrev_oid_b_store_1=$(echo "$gitrev_oids_store_1" | sed -n '2p')
        imt_rollforward "$name" > /dev/null 2>&1
	gitrev_oids_store_2=$(git rev-parse HEAD git-annex 2> /dev/null)
        gitrev_oid_a_store_2=$(echo "$gitrev_oids_store_2" | sed -n '1p')
        gitrev_oid_b_store_2=$(echo "$gitrev_oids_store_2" | sed -n '2p')

	# Rolling forward in vain.
	if [ "$gitrev_oids_store_1" = "$gitrev_oids_store_2" ];then
		break
	fi
done

immutag_path="$HOME/immutag"

cd "$immutag_path" || exit
cd "$name" || exit

# If we we're initiall in a rollbacked state, we go back to it.
final_oids_store=$(git rev-parse HEAD git-annex 2> /dev/null)
if [ "$final_oids_store" != "$initial_oids_store" ];then
    while :
    do
        imt_rollback "$name" > /dev/null 2>&1
        final_oids_store=$(git rev-parse HEAD git-annex 2> /dev/null)
        if [ "$final_oids_store" = "$initial_oids_store" ];then
            break
        fi
    done
else
    _imt_exit_checkout > /dev/null 2>&1
fi
