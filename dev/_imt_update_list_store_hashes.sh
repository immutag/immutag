#!/bin/bash

cd files/

# don't use eval, otherwise if it fails the exit code will not reveal.
oids=$(git rev-parse HEAD git-annex)

if [ $? -eq 0 ];then
    gitoid=$(echo "$oids" | sed -n '1p')
    gitannexoid=$(echo "$oids" | sed -n '2p')

     cd ../

     sed -i "1s/.*/$gitoid/" file-list.txt
     sed -i "2s/.*/$gitannexoid/" file-list.txt
else
    echo "Nothing to commit."
fi
