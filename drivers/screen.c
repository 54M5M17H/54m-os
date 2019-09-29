#include "screen.h"
#include "../kernel/ports.h"
#include "../kernel/util.h"

int print_char_at(char character, int row, int col, char attributes);
int get_position_offset(int row, int col);
int get_cursor_offset();
void set_cursor(int offset);
int calculate_row_from_offset(int offset);
int calculate_col_from_offset(int offset, int row);
int handle_scroll(int offset);

void screen_print(char *message) {
	screen_print_at(message, -1, -1, 0);
}

void screen_print_at(char *message, int row, int col, char attributes) {
	int offset;
	int i = 0;
	while (message[i] != 0 || message[i] != '\0') {
		offset = print_char_at(message[i], row, col, attributes);

		// calculate for next time -- could just add 1 to col?
		// then would need to handle where col is -1 -- initiate it
		row = calculate_row_from_offset(offset);
		col = calculate_col_from_offset(offset, row);
		i++;
	}
}

void clear_screen() {
	// for (int r = 0; r < ROWS_ON_SCREEN; r++) {
	// 	for (int c = 0; c < COLS_PER_ROW; c++) {
	// 		print_char_at(0, r, c, WHITE_ON_BLACK_TXT);
	// 	}
	// }

	unsigned char *video_mem = (unsigned char *)VIDEO_ADDRESS;
	for (int i = 0; i < MAX_SCREEN_OFFSET / 2; i += 2) {
		// Don't overwrite the attributes bytes -- means cursor isn't visible
		video_mem[i] = 0;
	}

	set_cursor(0);
}

/**************************
 **** PRIVATE METHODS *****
 *************************/

// print a character on the screen at row & col
// if column or row are negative, current cursor position will be used instead
int print_char_at(char character, int row, int col, char attributes) {
	unsigned char *video_mem = (unsigned char *)VIDEO_ADDRESS;

	if (!attributes) {
		// default
		attributes = WHITE_ON_BLACK_TXT;
	}

	// TODO: handle row or col is out of bounds
	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_position_offset(row, col);
	} else {
		offset = get_cursor_offset();
	}

	// TODO: bit about newline char

	if (character == '\n') {
		// if new line character, move cursor to start of next row
		row = calculate_row_from_offset(offset);
		offset = get_position_offset(row + 1, 0);
	} else {
		// otherwise, print it
		video_mem[offset] = character;
		video_mem[offset + 1] = attributes;

		// make offset the next character -- 2 bytes forward
		offset += 2;
	}

	offset = handle_scroll(offset);
	set_cursor(offset);
	return offset;
}

// gets the number of bytes offset for a particular character position
int get_position_offset(int row, int col) {
	// 2 * because each character is 2 bytes -- 1 for ASCII, 1 for attributes
	return 2 * ((COLS_PER_ROW * row) + col);
}

// calculates row from offset
int calculate_row_from_offset(int offset) {
	// because we are working in integers
	// we don't need to worry about rounding down to the row end
	// && we don't need to use the column as a result
	return offset / (COLS_PER_ROW * 2);
}

// calculates col from offset
int calculate_col_from_offset(int offset, int row) {
	if (row < 0) {
		row = calculate_row_from_offset(offset);
	}
	return (offset / 2) - (COLS_PER_ROW * row);
}

// get the position of the cursor from the VGA ports
int get_cursor_offset() {
	// ask for the high byte of the cursor offset (14)
	write_byte_to_port(PORT_SCREEN_CTRL, 14);
	// and read it in
	int offset = read_byte_from_port(PORT_SCREEN_DATA);

	// shift 8 bits up to make way for lower half of offset
	offset = offset << 8;

	// ask for the low byte of the cursor offset (15)
	write_byte_to_port(PORT_SCREEN_CTRL, 15);
	offset += read_byte_from_port(PORT_SCREEN_DATA);

	// each character is 2 bytes in size
	return offset * 2;
}

void set_cursor(int offset) {
	// discount 2 bytes per char -- only care about number of chars here
	offset /= 2;

	// write high byte
	write_byte_to_port(PORT_SCREEN_CTRL, 14);
	write_byte_to_port(PORT_SCREEN_DATA, offset >> 8);

	// write low byte
	write_byte_to_port(PORT_SCREEN_CTRL, 15);
	// use bitwise-AND to mask top byte, send only low byte
	write_byte_to_port(PORT_SCREEN_DATA, offset & 0xff);
}

int handle_scroll(int offset) {
	if (offset < MAX_SCREEN_OFFSET) {
		return offset;
	}

	int i;

	// shuffle each row up 1 -- skip 0 as will be overwritten
	for (i = 1; i < ROWS_ON_SCREEN; i++) {
		int current_row_offset = get_position_offset(i, 0);
		int previous_row_offset = get_position_offset(i - 1, 0);

		memory_copy(
			(char *)(current_row_offset + VIDEO_ADDRESS),
			(char *)(previous_row_offset + VIDEO_ADDRESS),
			COLS_PER_ROW * 2);
	}

	// blank out last line
	char *last_line_address = (char *)(get_position_offset(ROWS_ON_SCREEN - 1, 0) + VIDEO_ADDRESS);
	for (i = 0; i < COLS_PER_ROW * 2; i++) {
		last_line_address[i] = 0;
	}

	// move offset back to last visible rom
	offset -= COLS_PER_ROW * 2;
	return offset;
}
