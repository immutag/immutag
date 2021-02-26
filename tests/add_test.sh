#!/usr/bin/env bash

arg="$1"

if  [ "$arg" = "hard-start" ]; then
    sudo docker-compose stop
    sudo docker-compose up -d --remove-orphans --force-recreate
fi

# Stage test files and permission, along with other install tasks.
sudo docker exec immutag_environment_1 /bin/sh -c 'cd /immutag/dev && ./install'

# Setup the test.
sudo docker exec immutag_environment_1 /bin/sh -c 'cd /root/immutag_test && ./add_file_setup_test.sh'

# Run the target test.
sudo docker exec immutag_environment_1 /bin/sh -c 'cd /root/immutag_test/immutag && ./add_file_test.sh'

# Teardown the test.
sudo docker exec immutag_environment_1 /bin/sh -c 'cd /root/immutag_test/ && ./teardown_test.sh'
