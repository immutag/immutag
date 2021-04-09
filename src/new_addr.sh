#!/bin/bash

IMMUTAG_NEW_ADDR_INDEX=$(eval ./new_addr_index.sh)
IMMUTAG_NEW_ADDR_LAZY='$HOME/go/bin/addrgen test $IMMUTAG_NEW_ADDR_INDEX 1 | cut -d " " -f 2'
IMMUTAG_NEW_ADDR=$(eval $IMMUTAG_NEW_ADDR_LAZY)

echo $IMMUTAG_NEW_ADDR
