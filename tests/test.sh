#!/bin/bash
cmd="$1"
test_type="$2"

if [ "$cmd" = "run" ];then

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -s|--sudo)
        SUDO=YES
        shift # past argument
        ;;
        -h|--hard-start)
        HARDSTART=YES
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${SUDO}" ];then
	sudo_flag="--sudo"
	sudo="sudo"
    else
	sudo_flag=""
	sudo=""
    fi

    if [ -n "${HARDSTART}" ];then
	hardstart_flag="--hard-start"
    else
	hardstart_flag=""
    fi

    if [ "$test_type" = "all" ];then
        echo ""
	echo "add_file"
       ./test_case.sh run add_file    "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "add_tag"
       ./test_case.sh run add_tag     "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "init"
       ./test_case.sh run init        "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "tag_rm"
       ./test_case.sh run tag_rm      "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "roll"
       ./test_case.sh run roll        "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "roll_specific_store"
       ./test_case.sh run roll_specific_store "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "commit"
       ./test_case.sh run commit      "$sudo_flag" "$hardstart_flag"
        echo ""
	echo "tag_replace"
       ./test_case.sh run tag_replace "$sudo_flag" "$hardstart_flag"
    else
        echo ""
	echo "$test_type"
        ./test_case.sh run "$test_type" "$sudo_flag" "$hardstart_flag"
    fi

else
    echo ""
    echo "Not a test command"
    echo ""
fi
