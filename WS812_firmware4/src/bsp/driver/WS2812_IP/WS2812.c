#include "WS2812.h"

void set_colour(uint8_t led_number, uint32_t led_colour) {
	WS2812->COLOUR_WR = (led_number << WS2812_COLOUR_LED_POS) | (led_colour & 0xFFFFFF);
}

void set_rgb_colour(uint8_t led_number, uint8_t red, uint8_t green, uint8_t blue) {
	WS2812->COLOUR_WR = (led_number << WS2812_COLOUR_LED_POS) |
			((red & 0xFF) << WS2812_COLOUR_R_POS |
			(green & 0xFF) << WS2812_COLOUR_G_POS |
			(blue & 0xFF) << WS2812_COLOUR_B_POS);
}
