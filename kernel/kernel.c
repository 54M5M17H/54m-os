void main() {
	// point to the first character in VGA memory
	char *video_memory = (char *)0xb8000;

	*video_memory = 'X';
}