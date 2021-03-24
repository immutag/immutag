#! /bin/sh

#oneTimeSetup() {
#	imt add --no-default-name foo.txt tag1 tag2 tag3
#	imt add --no-default-name bar.txt tag1 tag2 tag3
#}

testEquality() {
    immutag_path="$HOME/immutag"
    name="main"

    imt add --no-default-name foo.txt tag1 tag2 tag3
    imt add --no-default-name bar.txt tag1 tag2 tag3
    cd "$immutag_path"
    cd "$name"

    result_foo=$(eval cat files/1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q)
    result_bar=$(eval cat files/17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr)
    assertEquals 'foo' "$result_foo"
    assertEquals 'bar' "$result_bar"
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
