#!/usr/bin/env bash

addr="$(</dev/stdin)"
tags="$@"

echo "$addr" | _imt_tag_replace file-list.txt "$tags"
