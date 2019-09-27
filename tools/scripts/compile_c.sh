#!/bin/bash

# gcc -ffreestanding -c basic.c -o basic.o
filename=$(echo $1 | sed 's/\.[^.]*$//') # remove any file extensions from the passed arg $1

/usr/local/bin/i386-elf-gcc -ffreestanding -c $filename.c -o $filename.o
/usr/local/bin/i386-elf-ld -o $filename.bin -Ttext 0x0 --oformat binary $filename.o