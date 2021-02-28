#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    imt_init immutag "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"

    result_list=$(eval ls immutag/file-list.txt)
    result_entropy=$(eval cat immutag/wallet_info.json | jq '.entropy_bits')

    assertEquals "immutag/file-list.txt" "$result_list"
    assertEquals "bar" "$result_entropy"
}

. shunit2
