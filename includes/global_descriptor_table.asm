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

