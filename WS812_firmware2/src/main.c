#include "utils.h"

typedef struct {
	volatile uint32_t STATUS;		// Address offset: 0x00
	volatile uint32_t CONTROL;		// Address offset: 0x04
	volatile uint32_t COLOUR;		// Address offset: 0x08
} WS2812_TypeDef;
#define WS2812 ((WS2812_TypeDef *) WS2812_INST_BASE_ADDR)



int main(void) {
	volatile int status, control;
	status = WS2812->STATUS;
	control = WS2812->CONTROL;

	WS2812->COLOUR = 0xFF0000;
	status = WS2812->STATUS;
	control = WS2812->CONTROL;

	WS2812->COLOUR = 0x0100FF00;
	status = WS2812->STATUS;
	control = WS2812->CONTROL;



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

