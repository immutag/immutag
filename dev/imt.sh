#!/bin/bash

cmd="$1"

if [ "$cmd" = "create" ];then
	storename="$2"
	mnemonic="$3"

	imt_init "$storename" "$mnemonic"
fi

if [ "$cmd" = "add" ];then
        input="$*"
	storename="$2"
	filepath="$3"
        tags=$(echo "$input" | cut -d " " -f 3-)

	imt_add "$storename" "$filepath" "$tags"
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

#echo "Number files in SEARCH PATH with EXTENSION:" $("${SEARCHPATH}"/*."${EXTENSION}") if [[ -n $1 ]]; then echo "Last line of file specified as non-opt/last argument:" tail -1 "$1" fi
