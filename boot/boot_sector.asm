; a boot loader for our kernel

[org 0x7c00]

KERNEL_OFFSET equ 0x1000 ; the memory offset that we'll load our kernel code in to

	mov [BOOT_DRIVE], dl  ; our boot drive is stored in dl -- let's save that

	; setup the stack
	mov bp, 0x9000
	mov sp, bp

	mov bx, LAUNCH_MSG
	call bios_print_string

	call load_kernel

	call switch_to_protected_mode

	; should never return back to here

	jmp $

; our libs
%include "bios/print_string.asm"
%include "bios/read_disk.asm"
%include "print_string_vga.asm"
%include "global_descriptor_table.asm"
%include "protected_mode.asm"

[bits 16]

; load the kernel
load_kernel:
	mov bx, KERNAL_MSG
	call bios_print_string

	mov bx, KERNEL_OFFSET  ; store in KERNEL_OFFSET
	mov dh, 15  ; read 15 sectors
	mov dl, [BOOT_DRIVE]
	call bios_disk_load

	ret

[bits 32]
BEGIN_PROTECTED_MODE:
	mov ebx, PM_MSG
	call print_string_vga

	; now let's jump in to our kernel !
	call KERNEL_OFFSET

	jmp $

; global vars
BOOT_DRIVE: db 0
LAUNCH_MSG: db 'Started in real mode', 0
KERNAL_MSG: db 'Loading the kernel', 0
PM_MSG: db 'Landed in protected mode', 0

; aaannnnd pad
times 510 -( $ - $$ ) db 0  ; pad to 510 bytes
dw 0xaa55  ; magic number to signify boot loader