#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

# To use command with cat
# imt_init "$(eval cat $mnemonic)"
# without the quotations, it fails.

testEquality() {
    imt_init main "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"

    result_list=$(eval ls /root/immutag/main/file-list.txt)
    result_entropy=$(eval cat /root/immutag/main/wallet_info.json | jq '.entropy_bits')

    assertEquals '/root/immutag/main/file-list.txt' "$result_list"
    assertEquals "256" "$result_entropy"
}

. shunit2
