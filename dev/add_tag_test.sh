#! /bin/sh

#oneTimeSetup() {
#	imt_add foo.txt tag1 tag2 tag3
#	imt_add bar.txt tag1 tag2 tag3
#}

testEquality() {
    immutag_path="$HOME/immutag"
    name="main"

    imt_add "$name" foo.txt tag1 tag2 tag3
    imt_add "$name" bar.txt tag1 tag2 tag3

    echo "1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q" | imt_tag_add "$name" tag4 tag5 tag6 tag7
    echo "17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr" | imt_tag_add "$name" tag4 tag5

    cd "$immutag_path"
    cd "$name"

    result_foo=$(eval rg 1CaKb file-list.txt)
    result_bar=$(eval rg 17nZV file-list.txt)

    assertEquals "1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q tag1 tag2 tag3 tag4 tag5 tag6 tag7" "$result_foo"
    assertEquals "2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr tag1 tag2 tag3 tag4 tag5" "$result_bar"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
