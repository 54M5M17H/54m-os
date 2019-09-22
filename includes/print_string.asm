; takes 1 argument: pointer to first character of NULL-terminated string
print_string:
	pusha  ; push all registers to the stack
	mov ah, 0x0e  ; interrupt code 14 (scrolling teletype BIOS routine) in high end of register a

	call _get_next_char

	popa  ; pop all registers back off the stack
	ret  ; return

_get_next_char:
	mov al, [bx]
	cmp al, 0
	jne _print_char
	ret

_print_char:
	int 0x10  ; issue interrupt
	add bx, 1  ; point to next character
	jmp _get_next_char
