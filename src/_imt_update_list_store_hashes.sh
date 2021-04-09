	#!/bin/bash

name="$1"

cd files/ || exit

# don't use eval, otherwise if it fails the exit code will not reveal.
oids="$(git rev-parse HEAD git-annex)"

if [ $? -eq 0 ];then
    gitoid=$(echo "$oids" | sed -n '1p')
    gitannexoid=$(echo "$oids" | sed -n '2p')

     cd ../

      git add file-list.txt
     _imt_write_store_addrs $name store 1 sha256 1 ipfsaddr "7.02" "$gitoid $gitannexoid"
     ##sed -i "1s/.*/$gitoid/" file-list.txt
     ##sed -i "2s/.*/$gitannexoid/" file-list.txt
else
    echo "Nothing to commit."
fi
