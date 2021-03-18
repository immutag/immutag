#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    immutag_path="$HOME/immutag"
    name="main"

    imt_add "$name" foo.txt tag1 tag2 tag3
    imt_commit "$name"
    imt_add "$name" bar.txt tag1 tag2 tag3
    imt_commit "$name"

    cd "$immutag_path"
    cd "$name"

    res_foo_commit_msg=$(git show-branch --no-name HEAD)
    res_bar_commit_msg=$(git show-branch --no-name HEAD~1)

    assertEquals "update" "$res_foo_commit_msg"
    assertEquals "update" "$res_bar_commit_msg"

    cd files/

    res_foo_commit_msg=$(git show-branch --no-name HEAD)
    res_bar_commit_msg=$(git show-branch --no-name HEAD~1)

    assertEquals "update" "$res_foo_commit_msg"
    assertEquals "update" "$res_bar_commit_msg"

    addresses=$(cat ../store-addresses | jq '.git_annex.addr')
    address_1=$(echo "$addresses" | cut -d ' ' -f 1 | sed 's/"//g')
    address_2=$(echo "$addresses" | cut -d ' ' -f 2 | sed 's/"//g')

    gitrev_oids=$(git rev-parse HEAD git-annex)
    gitrev_oid1=$(echo "$gitrev_oids" | sed -n '1p')
    gitrev_oid2=$(echo "$gitrev_oids" | sed -n '2p')

    assertEquals "$gitrev_oid1" "$address_1"
    assertEquals "$gitrev_oid2" "$address_2"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
