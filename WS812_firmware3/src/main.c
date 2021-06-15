#include "utils.h"
#include "WS2812.h"
#include "uart.h"



int main(void) {
	volatile int status, control;
	set_colour(0, 0);
	set_colour(1, 0);
	set_colour(2, 0);

	control = WS2812->CONTROL;

	WS2812->CONTROL = 0x0;		// Set auto send off

	set_rgb_colour(0, 0x11, 0x00, 0x00);
	control = WS2812->CONTROL;

	WS2812->CONTROL = 0x1;		// Set auto send on

	set_rgb_colour(1, 0x00, 0x11, 0x00);
	set_rgb_colour(2, 0x00, 0x00, 0x11);



	static uint8_t idx = 0;
	DEBUG_PRINTF("Hello RISC-V world!\r\n");
	LED_SET(ALL_OFF);

	while (true) {
		LED_SET(LED_ON(idx));

		if (++idx == LED_COUNT) {
			idx = 0;
		}

		if (RTL_SIM) {
			delayMS(1);
		} else {
			delayMS(500);
		}
	}

	return 0;
}

