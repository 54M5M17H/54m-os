/*
	Inline assembly:
	- target & destination order swapped from nasm: target then destination here
	- % is a C escape char: so %% will give up literal "%"
	- we use % to refer to registers
*/

// - "=a" means store a register in variable: e.g. "=a" result -> store in `result` variable
// - "d" means load d register with data: e.g. "d" port -> load d register with `port` variable
unsigned char read_byte_from_port(unsigned short port) {
	unsigned char result;
	__asm__("in %%dx, %%al"
			: "=a"(result)
			: "d"(port));

	return result;
}

// - `"a" (data)` means load data var into `a` reg
// - `"d" (port)` means load port var into `d` reg
// - empty line after colon - no output
void write_byte_to_port(unsigned short port, unsigned char data) {
	__asm__("out %%al, %%dx"
			:
			: "a"(data), "d"(port));
}

unsigned short read_word_from_port(unsigned short port) {
	unsigned short result;
	__asm__("in %%dx, %%ax"
			: "=a"(result)
			: "d"(port));

	return result;
}

void write_word_to_port(unsigned short port, unsigned short data) {
	__asm__("out %%ax, %%dx"
			:
			: "a"(data), "d"(port));
}
