#! /bin/sh
# file: examples/equality_test.sh

# test_file1.txt

oneTimeSetUp() {
	mkdir files
	touch file-list.txt
	echo "foo" > foo.txt
	echo "bar" > bar.txt
	#echo "remake" > remake.txt
	#echo "consign" > consign.txt
	#echo "correct" > correct.txt
	#echo "shear" > shear.txt
	#echo "develop" > develop.txt
	./cmd_add.sh foo.txt test test1 test2 test3
	./cmd_add.sh bar.txt test test1 test2 test3
}

testEquality() {
    result_foo=$(eval cat files/1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q)
    result_bar=$(eval cat files/17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr)
    assertEquals 'foo' "$result_foo"
    assertEquals 'bar' "$result_bar"
}

# Test complaines it can't remove files because they don't exist, but test passes.
oneTimeTearDown() {
	rm file-list.txt \
	foo.txt \
	bar.txt
	#remake.txt
	#consign.txt
	#correct.txt
	#shear.txt
	#develop.txt
	rm -r files/
}

. shunit2
# 1 1CaKbES6YZY2rm2grufw8gw1URafLdJN8Q foo txt test test1 test2 test3
# 2 17nZVxSmir9moZQSAwrPd7r7rRRdNqovGr bar txt test test1 test2 test3
# 3 15QRcwb52ZGbFLgfwSc6zWgBqEdCtLqMWg crunch csv test test1 test2 test3
# 4 1FuAYSe8N3K2x6tCnaCgzLZExVAtDkMHWt test_file1 txt test test1 test2
