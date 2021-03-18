#!/bin/bash

cmd="$1"

if [ "$cmd" = "create" ];then
	storename="$2"
	mnemonic="$3"

	imt_init "$storename" "$mnemonic"
fi

#if [ "$cmd" = "add" ];then
#        input="$*"
#	storename="$2"
#	filepath="$3"
#        tags=$(echo "$input" | cut -d " " -f 4-)
#
#	imt_add "$storename" "$filepath" "$tags"
#fi

if [ "$cmd" = "add" ];then

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        --no-default-name)
        NODEFAULTNAME=YES
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${NODEFAULTNAME}" ];then
        immutag_path="$HOME/immutag"

        input="$*"

        name="$2"
	file="$3"
        file_abs_path=$(eval realpath "$file")

        # Exit script here if we can't find the file to be added to the store.
        if [ ! -f "$file_abs_path" ];then
            echo "Can't find file."
            exit
        fi

        metadata=$(echo "$input" | cut -d " " -f 4-)

        echo "add file: $file"
        echo "tags: $metadata"

        cd "$immutag_path" || exit
        cd "$name" || exit


        addr=$(eval _imt_print_list_only | _imt_new_index_addr | _imt_append_list "$metadata")

        cp "$file_abs_path" files/"$addr"

        _imt_commit "$name"
    else
        immutag_path="$HOME/immutag"

        input="$*"

        name="$2"
	file="$3"
        file_abs_path=$(eval realpath "$file")

        # Exit script here if we can't find the file to be added to the store.
        if [ ! -f "$file_abs_path" ];then
            echo "Can't find file."
            exit
        fi

        # To add file name and extension to tag.
        fullfilename="$file"
        filename=$(basename "$fullfilename")
        fname="${filename%.*}"
        ext="${filename##*.}"

        tags=$(echo "$input" | cut -d " " -f 4-)
        metadata=$(echo "$fname" "$ext" "$tags")

        echo "add file: $file"
        echo "tags: $metadata"

        cd "$immutag_path" || exit
        cd "$name" || exit


        addr=$(eval _imt_print_list_only | _imt_new_index_addr | _imt_append_list "$metadata")

        cp "$file_abs_path" files/"$addr"

        _imt_commit "$name"
    fi
fi

if [ "$cmd" = "add-tag" ];then
        input="$*"
	storename="$2"
        fileaddr="$3"
        tags=$(echo "$input" | cut -d " " -f 4-)

	echo "$fileaddr" | imt_tag_add "$storename" "$tags"
fi

if [ "$cmd" = "rm-tags" ];then
        input="$*"
	storename="$2"
        fileaddr="$3"
	echo "$fileaddr" | imt_tag_rm "$storename"
fi

if [ "$cmd" = "replace-tags" ];then
        input="$*"
	storename="$2"
        fileaddr="$3"
        tags=$(echo "$input" | cut -d " " -f 4-)

	echo "$fileaddr" | imt_tag_replace "$storename" "$tags"
fi

if [ "$cmd" = "find" ];then
    storename="$2"
    if [ ! $# -eq 3 ];then
        imt_find "$storename"
    fi
    while [ ! $# -eq 0 ]
    do
        case "$1" in
            --help | -h)
                #helpmenu
                    echo -e "\nhelp\n"
                exit
                ;;
            --addr | -a)
                    storename="$2"
                    imt_find "$storename" addr
                exit
                ;;
        esac
        shift
    done

    #POSITIONAL=()
    #while [[ $# -gt 0 ]]
    #do
    #key="$1"

    #case $key in
    #    -a|--address)
    #    ADDRESS="$2"
    #    shift # past argument
    #    ;;
    #    *)    # unknown option
    #    POSITIONAL+=("$1") # save it in an array for later
    #    shift # past argument
    #    ;;
    #esac
    #done
    #set -- "${POSITIONAL[@]}" # restore positional parameters

    #storename="$2"

    #if [ -z "${ADDRESS}" ]; then
    #     imt_find "$storename"
    #else
    #     imt_find "$storename" addr
    #fi
fi


if [ "$cmd" = "test" ];then

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -e|--extension)
        EXTENSION="$2"
        shift # past argument
        shift # past value
        ;;
        -s|--searchpath)
        SEARCHPATH="$2"
        shift # past argument
        shift # past value
        ;;
        -l|--lib)
        LIBPATH="$2"
        shift # past argument
        shift # past value
        ;;
        --default)
        DEFAULT=YES
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    echo "FILE EXTENSION  = ${EXTENSION}"
    echo "SEARCH PATH     = ${SEARCHPATH}"
    echo "LIBRARY PATH    = ${LIBPATH}"
    echo "DEFAULT         = ${DEFAULT}"

    addr="$2"
    echo -e "\naddress: $addr"
fi

#usage()
#{
#cat << EOF
#usage: $0 PARAM [-o|--option OPTION] [-f|--force] [-h|--help]
#
#This script does foo.
#
#OPTIONS:
#   PARAM        The param
#   -o|--option  OPTION The option
#   -h|--help    Show this message
#   -f|--force   Enable --force
#EOF
#}
