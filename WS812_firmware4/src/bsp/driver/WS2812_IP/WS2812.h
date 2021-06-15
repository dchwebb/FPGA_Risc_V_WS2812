#pragma once

#include <stdint.h>
#include "sys_platform.h"

typedef struct {
	volatile uint32_t STATUS;		// Address offset: 0x00
	volatile uint32_t CONTROL;		// Address offset: 0x04
	volatile uint32_t COLOUR_WR;	// Address offset: 0x08
	volatile uint32_t COLOUR_RD;	// Address offset: 0x0C
} WS2812_TypeDef;
#define WS2812 ((WS2812_TypeDef *) WS2812_INST_BASE_ADDR)

#define WS2812_COLOUR_LED_POS 24
#define WS2812_COLOUR_G_POS 16
#define WS2812_COLOUR_R_POS 8
#define WS2812_COLOUR_B_POS 0

#define WS2812_CONTROL_AUTOSEND 1
#define WS2812_CONTROL_SEND 2
#define WS2812_CONTROL_INT_ENABLE 4

void set_colour(uint8_t led_number, uint32_t led_colour);
void set_rgb_colour(uint8_t led_number, uint8_t red, uint8_t green, uint8_t blue);
