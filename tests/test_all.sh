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
        "$sudo" docker-compose stop
        "$sudo" docker-compose up -d --remove-orphans --force-recreate
    fi

    if [ "$test_type" = "all" ];then
       ./test.sh run add_file    "$sudo_flag"
       ./test.sh run add_tag     "$sudo_flag"
       ./test.sh run init        "$sudo_flag"
       ./test.sh run tag_rm      "$sudo_flag"
       ./test.sh run roll        "$sudo_flag"
       ./test.sh run commit      "$sudo_flag"
       ./test.sh run tag_replace "$sudo_flag"
    else
        ./test.sh run "$test_type" "$sudo_flag"
    fi

else
    echo ""
    echo "Not a test command"
    echo ""
fi
