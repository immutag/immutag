mnemonic="$(</dev/stdin)"

echo "$mnemonic" | ./generate_from_24_word_mnemonic.sh | ./write_wallet_info_file.sh
