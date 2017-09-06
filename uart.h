#ifndef _UART_H_
#define _UART_H_

#include <stdint.h>

#include "stm8.h"
#include "settings.h"

inline void UART_init(void) {
    UART2->BRR2 = (((CPU_F + BAUD/2) / BAUD) & 0x000F) | ((((CPU_F + BAUD/2) / BAUD) & 0xF000) >> 8);
    UART2->BRR1 = (((CPU_F + BAUD/2) / BAUD) & 0x0FF0) >> 4;
    UART2->CR2 = UART_CR2_TEN;
}

inline void UART_send(uint8_t v) {
    while(!(UART2->SR & UART_SR_TXE));
    UART2->DR = v;
}

void UART_write(const char *str);

void UART_writeHexU8(uint8_t v);

void UART_writeHexU16(uint16_t v);

void UART_writeHexU32(uint32_t v);

void UART_writeDecU32(uint32_t v);

#endif // _UART_H_