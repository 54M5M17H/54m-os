#!/bin/bash

./compile_bootloader.sh ../../boot/boot_to_kernel.asm
./compile_kernel.sh

cat ../../bin/boot_to_kernel.bin ../../bin/kernel.bin > ../../os_image

qemu-system-x86_64 -monitor stdio -fda ../../os_image