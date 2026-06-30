#! /bin/sh

testEquality() {
    immutag_path="$HOME/immutag"
    rm -r "$immutag_path"
    ls "$immutag_path"
    # Get exit codeo of ls: 2 means dir doesn't exist.
    result_exit_code=$(echo $?)
    assertEquals "2" "$result_exit_code"
    mkdir -p "$immutag_path/stage"
}

. shunit2
