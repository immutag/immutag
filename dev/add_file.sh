#!/bin/bash

# Usage:
# $add_file.sh [file]
# Copies and renames file to files/ dir.
addr="$(</dev/stdin)"

cp $1 $HOME/projects/work/immutag/dev/files/$addr


