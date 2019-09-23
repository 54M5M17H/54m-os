
[org 0x7c00]  ; tell assembler the offset of this code segment

	; mov bx, HELLO_MSG
	; call print_string

	; mov bx, GOODBYE_MSG
	; call print_string

	mov dx, 0x1fb6
	call print_hex

	jmp $  ; $ means current position -- infinite loop

%include "print_string.asm"
%include "print_hex.asm"

HELLO_MSG:
	db 'Hello world', 0

GOODBYE_MSG:
	db 'Goodbye!', 0

	times 510 -( $ - $$ ) db 0  ; pad to 510 bytes
	dw 0xaa55  ; magic number to signify boot loader
