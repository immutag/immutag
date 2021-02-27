#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    imt_add foo.txt tag1 tag2 tag3
    imt_add bar.txt tag1 tag2 tag3
    echo "17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr" | imt_tag_rm
    result_foo=$(eval rg 1CaKb file-list.txt)
    result_bar=$(eval rg 17nZV file-list.txt)

    assertEquals "1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q foo txt tag1 tag2 tag3" "$result_foo"
    assertEquals "2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr" "$result_bar"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q foo txt test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr bar txt test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
