// #include "screen.h"

// // print a character on the screen at row & col
// // if column or row are negative, current cursor position will be used instead
// void print_char(char character, int row, int col, char attributes) {
// 	unsigned char *video_mem = (unsigned char *)VIDEO_ADDRESS;

// 	if (!attributes) {
// 		// default
// 		attributes = WHITE_ON_BLACK_TXT;
// 	}

// 	int offset;
// 	if (col >= 0 && row >= 0) {
// 		offset = get_screen_offset(row, col);
// 	} else {
// 		offset = get_cursor();
// 	}

// 	// TODO: bit about newline char

// 	// make offset the next character -- 2 bytes forward
// 	offset += 2;
// 	offset = handle_scrolling(offset);
// 	set_cursor(offset);
// }