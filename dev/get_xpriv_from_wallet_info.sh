wallet_info_json="$(</dev/stdin)"

echo "$wallet_info_json" | jq '.seed.bip32_xpriv' | ./get_rid_of_quotation_marks.sh
