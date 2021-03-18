#! /bin/sh

oneTimeSetUp() {
    imt_init main "lottery shop below speed oak blur wet onion change light bonus liquid life fat reflect cotton mass chest crowd brief skin major evidence bamboo"

    echo "foo" > foo.txt
    echo "bar" > bar.txt
}

testEquality() {
    result_foo=$(eval cat foo.txt)
    result_bar=$(eval cat bar.txt)
    result_test=$(eval ls tag_rm_test.sh)
    result_test2=$(eval ls add_tag_test.sh)
    assertEquals "foo" "$result_foo"
    assertEquals "bar" "$result_bar"
    assertEquals "tag_rm_test.sh" "$result_test"
    assertEquals "add_tag_test.sh" "$result_test2"
}

# Test complaines it can't remove files because they don't exist, but test passes.
#oneTimeTearDown() {
#    rm -r immutag
#    #rm file-list.txt \
#    #foo.txt \
#    #bar.txt
#    ##remake.txt
#    ##consign.txt
#    ##correct.txt
#    ##shear.txt
#    ##develop.txt
#    #rm -r files/
#}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
