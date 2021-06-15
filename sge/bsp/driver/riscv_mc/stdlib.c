/*   ==================================================================

     >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
     ------------------------------------------------------------------
     Copyright (c) 2019-2020 by Lattice Semiconductor Corporation
     ALL RIGHTS RESERVED
     ------------------------------------------------------------------

       IMPORTANT: THIS FILE IS USED BY OR GENERATED BY the LATTICE PROPEL™
       DEVELOPMENT SUITE, WHICH INCLUDES PROPEL BUILDER AND PROPEL SDK.

       Lattice grants permission to use this code pursuant to the
       terms of the Lattice Propel License Agreement.

     DISCLAIMER:

    LATTICE MAKES NO WARRANTIES ON THIS FILE OR ITS CONTENTS,
    WHETHER EXPRESSED, IMPLIED, STATUTORY,
    OR IN ANY PROVISION OF THE LATTICE PROPEL LICENSE AGREEMENT OR
    COMMUNICATION WITH LICENSEE,
    AND LATTICE SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF
    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
    LATTICE DOES NOT WARRANT THAT THE FUNCTIONS CONTAINED HEREIN WILL MEET
    LICENSEE 'S REQUIREMENTS, OR THAT LICENSEE' S OPERATION OF ANY DEVICE,
    SOFTWARE OR SYSTEM USING THIS FILE OR ITS CONTENTS WILL BE
    UNINTERRUPTED OR ERROR FREE,
    OR THAT DEFECTS HEREIN WILL BE CORRECTED.
    LICENSEE ASSUMES RESPONSIBILITY FOR SELECTION OF MATERIALS TO ACHIEVE
    ITS INTENDED RESULTS, AND FOR THE PROPER INSTALLATION, USE,
    AND RESULTS OBTAINED THEREFROM.
    LICENSEE ASSUMES THE ENTIRE RISK OF THE FILE AND ITS CONTENTS PROVING
    DEFECTIVE OR FAILING TO PERFORM PROPERLY AND IN SUCH EVENT,
    LICENSEE SHALL ASSUME THE ENTIRE COST AND RISK OF ANY REPAIR, SERVICE,
    CORRECTION,
    OR ANY OTHER LIABILITIES OR DAMAGES CAUSED BY OR ASSOCIATED WITH THE
    SOFTWARE.IN NO EVENT SHALL LATTICE BE LIABLE TO ANY PARTY FOR DIRECT,
    INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
    INCLUDING LOST PROFITS,
    ARISING OUT OF THE USE OF THIS FILE OR ITS CONTENTS,
    EVEN IF LATTICE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
    LATTICE 'S SOLE LIABILITY, AND LICENSEE' S SOLE REMEDY,
    IS SET FORTH ABOVE.
    LATTICE DOES NOT WARRANT OR REPRESENT THAT THIS FILE,
    ITS CONTENTS OR USE THEREOF DOES NOT INFRINGE ON THIRD PARTIES'
    INTELLECTUAL PROPERTY RIGHTS, INCLUDING ANY PATENT. IT IS THE USER' S
    RESPONSIBILITY TO VERIFY THE USER SOFTWARE DESIGN FOR CONSISTENCY AND
    FUNCTIONALITY THROUGH THE USE OF FORMAL SOFTWARE VALIDATION METHODS.
     ------------------------------------------------------------------

     ================================================================== */

#include <stdarg.h>
#include <stdint.h>
#include <stddef.h>
/*
*  User edit section
*  Edit section below if uart instance used for standard output
*/

#ifdef LSCC_STDIO_UART_APB

#include "./../uart/uart.h"

#endif

extern int printf(const char *format, ...);
extern int putchar(int c);

#ifdef LSCC_STDIO_UART_APB
/*
*  uart instance data for the uart instance used for standard output
*/
//struct uart_instance *g_stdio_uart = NULL;
extern struct uart_instance uart_core_uart;
#endif

int __attribute__((weak)) putchar(int c)
{
#ifdef LSCC_STDIO_UART_APB
	//Initialize the uart driver if it is the first time this function is called
	uart_putc(&uart_core_uart, c);
#endif
	return 0;
}

static void printf_c(int c)
{
	putchar(c);
}

static void printf_s(char *p)
{
	while (*p)
		putchar(*(p++));
}

static void printf_d(int val)
{
	char buffer[32];
	char *p = buffer;
	if (val < 0) {
		printf_c('-');
		val = -val;
	}
	while (val || p == buffer) {
		*(p++) = '0' + val % 10;
		val = val / 10;
	}
	while (p != buffer)
		printf_c(*(--p));
}

static void printf_x(unsigned int val)
{
	char buffer[32];
	char *p = buffer;

	while (val || p == buffer) {
		if ((val % 16) > 9) {
			*(p++) = 'a' + val % 16 - 10;
		} else {
			*(p++) = '0' + val % 16;
		}
		val = val / 16;
	}
	while (p != buffer)
		printf_c(*(--p));
}

int __attribute__((weak)) printf(const char *format, ...)
{
	int i;
	va_list ap;		// @suppress("Type cannot be resolved")

	va_start(ap, format);

	for (i = 0; format[i]; i++)
		if (format[i] == '%') {
			while (format[++i]) {
				if (format[i] == 'c') {
					printf_c(va_arg(ap, int));
					break;
				}
				if (format[i] == 's') {
					printf_s(va_arg(ap, char *));
					break;
				}
				if (format[i] == 'd') {
					printf_d(va_arg(ap, int));
					break;
				}
				if (format[i] == 'x') {
					printf_x(va_arg(ap, int));
					break;
				}
			}
		} else
			printf_c(format[i]);

	va_end(ap);

	return 0;
}

int __attribute__((weak)) puts(const char *s)
{
	while (*s) {
		putchar(*s);
		s++;
	}
	putchar('\n');
	return 0;
}
