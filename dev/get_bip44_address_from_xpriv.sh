xpriv="$(</dev/stdin)"
index="$1"

echo "$xpriv" | ./bip44_info_derive_from_xpriv.sh $index | ./json_parse_p2pkh_address.sh | ./get_rid_of_quotation_marks.sh
