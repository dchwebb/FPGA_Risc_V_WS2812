/*  ==================================================================
    >>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
    ------------------------------------------------------------------
    Copyright (c) 2006-2018 by Lattice Semiconductor Corporation
    ALL RIGHTS RESERVED
    ------------------------------------------------------------------
 
    IMPORTANT: THIS FILE IS AUTO-GENERATED BY LATTICE RADIANT Software.
 
    Permission:
 
      Lattice grants permission to use this code pursuant to the
      terms of the Lattice Corporation Open Source License Agreement.
 
    Disclaimer:
 
      Lattice provides no warranty regarding the use or functionality
      of this code. It is the user's responsibility to verify the
      user Software design for consistency and functionality through
      the use of formal Software validation methods.
 
    ------------------------------------------------------------------
 
    Lattice Semiconductor Corporation
    111 SW Fifth Avenue, Suite 700
    Portland, OR 97204
    U.S.A
    Email: techsupport@latticesemi.com
    Web: http://www.latticesemi.com/Home/Support/SubmitSupportTicket.aspx
    ================================================================== */
 
#ifndef SYS_PLATFORM_H
#define SYS_PLATFORM_H

/* general info */
#define DEVICE_FAMILY "MachXO3LF"

/* ip instance base address */

#define CPU0_INST_NAME "cpu0_inst"
#define CPU0_INST_BASE_ADDR 0xffff0000

#define WS2812_INST_NAME "WS2812_inst"
#define WS2812_INST_BASE_ADDR 0x8800

#define GPIO0_INST_NAME "gpio0_inst"
#define GPIO0_INST_BASE_ADDR 0x8000

#define SYSMEM0_INST_AHBL_SLV0_MODEL_MEM_MAP_NAME "sysmem0_inst_ahbl_slv0_model_mem_map"
#define SYSMEM0_INST_AHBL_SLV0_MODEL_MEM_MAP_BASE_ADDR 0x0

#define SYSMEM0_INST_AHBL_SLV1_MODEL_MEM_MAP_NAME "sysmem0_inst_ahbl_slv1_model_mem_map"
#define SYSMEM0_INST_AHBL_SLV1_MODEL_MEM_MAP_BASE_ADDR 0x0

#define UART0_INST_NAME "uart0_inst"
#define UART0_INST_BASE_ADDR 0x8400


/* cpu0_inst parameters */
#define CPU0_INST_CACHE_ENABLE False
#define CPU0_INST_C_EXT True
#define CPU0_INST_DCACHE_ENABLE False
#define CPU0_INST_DCACHE_RANGE_HIGH 0x00000000
#define CPU0_INST_DCACHE_RANGE_LOW 0xFFFFFFFFF
#define CPU0_INST_DEBUG_ENABLE True
#define CPU0_INST_DEVICE MachXO3LF
#define CPU0_INST_ICACHE_ENABLE False
#define CPU0_INST_ICACHE_RANGE_HIGH 0x00000000
#define CPU0_INST_ICACHE_RANGE_LOW 0xFFFFFFFFF
#define CPU0_INST_IRQ_NUM 3
#define CPU0_INST_JTAG_CHANNEL 14
#define CPU0_INST_PICTIMER_START_ADDR 0xFFFF0000
#define CPU0_INST_PIC_ENABLE True
#define CPU0_INST_SIMULATION False
#define CPU0_INST_TIMER_ENABLE True

/* WS2812_inst parameters */
#define WS2812_INST_FAMILY MachXO3LF
#define WS2812_INST_LED_COUNT 3

/* gpio0_inst parameters */
#define GPIO0_INST_GPIO_DIRS 0x000000FF
#define GPIO0_INST_LINES_NUM 8

/* uart0_inst parameters */
#define UART0_INST_BAUD_RATE 115200
#define UART0_INST_DATA_WIDTH 8
#define UART0_INST_STOP_BITS 1
#define UART0_INST_SYS_CLK 38.0

/* interrupt */

#define UART0_INST_IRQ 0
#define GPIO0_INST_IRQ 1
#define WS2812_INST_IRQ 2

#endif
