#!/bin/bash
IMMUTAG_LAST_ADDR_INDEX_LAZY='eval cat $1 | tail -n 1 | cut -d " " -f 1'
IMMUTAG_LAST_ADDR_INDEX=$(eval $IMMUTAG_LAST_ADDR_INDEX_LAZY)
IMMUTAG_NEW_ADDR_INDEX=$((IMMUTAG_LAST_ADDR_INDEX+1))
IMMUTAG_NEW_ADDR_LAZY='cat wallet-info | _imt_get_xpriv_from_wallet_info | _imt_get_bip44_address_from_xpriv $IMMUTAG_NEW_ADDR_INDEX'
IMMUTAG_NEW_ADDR=$(eval $IMMUTAG_NEW_ADDR_LAZY)

echo $(echo "$IMMUTAG_NEW_ADDR_INDEX $IMMUTAG_NEW_ADDR")
