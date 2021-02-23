hex_pubkey=$(eval echo -n "39b53376845237ade379ec5dda36e334b4f0ca3639f8b298f986a9a3ef57a3185" | od -A n -t x1)

echo "$hex_pubkey"

hal address create --pubkey "$hex_pubkey"
#hal address create --pubkey xprvA3B4SsS7muEDGvVQMR1L4SXuXBfroLq1rM8itJwvpY8cTzyurLCNaxccMnEx91aHhSk9r3k2gH1S11tg6maphGiFgczgvd9835XtbFmgb87
#hal address create --pubkey 35c09cc381e40f411835bbbef7ced2636ff6ae084ecef93a1ef9cdb81e2657dbd
