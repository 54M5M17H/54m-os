#define VIDEO_ADDRESS 0xb8000
#define WHITE_ON_BLACK_TXT 0x0f
#define ROWS_ON_SCREEN 25
#define COLS_PER_ROW 80
#define MAX_SCREEN_OFFSET ROWS_ON_SCREEN *COLS_PER_ROW * 2

// screen I/O ports
#define PORT_SCREEN_CTRL 0x3d4
#define PORT_SCREEN_DATA 0x3d5

void screen_print(char *message);
void screen_print_at(char *message, int row, int col, char attributes);
void clear_screen();