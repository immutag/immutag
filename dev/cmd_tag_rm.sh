#!/usr/bin/env bash

addr="$(</dev/stdin)"

echo "$addr" | _imt_tag_rm file-list.txt
