#! /bin/sh

testEquality() {
    rm -r immutag
    ls immutag
    # Get exit codeo of ls: 2 means dir doesn't exist.
    result_exit_code=$(echo $?)
    assertEquals "0" "$result_exit_code"
}

. shunit2
