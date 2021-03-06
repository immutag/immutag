#!/bin/bash

immutag_path="$HOME/immutag"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=YES
    shift # past argument
    ;;
    -v|--version)
    HELP=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -n "${HELP}" ];then
	read -r -d '' HELP_OUTPUT <<EOM
immutag 0.0.807

An experimental content-addressable file manager.
Project home page: https://github/immutag/immutag

USAGE:
   imt [OPTIONS] [COMMAND]

OPTIONS
     -v, --version          Print version info and exit
     -n, --store-name       Specify store other than "main" to run commands against

These are basic imt commands.

create               Start a default store or custom store
add                  Add a file along with initial tags
add-tag              Add a tag
rm-tags              Remove tags
replace-tags         Replace tags
rollback             Roll a generation back
rollforward          Roll a generation ahead
find                 Find files by tags
update               Update a file to a new version

Command specific help descriptions are forthcoming. See the readme in the homepage for usage in the meantime.
EOM
    echo "$HELP_OUTPUT"
fi

if [ -n "${VERSION}" ];then
	read -r -d '' VERSION_OUTPUT <<EOM
immutag 0.0.807
EOM
    echo "$VERSION_OUTPUT"
fi

cmd="$1"

if [ "$cmd" = "create" ];then

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    mnemonic="$2"

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_init "$storename" "$mnemonic" > /dev/null 2>&1
fi

if [ "$cmd" = "update" ];then

    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    addr="$2"
    file="$3"

    # To add file name and extension to tag.
    fullfilename="$file"
    filename=$(basename "$fullfilename")
    fname="${filename%.*}"
    ext="${filename##*.}"

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_update_file "$storename" "$addr" "$immutag_path"/stage/"$filename"
fi

#if [ "$cmd" = "add" ];then
#        input="$*"
#	storename="$2"
#	filepath="$3"
#        tags=$(echo "$input" | cut -d " " -f 4-)
#
#	imt_add "$storename" "$filepath" "$tags"
#fi

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
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
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

        if [ -n "${STORENAME}" ];then
            name="$STORENAME"
	else
	    name="main"
	fi

	file="$2"
	#file=$(echo "$file" | sed 's/\\//g')
	#echo "$file"
        file_abs_path=$(realpath "$file")

        # Exit script here if we can't find the file to be added to the store.
        if [ ! -f "$file_abs_path" ];then
            echo "Can't find file."
            exit
        fi

	inputns="$(echo $input | sed 's/\\//')"
	inputns="$(echo $inputns | sed 's/add//')"
	filens="$(echo $file | sed 's/\\//')"

        #metadata=$(echo "$input" | sed -i "s/$file//" | cut -d " " -f 3-)
        metadata=$(echo "$inputns" | sed "s/$filens//")
        metadata=$(echo "$metadata" | sed 's/  //')
	echo "$metadata"

        cd "$immutag_path" || exit
        cd "$name" || exit


	addrs=$(eval _imt_print_list_only | _imt_new_index_addr)
        index_addr=$(echo "$addrs" | cut -d " " -f 1)
        addr=$(echo "$addrs" | cut -d " " -f 2)

        arr=("$immutag_path"/"$name"/files/*)
        for ((i=0; i<${#arr[@]}; i++)); do
            cmp --silent "$file_abs_path" "${arr[$i]}" && exit_update="2" && break || exit_update="0"
        done

	if [ "$exit_update" = "0" ];then
	    echo "$addrs" | _imt_append_list "$metadata"
            cp "$file_abs_path" files/"$addr"
            _imt_commit "$name"
            echo "add file: $file"
            echo "tags: $metadata"
	else
	    echo "File already exists."
	fi
    else
        immutag_path="$HOME/immutag"

        input="$*"

        if [ -n "${STORENAME}" ];then
            name="$STORENAME"
	else
	    name="main"
	fi

	file="$2"
	#file=$(echo "$file" | sed 's/\\//g')
	#echo "$file"
        file_abs_path=$(realpath "$file")

        # Exit script here if we can't find the file to be added to the store.
        if [ ! -f "$file_abs_path" ];then
            echo "Can't find file."
            exit
        fi

        # To add file name and extension to tag.
        #fullfilename="$file"
        #filename=$(basename "$fullfilename")
        #fname="${filename%.*}"
        #ext="${filename##*.}"

        #metadata=$(echo "$input" | cut -d " " -f 3-)
	inputns="$(echo $input | sed 's/\\//')"
	inputns="$(echo $inputns | sed 's/add//')"
	filens="$(echo $file | sed 's/\\//')"

        #metadata=$(echo "$input" | sed -i "s/$file//" | cut -d " " -f 3-)
        metadata=$(echo "$inputns" | sed "s/$filens//")
        metadata=$(echo "$metadata" | sed 's/  //')
        #metadata=$(echo "$input" | sed -i "s/$file//" | cut -d " " -f 3-)
	echo "$metadata"

        cd "$immutag_path" || exit
        cd "$name" || exit


	addrs=$(eval _imt_print_list_only | _imt_new_index_addr)
        index_addr=$(echo "$addrs" | cut -d " " -f 1)
        addr=$(echo "$addrs" | cut -d " " -f 2)

        arr=("$immutag_path"/"$name"/files/*)
        for ((i=0; i<${#arr[@]}; i++)); do
            cmp --silent "$file_abs_path" "${arr[$i]}" && exit_update="2" && break || exit_update="0"
        done

	if [ "$exit_update" = "0" ];then
	    echo "$addrs" | _imt_append_list "$metadata"
            cp "$file_abs_path" files/"$addr"
            cp "$file_abs_path" files/"$addr"
            _imt_commit "$name"
            echo "add file: $file"
            echo "tags: $metadata"
	else
	    echo "File already exists."
	fi
    fi
fi

if [ "$cmd" = "add-tag" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    input="$*"
    fileaddr="$2"
    tags=$(echo "$input" | cut -d " " -f 3-)

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    echo "$fileaddr" | imt_tag_add "$storename" "$tags"
fi

if [ "$cmd" = "rm-tags" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters
    input="$*"
    fileaddr="$2"

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    echo "$fileaddr" | imt_tag_rm "$storename"
fi

if [ "$cmd" = "replace-tags" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    input="$*"
    fileaddr="$2"

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    tags=$(echo "$input" | cut -d " " -f 3-)

    echo "$fileaddr" | imt_tag_replace "$storename" "$tags"
fi

if [ "$cmd" = "find" ];then
    storename="$2"
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        -a|--addr)
        ADDRESS=YES
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    FIND=""

    if [ -n "${ADDRESS}" ];then
	    FIND=$(imt_find "$storename" addr)
            echo $FIND | tr -d '\n' > $HOME/immutag/addr
            echo "open symlink at immutag/addr"
    else
	    FIND=$(imt_find "$storename")
            echo $FIND > $HOME/immutag/.find_output
            echo "open symlink at immutag/file"
    fi
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

if [ "$cmd" = "rollback" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_rollback "$storename"
fi


if [ "$cmd" = "rollforward" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi
    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_rollforward "$storename"
fi

if [ "$cmd" = "wormhole-send" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi
    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_wormhole_send "$storename"
fi

if [ "$cmd" = "wormhole-recv" ];then
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -n|--store-name)
        STORENAME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi
    if [ -n "${STORENAME}" ];then
	storename="$STORENAME"
    else
	storename="main"
    fi

    imt_wormhole_recv "$storename"
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
