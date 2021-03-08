#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    immutag_path="$HOME/immutag"
    name="main"

    imt_add "$name" foo.txt tag1 tag2 tag3

    ### First commit
    imt_commit "$name"
    cd "$immutag_path"
    cd "$name"

    res_foo_commit_msg=$(git show-branch --no-name HEAD)

    assertEquals "update" "$res_foo_commit_msg"

    cd files/

    res_foo_store_commit_msg=$(git show-branch --no-name HEAD)

    assertEquals "update" "$res_foo_commit_msg"

    addresses_store_1=$(cat ../store-addresses | jq '.git_annex.addr')
    address_a_store_1=$(echo "$addresses_store_1" | cut -d ' ' -f 1 | sed 's/"//g')
    address_b_store_1=$(echo "$addresses_store_1" | cut -d ' ' -f 2 | sed 's/"//g')

    gitrev_oids_store_1=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_1=$(echo "$gitrev_oids_store_1" | sed -n '1p')
    gitrev_oid_b_store_1=$(echo "$gitrev_oids_store_1" | sed -n '2p')

    assertEquals "$gitrev_oid_a_store_1" "$address_a_store_1"
    assertEquals "$gitrev_oid_b_store_2" "$address_b_store_2"

    # Make sure we can do commands from anywhere.
    cd /root/immutag_test

    imt_add "$name" bar.txt tag1 tag2 tag3

    ### Second commit
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

    addresses_store_2=$(cat ../store-addresses | jq '.git_annex.addr')
    address_a_store_2=$(echo "$addresses_store_2" | cut -d ' ' -f 1 | sed 's/"//g')
    address_b_store_2=$(echo "$addresses_store_2" | cut -d ' ' -f 2 | sed 's/"//g')

    gitrev_oids_store_2=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_2=$(echo "$gitrev_oids_store_2" | sed -n '1p')
    gitrev_oid_b_store_2=$(echo "$gitrev_oids_store_2" | sed -n '2p')

    assertEquals "$gitrev_oid_a_store_2" "$address_a_store_2"
    assertEquals "$gitrev_oid_b_store_2" "$address_b_store_2"

    ## Rollback
    imt_rollback "$name"
    gitrev_oids_store_3=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_3=$(echo "$gitrev_oids_store_3" | sed -n '1p')
    gitrev_oid_b_store_3=$(echo "$gitrev_oids_store_3" | sed -n '2p')

    assertEquals "$gitrev_oid_a_store_3" "$gitrev_oid_a_store_1"

    ## Rollforward
    imt_rollforward "$name"
    gitrev_oids_store_4=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_4=$(echo "$gitrev_oids_store_4" | sed -n '1p')
    gitrev_oid_b_store_4=$(echo "$gitrev_oids_store_4" | sed -n '2p')
    assertEquals "$gitrev_oid_a_store_4" "$gitrev_oid_a_store_3"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q foo txt test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr bar txt test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
