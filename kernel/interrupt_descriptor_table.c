#include "interrupt_descriptor_table.h"

void set_idt_entry(int i, word handler) {
	idt[i].offset_low = low_16(handler);
	idt[i].offset_high = low_16(handler);
	idt[i].code_segment_selector = KERNEL_CODE_SEGMENT;
	idt[i].zero = 0;
	idt[i].type_attributes = 0x8E; // 0b10001110
}

void set_idt() {
	idt_reg.offset = (word) &idt;

	// size of the IDT is:
	// number of entries * sizeof entries, set back one
	// not sure why set back: something to do with 0 index??
	idt_reg.limit = IDT_ENTRIES_NUMBER * sizeof(IDT_Entry) - 1;

	// load idt instruction
	// volatile means don't move it
	// loads idt_reg pointer into the idt reg
	__asm__ __volatile__ ("lidtl (%0)" : : "r" (&idt_reg));
}
