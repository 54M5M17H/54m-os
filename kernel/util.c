void memory_copy(char *source, char *destination, int number_of_bytes) {
	for (int i = 0; i < number_of_bytes; i++) {
		*(destination + i) = *(source + i);
	}
}

// itoa - int to string, including sign and NULL stop
void itoa(int num, char strng[]) {
	int sign = num < 0 ? 1 : 0;
	num = num < 0 ? -num : num;

	int i = 0;
	do {
		strng[i] = (num % 10) + '0';
		i++;
		num /= 10;
	} while (num > 0);

	if (sign) {
		strng[i] = '-';
		i++;
	}
	strng[i] = '\0';

	reverse_string(strng, i);
}

void reverse_string(char strng[], int length) {
	length--;
	int fromRight = length;
	int halfway;
	int iIsOdd = length & 1;
	if (iIsOdd) {
		halfway = (length + 1) / 2;
	} else {
		halfway = length / 2;
	}

	while (length >= halfway) {
		char tmp = strng[length];
		strng[length] = strng[fromRight - length];
		strng[fromRight - length] = tmp;
		length--;
	}
}
