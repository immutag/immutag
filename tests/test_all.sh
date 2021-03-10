#!/usr/bin/env bash

./test.sh hard-start add_file
./test.sh hard-start add_tag
./test.sh hard-start init
./test.sh hard-start tag_rm
./test.sh hard-start roll
./test.sh hard-start commit
./test.sh hard-start tag_replace
