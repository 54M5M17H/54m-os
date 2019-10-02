#include "interrupt_service_routines.h"
#include "../drivers/screen.h"
#include "interrupt_descriptor_table.h"
#include "util.h"

// can't use loop
// need the address of functions
// functions defined in asm
void isr_install() {
	set_idt_entry(0, (word)isr0);
	set_idt_entry(1, (word)isr1);
	set_idt_entry(2, (word)isr2);
	set_idt_entry(3, (word)isr3);
	set_idt_entry(4, (word)isr4);
	set_idt_entry(5, (word)isr5);
	set_idt_entry(6, (word)isr6);
	set_idt_entry(7, (word)isr7);
	set_idt_entry(8, (word)isr8);
	set_idt_entry(9, (word)isr9);
	set_idt_entry(10, (word)isr10);
	set_idt_entry(11, (word)isr11);
	set_idt_entry(12, (word)isr12);
	set_idt_entry(13, (word)isr13);
	set_idt_entry(14, (word)isr14);
	set_idt_entry(15, (word)isr15);
	set_idt_entry(16, (word)isr16);
	set_idt_entry(17, (word)isr17);
	set_idt_entry(18, (word)isr18);
	set_idt_entry(19, (word)isr19);
	set_idt_entry(20, (word)isr20);
	set_idt_entry(21, (word)isr21);
	set_idt_entry(22, (word)isr22);
	set_idt_entry(23, (word)isr23);
	set_idt_entry(24, (word)isr24);
	set_idt_entry(25, (word)isr25);
	set_idt_entry(26, (word)isr26);
	set_idt_entry(27, (word)isr27);
	set_idt_entry(28, (word)isr28);
	set_idt_entry(29, (word)isr29);
	set_idt_entry(30, (word)isr30);
	set_idt_entry(31, (word)isr31);

	set_idt(); // load with asm
}

void isr_handler(Register_Table rt) {
	screen_print("received interrupt...\n\0");
	
}