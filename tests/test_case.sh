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

    if [ -n "${HARDSTART}" ];then
        if [ -n "${SUDO}" ];then
            sudo docker-compose stop
            sudo docker-compose up -d --remove-orphans --force-recreate
	else
            docker-compose stop
            docker-compose up -d --remove-orphans --force-recreate
	fi
    fi

    # Can't run eval on docker exec commands with quotations, so can't do "$sudo" or something prefixed to below docker commands.
    if [ -n "${SUDO}" ];then
        # Make installs script executable.
        chmod u+x ../dev/install_container
        chmod u+x ../dev/test_install_container

        sudo docker exec immutag_machine_1 /bin/sh -c 'cd /immutag/dev && ./install_container'
        sudo docker exec immutag_machine_1 /bin/sh -c 'cd /immutag/dev && ./test_install_container'

        # Undo install permissions so as to avoid running it on host.
        chmod a-x,g+w ../dev/install_container
        chmod a-x,g+w ../dev/test_install_container

        # Setup the test.
        sudo docker exec immutag_machine_1 /bin/sh -c "cd /root/immutag_test && ./'$test_type'_setup_test.sh"

        # Run the target test.
        sudo docker exec immutag_machine_1 /bin/sh -c "cd /root/immutag_test && ./'$test_type'_test.sh"

        # Teardown the test.
        sudo docker exec immutag_machine_1 /bin/sh -c 'cd /root/immutag_test/ && ./teardown_test.sh'
    else
        # Make install scripts executable.
        chmod u+x ../dev/install_container
        chmod u+x ../dev/test_install_container

        docker exec immutag_machine_1 /bin/sh -c 'cd /immutag/dev && ./install_container'
        sudo docker exec immutag_machine_1 /bin/sh -c 'cd /immutag/dev && ./test_install_container'

        # Undo install permissions so as to avoid running it on host.
        chmod a-x,g+w ../dev/install_container

        # Setup the test.
        docker exec immutag_machine_1 /bin/sh -c "cd /root/immutag_test && ./'$test_type'_setup_test.sh"

        # Run the target test.
        docker exec immutag_machine_1 /bin/sh -c "cd /root/immutag_test && ./'$test_type'_test.sh"

        # Teardown the test.
        docker exec immutag_machine_1 /bin/sh -c 'cd /root/immutag_test/ && ./teardown_test.sh'
    fi

else
    echo ""
    echo "Not a test command"
    echo ""
fi
