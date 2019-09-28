#!/bin/bash

./compile_c.sh ../../kernel/main.c
nasm ../../kernel/entry.asm -f elf -o ../../objs/entry.o

/usr/local/bin/i386-elf-ld -o ../../bin/kernel.bin -Ttext 0x1000 ../../objs/entry.o ../../objs/main.o --oformat binary
