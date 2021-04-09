wallet_info_json="$(</dev/stdin)"

echo "$wallet_info_json" | jq '.seed.bip32_xpriv' | _imt_get_rid_of_quotation_marks
