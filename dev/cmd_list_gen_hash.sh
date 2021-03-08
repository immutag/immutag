#!/bin/bash

name="$1"

while :
do
	imt_gen_hash "$name"
        imt_rollback "$name"
	status=$(echo "$?")

	if [ "$status" != "0" ];then
		break
	fi
done

while :
do
        imt_rollforward "$name"
	status=$(echo "$?")

	if [ "$status" != "0" ];then
		break
	fi
done

immutag_path="$HOME/immutag"

cd "$immutag_path"
cd "$name"

imt_exit_checkout "$name"
