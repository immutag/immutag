#! /bin/sh
# file: examples/equality_test.sh

testEquality() {

  ../cmd_add fixtures/foo.txt test test1 test1

  assertEquals 1 1
}

. shunit2
