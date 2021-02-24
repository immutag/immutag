xpriv="$(</dev/stdin)"
index="$1"

echo "$xpriv" | _imt_bip44_info_derive_from_xpriv $index | _imt_json_parse_p2pkh_address | _imt_get_rid_of_quotation_marks
