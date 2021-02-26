#!/usr/bin/env bash

addr="$(</dev/stdin)"
tags="$@"

echo "$addr" | _imt_tag_update file-list.txt "$tags"
