#include "interrupt_descriptor_table.h"

void set_idt_entry(int i, word handler) {
	idt[i].offset_low = low_16(handler);
	idt[i].offset_high = low_16(handler);
	idt[i].code_segment_selector = KERNEL_CODE_SEGMENT;
	idt[i].zero = 0;
	idt[i].type_attributes = 0x8E; // 0b10001110
}

void set_idt() {
	idt_reg.base = (word) &idt;
	idt_reg.limit = IDT_ENTRIES_NUMBER * sizeof(IDT_Entry) - 1;
}
