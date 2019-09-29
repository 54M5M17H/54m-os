# right side of colon - dependencies
# left side - output files

# $< means first dependency
# $@ means target file
# $^ means all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
C_FLAGS = -g

# list of object file targets
OBJ_DIR = objs
TMP_OBJS = $(patsubst kernel/%.c,$(OBJ_DIR)/%.o,$(C_SOURCES))
OBJS = $(patsubst drivers/%.c,$(OBJ_DIR)/%.o,$(TMP_OBJS))

CC = /usr/local/bin/i386-elf-gcc
LD = /usr/local/bin/i386-elf-ld
GDB = /usr/local/bin/i386-elf-gdb

QEMU = qemu-system-x86_64
# there is a GDB bug preventing gdb from working in 64-bit mode
QEMU_DEBUG = qemu-system-i386


all: img/os_image

# all is defined above as os_image
run: all
	${QEMU} -monitor stdio -fda img/os_image

img/os_image: bin/boot_sector.bin bin/kernel.bin
	cat $^ > $@

bin/kernel.bin: objs/entry.o ${OBJS}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

# C files depend on all headers for ease
objs/%.o: */%.c ${HEADERS}
	${CC} ${C_FLAGS} -ffreestanding -c $< -o $@

objs/%.o: kernel/%.asm
	nasm $< -f elf -o $@

bin/boot_sector.bin: boot/boot_sector.asm
	nasm $< -f bin -i lib/asm -o $@

clean:
	rm -rf **/*.o **/*.bin img/*


# DEBUGGING commands

debug/kernel.elf: objs/entry.o ${OBJS}
	${LD} -o $@ -Ttext 0x1000 $^

run-gdb: img/os_image debug/kernel.elf
	${QEMU_DEBUG} -s -S -fda img/os_image &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file debug/kernel.elf"

run-debug: img/os_image debug/kernel.elf
	${QEMU_DEBUG} -s -S -fda img/os_image
	# NOW ATTACH VSCODE
