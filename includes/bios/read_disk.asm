
disk_load:
	pusha
	push dx  ; dx contains the number of sectors we are requesting
	         ; push to stack so we can compare with result later

	mov ah, 0x02  ; BIOS interrupt code for disk read
	mov al, dh    ; dh is the argument for number of sectors to read
				  ; al is where the interrupt expects it
	mov ch, 0x00  ; hardcode selection of cylinder 0
	mov dh, 0x00  ; hardcode selection of head 0
	mov cl, 0x02  ; read from second sector, one after our bootloader 

	int 0x13      ; issue BIOS interrupt

	jc disk_error  ; jc == jump if carry set -> interrupt will set carry if error
	pop dx         ; restore to dx the number of requested sectors
	cmp dh, al     ; compare to the number of sectors read successfully
	jne disk_error ; if not equal, error occurred

	popa
	ret

disk_error:
	mov bx, DISK_ERR_MSG
	call print_string
	jmp $

DISK_ERR_MSG: db "Disk read error !", 0
