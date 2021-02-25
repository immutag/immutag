mnemonic="$(</dev/stdin)"

echo "$mnemonic" | _imt_generate_from_24_word_mnemonic | _imt_write_wallet_info_file
