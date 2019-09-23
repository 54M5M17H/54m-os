
[org 0x7c00]  ; tell assembler the offset of this code segment

	; mov bx, HELLO_MSG
	; call bios_print_string

	; mov bx, GOODBYE_MSG
	; call bios_print_string

	; mov dx, 0x1fb6
	; call bios_print_hex

	; mov [BOOT_DRIVE], dl  ; dl is where BIOS puts our boot device -- store it away

	; mov bp, 0x8000  ; set stack start
	; mov sp, bp

	; mov dh, 5       ; read 5 sectors
	; mov bx, 0x9000  ; and store somewhere in our stack
	; mov dl, [BOOT_DRIVE]
	; call bios_disk_load

	; mov dx, [0x9000]  ; print first word from first loaded sector
	; call bios_print_hex

	; mov dx, [0x9000 + 512]  ; print first word from second loaded sector
	; call bios_print_hex


	jmp $  ; $ means current position -- infinite loop

%include "print_string_vga.asm"
%include "bios/print_string.asm"
%include "bios/print_hex.asm"
%include "bios/read_disk.asm"

HELLO_MSG:
	db 'Hello world', 0

GOODBYE_MSG:
	db 'Goodbye!', 0


BOOT_DRIVE: db 0

	; finally, pad what's left
	times 510 -( $ - $$ ) db 0  ; pad to 510 bytes
	dw 0xaa55  ; magic number to signify boot loader

	; pad drive with 2 more sectors
	; 512 bytes (256 words) each
	; these should be loaded by our bios_disk_load routine
	times 256 dw 0xdada
	times 256 dw 0xface
