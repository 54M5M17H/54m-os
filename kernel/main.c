#include "../drivers/screen.h"

void something_else() {
	char *video_memory = (char *)0xb8000;

	*video_memory = 'Y';
}

void main() {
	// point to the first character in VGA memory
	char *video_memory = (char *)0xb8000;

	*video_memory = 'X';

	clear_screen();
	char message[16] = "Row Number: 00\n\0";

	for (int i = 0; i < 30; i++) {
		char onesPlace = (char)(i % 10) + 48;
		char tensPlace = (char)((i / 10) % 10) + 48;
		message[12] = tensPlace;
		message[13] = onesPlace;
		screen_print(message);
	}

	// screen_print("Hello, Beautiful World\0");
	// screen_print_at("Can you see me?\0", 10, 40, 0);
}