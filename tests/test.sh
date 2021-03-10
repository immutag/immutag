#!/usr/bin/env bash

arg1="$1"
arg2="$2"

if  [ "$arg1" = "hard-start" ]; then
    sudo docker-compose stop
    sudo docker-compose up -d --remove-orphans --force-recreate
fi

# Make install script executable.
chmod u+x ../dev/install

sudo docker exec immutag_environment_1 /bin/sh -c 'cd /immutag/dev && ./install'

# Undo install permissions so as to avoid running it on host.
chmod a-x,g+w ../dev/install

# Setup the test.
sudo docker exec immutag_environment_1 /bin/sh -c "cd /root/immutag_test && ./'$arg2'_setup_test.sh"

# Run the target test.
sudo docker exec immutag_environment_1 /bin/sh -c "cd /root/immutag_test && ./'$arg2'_test.sh"

# Teardown the test.
sudo docker exec immutag_environment_1 /bin/sh -c 'cd /root/immutag_test/ && ./teardown_test.sh'

sudo docker exec immutag_environment_1 /bin/sh -c 'chmod u+x /immutag/dev/install'
