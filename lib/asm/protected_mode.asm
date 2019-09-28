[bits 16]
switch_to_protected_mode:
	cli  					; turn interrupts off
	lgdt [gdt_descriptor]   ; load the global descriptor table

	; make the switch to 32-bit protected mode
	; by setting the first bit of control register zero (cro)
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	; welcome to 32 bit protected mode
	; except not exactly
	; because of `pipelining`
	; the CPU may still execute the next instruction in 16-bit mode
	; because it may have READ that instruction before COMPLETING the previous
	; to clear this pipelining we need to issue an instruction which the CPU
	; cannot predict in advance -- e.g. a jump to a faraway segment
	; this will force it to clear the pipeline before executing more instructions

	; we don't need to jump physically far
	; we just need to jump to a different segment
	; we can do that by jumping to our new code segment;
	; defined by the GDT
	jmp CODE_SEG:init_protected_mode
	; jmp works because our base offset is 0, where we already are

[bits 32]  ; tell the assembler this is 32-bits
init_protected_mode:
	; after the "far jump" here we are certainly in 32-bit mode
	
	mov ax, DATA_SEG  ; load the offset to the data segment into ax

	; then point all segment registers to that segment
	mov ds , ax
	mov ss , ax
	mov es , ax
	mov fs , ax
	mov gs , ax

	; put our stack right at top of free space
	mov ebp, 0x90000
	mov esp, ebp

	; a label implemented indepently
	; the place to go once in protected mode
	; should never return
	call BEGIN_PROTECTED_MODE

	jmp $
