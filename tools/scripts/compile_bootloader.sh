#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

filepath=$1
filename=$(echo "$1" | sed "s/.*\///" | cut -f 1 -d '.') # get file name

nasm $filepath -f bin -o ../../bin/$filename.bin -i ../../includes
