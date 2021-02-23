quoted_text="$(</dev/stdin)"

text=$(eval echo "$quoted_text" | sed 's/"//g')

echo "$text"
