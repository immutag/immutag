xpriv="$(</dev/stdin)"
index="$1"

hal bip32 derive $xpriv "m/44'/0'/0'/0/$index"
