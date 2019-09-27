#!/bin/bash

./compile_asm.sh ../../boot/boot_to_kernel.asm
./compile_c.sh ../../kernel/kernel.c

cat ../../bin/boot_to_kernel.bin ../../bin/kernel.bin > ../../os_image

qemu-system-x86_64 -monitor stdio -fda ../../os_image