[org 0x7c00]  ; tell assembler the offset of this code segment

	; set stack
	; mov bp, 0x9000
	; mov sp, bp

	mov bx, UNPROTECTED_MODE_MSG
	call bios_print_string

	call switch_to_protected_mode
	; should never return to here

	jmp $

%include "bios/print_string.asm"
%include "print_string_vga.asm"
%include "global_descriptor_table.asm"
%include "protected_mode.asm"

HELLO_MSG:
	db 'Hello world', 0

UNPROTECTED_MODE_MSG:
	db 'Launching protected mode...', 0
PROTECTED_MODE_MSG:
	db 'Inside protected mode...', 0

; finally, pad what's left
times 510 -( $ - $$ ) db 0  ; pad to 510 bytes
dw 0xaa55  ; magic number to signify boot loader