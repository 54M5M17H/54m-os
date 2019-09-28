; GDT
; a "basic flat model" of gdt, the simplest workable gdt Intel recommends

gdt_start:

; key:
; db -> define byte
; dw -> define word (2 bytes)
; dd -> define double word (4 bytes)


gdt_null:  ; a NULL descriptor is required to begin
	dd 0x0
	dd 0x0


gdt_code:  ; defines the code segment

	; the base and limit bits are both separated out
	; into and order that must've been a joke

	dw 0xffff  ; Limit: bits 0-15

	dw 0x0     ; Base: bits 0-15
	db 0x0     ; Base: bits 16-23

	; 1st flags: ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
	; && type flags: ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
	db 10011010b


	; 2nd flags: ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100b
	; && limit bits 16-19: 1111b
	db 11001111b

	db 0x0 ; Base: bits 24-31

gdt_data:  ; defines the data segment

	; this is the same as gdt_code
	; EXCEPT the type flags

	dw 0xffff  ; Limit: bits 0-15

	dw 0x0     ; Base: bits 0-15
	db 0x0     ; Base: bits 16-23

	; 1st flags: ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
	; && type flags : ( code )0 ( expand down )0 ( writable )1 ( accessed )0 -> 0010b
	db 10010010b


	; 2nd flags: ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100b
	; && limit bits 16-19: 1111b
	db 11001111b

	db 0x0 ; Base: bits 24-31

gdt_end:
; the end label is so the assembler can calculate the size of the GDT
; we need to know the size for the descriptor below


gdt_descriptor:
	; size of the gdt minus 1, not sure why? Maybe something to do with 0-indexing of addresses?
	dw gdt_end - gdt_start - 1

	; write the start address of the gdt to the descriptor
	dd gdt_start


; some useful offsets
; we need to give these to segment registers
; so the CPU knows which segment we wish to access
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
