#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    immutag_path="$HOME/immutag"
    name="main"

    original_path=$(eval echo "$PWD")
    # First add and commit
    imt_add "$name" foo.txt tag1 tag2 tag3

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

    ### Second add and commit
    imt_add "$name" bar.txt tag1 tag2 tag3

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
    assertEquals "$gitrev_oid_a_store_4" "$gitrev_oid_a_store_2"
    assertEquals "$gitrev_oid_b_store_4" "$gitrev_oid_b_store_2"

    imt_rollback "$name"

    cd "$original_path"

    ## Brake out of rollbacked state.
    imt_add "$name" foofoo.txt tag

    cd "$immutag_path"
    cd "$name"

    branch_res=$(git symbolic-ref --short HEAD)

    assertEquals "$branch_res" "master"

    ### Replace and commit, which doesn't advance files versioning

    # Get pre-change values.
    cd files/
    gitrev_oids_store_5=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_5=$(echo "$gitrev_oids_store_5" | sed -n '1p')
    gitrev_oid_b_store_5=$(echo "$gitrev_oids_store_5" | sed -n '2p')

    addresses_store_5=$(cat ../store-addresses | jq '.git_annex.addr')
    address_a_store_5=$(echo "$addresses_store_5" | cut -d ' ' -f 1 | sed 's/"//g')
    address_b_store_5=$(echo "$addresses_store_5" | cut -d ' ' -f 2 | sed 's/"//g')

    imt replace-tags "$name" 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q a b c d e f g

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

    addresses_store_6=$(cat ../store-addresses | jq '.git_annex.addr')
    address_a_store_6=$(echo "$addresses_store_6" | cut -d ' ' -f 1 | sed 's/"//g')
    address_b_store_6=$(echo "$addresses_store_6" | cut -d ' ' -f 2 | sed 's/"//g')

    gitrev_oids_store_6=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_6=$(echo "$gitrev_oids_store_6" | sed -n '1p')
    gitrev_oid_b_store_6=$(echo "$gitrev_oids_store_6" | sed -n '2p')

    # Should be the same since metadata change in replace-tags doesn't effect files.
    assertEquals "$gitrev_oid_a_store_6" "$gitrev_oid_a_store_5"
    assertEquals "$gitrev_oid_b_store_6" "$gitrev_oid_b_store_5"

    ## Files never changed because replace-tags command only effects metadata.
    assertEquals "$gitrev_oid_a_store_6" "$address_a_store_5"
    assertEquals "$gitrev_oid_b_store_6" "$address_b_store_5"

    imt_rollback "$name"

    cd "$immutag_path"
    cd "$name"

    ### Replace and commit, which doesn't advance files versioning

    # Get pre-change values.
    cd files/
    gitrev_oids_store_7=$(git rev-parse HEAD git-annex)
    gitrev_oid_a_store_7=$(echo "$gitrev_oids_store_7" | sed -n '1p')
    gitrev_oid_b_store_7=$(echo "$gitrev_oids_store_7" | sed -n '2p')

    addresses_store_7=$(cat ../store-addresses | jq '.git_annex.addr')
    address_a_store_7=$(echo "$addresses_store_7" | cut -d ' ' -f 1 | sed 's/"//g')
    address_b_store_7=$(echo "$addresses_store_7" | cut -d ' ' -f 2 | sed 's/"//g')

    assertEquals "$gitrev_oid_a_store_6" "$gitrev_oid_a_store_7"
    assertEquals "$gitrev_oid_b_store_6" "$gitrev_oid_b_store_7"

    ## Files never changed because replace-tags command only effects metadata.
    assertEquals "$gitrev_oid_a_store_6" "$address_a_store_7"
    assertEquals "$gitrev_oid_b_store_6" "$address_b_store_7"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
