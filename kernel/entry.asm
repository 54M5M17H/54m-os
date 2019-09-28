
; we are already in protected mode
[bits 32]

; we are calling main in linked C binary
[extern main]

; ensures that main is the entry point called
call main

jmp $