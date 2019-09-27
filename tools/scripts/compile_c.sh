#!/bin/bash

# filepath=$(echo $1 | sed 's/\.[^.]*$//') # remove any file extensions from the passed arg $1
INPUT_FILE=$1
filename=$(echo "$1" | sed "s/.*\///" | cut -f 1 -d '.') # get file name

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../../
OBJ_LOC=$BASE_DIR/objs/$filename.o
BIN_LOC=$BASE_DIR/bin/$filename.bin

/usr/local/bin/i386-elf-gcc -ffreestanding -c $INPUT_FILE -o $OBJ_LOC
/usr/local/bin/i386-elf-ld -o $BIN_LOC -Ttext 0x1000 --oformat binary $OBJ_LOC
