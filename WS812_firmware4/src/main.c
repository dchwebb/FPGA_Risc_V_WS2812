#define	__timer_t_defined		// To avoid error c:\lscc\propel\2.0\sdk\riscv-none-embed-gcc\riscv-none-embed\include\sys\types.h:205:19: error: conflicting types for 'timer_t'

#include "utils.h"
#include "WS2812.h"
#include "uart.h"
#include "gpio.h"
#include "pic.h"
#include <string.h>

uint8_t interrupt;
uint8_t uart_pos;
uint8_t command_received;
#define UART_COM_LEN 20
char uart_command[UART_COM_LEN];

void gpio_interrupt_handler(void* context) {
	interrupt++;
	((GPIO_TypeDef*)context)->INT_STATUS = 0xF;		// Clear the interrupt on the GPIO peripheral
}

void uart_interrupt_handler(void* context) {
	interrupt++;

	// If a command is already pending, ignore
	if (!command_received) {
		char rec = ((uart_t*)context)->rxtx;
		if (rec == 10 || rec == 13) {
			command_received = 1;
			rec = 0;		// replace end of line character with null for string comparison
		}
		if (uart_pos < UART_COM_LEN)
			uart_command[uart_pos++] = rec;
	}

	uint32_t iir = ((uart_t*)context)->iir;		// Clear the interrupt on the UART peripheral (should be 4 when receive found)
}

void ws2812_interrupt_handler(void* context) {
	interrupt++;
}

int main(void) {
	uart_pos = 0;
	command_received = 0;

	// Register IRQ handler for GPIO and UART interrupts (this also enables the interrupt)
	pic_init(CPU0_INST_PICTIMER_START_ADDR);
	//pic_isr_register(GPIO0_INST_IRQ, gpio_interrupt_handler, GPIO0);
	pic_isr_register(UART0_INST_IRQ, uart_interrupt_handler, UART0);
	pic_isr_register(WS2812_INST_IRQ, ws2812_interrupt_handler, WS2812);

	volatile int status, control;
	set_colour(0, 0);
	set_colour(1, 0);
	set_colour(2, 0);

	control = WS2812->CONTROL;

	WS2812->CONTROL |= WS2812_CONTROL_INT_ENABLE;		// Enable WS2812 finished send Interrupts
	UART0->ier |= UART_IER_RX_INT_MASK;					// UART Enable receive interrupts

	set_rgb_colour(0, 0x11, 0x00, 0x00);
	set_rgb_colour(1, 0x00, 0x11, 0x00);
	set_rgb_colour(2, 0x00, 0x00, 0x11);

	static uint8_t idx = 0;
	uartPutS("Hello RISC-V world!\r\n");
	LED_SET(ALL_OFF);

	while (true) {
		// Check if a uart command has been received
		if (command_received) {
			command_received = 0;
			uart_pos = 0;
			if (strcmp(uart_command, "led1") == 0) {
				// check if led1 is on
				WS2812->COLOUR_RD = 0;
				if (WS2812->COLOUR_RD == 0)
					set_rgb_colour(0, 0x11, 0x00, 0x00);
				else
					set_rgb_colour(0, 0x00, 0x00, 0x00);
			}
		}

		LED_SET(LED_ON(idx));

		if (++idx == LED_COUNT) {
			idx = 0;
		}

		delayMS(500);
	}

	return 0;
}

