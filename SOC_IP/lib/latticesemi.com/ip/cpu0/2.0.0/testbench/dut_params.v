localparam SIMULATION = 0;
localparam DEBUG_ENABLE = 1;
localparam ICACHE_ENABLE = 0;
localparam DCACHE_ENABLE = 0;
localparam CACHE_ENABLE = 0;
localparam ICACHE_RANGE_LOW = 32'hFFFFFFFFF;
localparam ICACHE_RANGE_HIGH = 32'h00000000;
localparam DCACHE_RANGE_LOW = 32'hFFFFFFFFF;
localparam DCACHE_RANGE_HIGH = 32'h00000000;
localparam C_EXT = 1;
localparam PIC_ENABLE = 1;
localparam TIMER_ENABLE = 1;
localparam PICTIMER_START_ADDR = 32'hFFFF0000;
localparam IRQ_NUM = 3;
localparam DEVICE = "MachXO3LF";
localparam JTAG_CHANNEL = 14;
`define MachXO3LF
`define xo3c00f
`define LCMXO3LF-6900C
