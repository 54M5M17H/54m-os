[bits 32]

; takes pointer to string in ebx and prints it out in VGA mode
; will always overwrite existing text

; constants
VGA_MEM equ 0xb8000  ; this is where we write text to
WHITE_ON_BLACK equ 0x0f

print_string_vga:
	pusha
	mov edx, VGA_MEM  ; edx is extended `d`reg -- we get extended registers in 32-bit mode

_print_char_vga:
	mov al, [ebx]  ; get next char
	mov ah, WHITE_ON_BLACK  ; set attributes in ah
	
	cmp al, 0  ; if 0, we're done
	je _end_vga_text

	mov [edx], ax  ; store character and attributes in VGA_MEM at current index

	add ebx, 1  ; point to next char in string
	
	add edx, 2  ; point to next character location in VGA_MEM
				; uses 2 bytes - 1 for ASCII code, 1 for attributes
	
	jmp _print_char_vga

_end_vga_text:
	popa 
	ret

