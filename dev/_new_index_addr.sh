#!/bin/bash


IMMUTAG_LAST_ADDR_INDEX_LAZY='eval cat $1 | tail -n 1 | cut -d " " -f 1'
IMMUTAG_LAST_ADDR_INDEX=$(eval $IMMUTAG_LAST_ADDR_INDEX_LAZY)
IMMUTAG_NEW_ADDR_INDEX=$((IMMUTAG_LAST_ADDR_INDEX+1))
#IMMUTAG_NEW_ADDR_LAZY='$HOME/go/bin/addrgen test $IMMUTAG_NEW_ADDR_INDEX 1 | cut -d " " -f 2'
IMMUTAG_NEW_ADDR_LAZY='cat wallet_info.json | ./get_xpriv_from_wallet_info.sh | ./get_bip44_address_from_xpriv.sh $IMMUTAG_NEW_ADDR_INDEX'
IMMUTAG_NEW_ADDR=$(eval $IMMUTAG_NEW_ADDR_LAZY)

echo $(echo "$IMMUTAG_NEW_ADDR_INDEX $IMMUTAG_NEW_ADDR")
