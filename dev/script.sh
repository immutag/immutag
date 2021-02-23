# Dependencies:
# sed (GNU sed) 4.2.2
# cut (GNU coreutils) 8.25

# Get line
#sed -n [row]p file-list.txt

# Replace first 4 fields space deliminator with commas:
#cut -d   -f 1-4 file-list.txt --output-delimiter=','

# Get 4th field:
#echo "Lorem ipsum dolor sit amet | cut -d ' ' -f 4"

# Select line via fzf from file list and then replace space deliminator with commas:
#cat file-list.txt | fzf | cut -d  -f 1-4  --output-delimiter=','

# Get address based on fzf selection
#cat file-list.txt | fzf | cut -d  -f 2

# Get the address of the last line (space deliminator).
#cat file-list.txt | tail -n 1 | cut -d " " -f 2

# Get last line.
#IMMUTAG_FILE_LAST_LINE="tail -n 1"

# Get latest bitcoin addr index.
#IMMUTAG_LATEST_ADDR_INDEX='cat file-list.txt | tail -n 1 | cut -d " " -f 1'

# Get last used bitcoin address index.
#IMMUTAG_LAST_ADDR_INDEX='cat file-list.txt | tail -n 1 | cut -d   -f 1'

# Get new bitcon address (index of last entry + 1).
#IMMUTAG_LAST_ADDR_INDEX_LAZY='eval cat file-list.txt | tail -n 1 | cut -d " " -f 1'
#IMMUTAG_LAST_ADDR_INDEX=$(eval $IMMUTAG_LAST_ADDR_INDEX_LAZY)
#IMMUTAG_NEW_ADDR_INDEX=$((IMMUTAG_LAST_ADDR_INDEX+1))
#IMMUTAG_NEW_ADDR_LAZY='$HOME/go/bin/addrgen test $IMMUTAG_NEW_ADDR_INDEX 1 | cut -d " " -f 2'
#IMMUTAG_NEW_ADDR=$(eval $IMMUTAG_NEW_ADDR_LAZY)

#cp $1 $HOME/projects/$IMMUTAG_NEW_ADDR


#IMMUTAG_FILE_LIST_ADDR_CUT='cut -d " " -f 2'
#IMMUTAG_LAST_ADDR=$(cat file-list.txt | eval $IMMUTAG_FILE_LAST_LINE | eval $IMMUTAG_FILE_LIST_ADDR_CUT)
