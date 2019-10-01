#ifndef TYPES_H
#define TYPES_H

typedef unsigned char byte;
typedef unsigned short double_byte;
typedef unsigned int word; // 4 bytes

#define low_16(address) (u16)((address) & 0xFFFF)
#define high_16(address) (u16)(((address) >> 16) & 0xFFFF)

#endif
