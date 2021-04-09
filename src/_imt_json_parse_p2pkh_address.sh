hd_address_info="$(</dev/stdin)"

p2pkh_address=$(echo "$hd_address_info" | jq '.addresses.p2pkh')

echo "$p2pkh_address"
