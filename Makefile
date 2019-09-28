# right side of colon - dependencies
# left side - output files

# $< means first dependency
# $@ means target file
# $^ means all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# list of object file targets
OBJ_DIR = objs
OBJS = $(patsubst kernel/%.c,$(OBJ_DIR)/%.o,$(C_SOURCES))

# $(info $(OBJS))

all: img/os_image

# all is defined above as os_image
run: all
	qemu-system-x86_64 -monitor stdio -fda img/os_image

img/os_image: bin/boot_sector.bin bin/kernel.bin
	cat $^ > $@

bin/kernel.bin: objs/entry.o ${OBJS}
	/usr/local/bin/i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# C files depend on all headers for ease
objs/%.o: kernel/%.c ${HEADERS}
	/usr/local/bin/i386-elf-gcc -ffreestanding -c $< -o $@

objs/%.o: kernel/%.asm
	nasm $< -f elf -o $@

bin/boot_sector.bin: boot/boot_sector.asm
	nasm $< -f bin -i lib/asm -o $@

clean:
	rm -rf **/*.o **/*.bin img/*