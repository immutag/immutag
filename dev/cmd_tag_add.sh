#!/usr/bin/env bash

addr="$(</dev/stdin)"
tags="$@"

echo "$addr" | _imt_tag_add file-list.txt "$tags"
