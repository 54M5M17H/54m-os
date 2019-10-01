#ifndef IDT_H
#define IDT_H

#include "types.h"

typedef struct {
	double_byte offset_low; // bits 0->15 of the offset
	double_byte code_segment_selector;
	byte zero; // unused -- always 0

	/*
	** TYPE ATTRIBUTES:
	** bit 7: present? 0 if interrupt unused
	** bit 5-6: required privilege level
	** bit 4: storage segment? 0 for interrupts
	** bit 3-0: set to 0xE for a 32-bit interrupt
	**/
	byte type_attributes;

	double_byte offset_high; // bits 16-31 of offset

} __attribute__((packed)) IDTEntry;
// packed attribute -- pack into minimal space
// lays it out as it would if we wrote in assembly

// a structure given to 'load idt' instruction
// it will point to the array of IDTEntries we create
typedef struct {
	double_byte limit;
	word offset;
} __attribute__((packed)) IDT_Register;

#define IDT_ENTRIES_NUMBER 256

#endif
