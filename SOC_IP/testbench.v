`timescale 1ns / 1ns

module testbench;
	reg  clk = 1'b0;
	reg  reset_n;

	wire interrupt_o;
	wire led_o;
	
	reg apb_penable;				// apb Enable
	reg apb_psel;					// apb Slave select
	reg apb_pwrite;				// apb write 1, read 0
	reg [5:0] apb_paddr;
	reg [31:0] apb_pwdata;
	wire [31:0] apb_prdata;
	wire apb_pslverr;				// apb slave error
	wire apb_pready;



	WS2812_module WS2812_inst (
		.clk_i(clk),
		.resetn_i(reset_n),
		
		.led_ctl_o(led_o),
		.int_o(interrupt_o),
		.debug_o(),
		
		.apb_penable_i(apb_penable),				// apb Enable
		.apb_psel_i(apb_psel),						// apb Slave select
		.apb_pwrite_i(apb_pwrite),				// apb write 1, read 0
		.apb_paddr_i(apb_paddr),
		.apb_pwdata_i(apb_pwdata),
		.apb_prdata_o(apb_prdata),
		.apb_pslverr_o(apb_pslverr),				// apb slave error
		.apb_pready_o(apb_pready)
	);
	
	always
		#10 clk = ~clk;
		

	// Register map
	localparam STATUS_REG = 6'h0;			// 0x0	STATUS		sending	[0]
	localparam CONTROL_REG = 6'h4;		// 0x4	CONTROL		auto_send[0]		send		[1]
	localparam COLOUR_WR_REG = 6'h8;		// 0x8	COLOUR_WR	colour	[23:0]	led_set	[31:24]
	localparam COLOUR_RD_REG = 6'hC;		// 0x12	COLOUR_RD	colour	[23:0]	led_set	[31:24]


	initial begin
		reset_n = 1'b0;
		apb_paddr = 6'h0;
		apb_pwdata = 32'h0;
		apb_psel = 1'b0;
		apb_penable = 1'b0;
		apb_pwrite = 1'b0;
		
		#1
		reset_n = 1'b1;
		#1

		write_register(CONTROL_REG, 32'b0);							// Clear auto send
		#20
		write_register(COLOUR_WR_REG, {8'h0, 24'hAABBCD});		// Send colours for first LED
		#20
		write_register(COLOUR_WR_REG, {8'h1, 24'hDDEEFE});		// Send colours for second LED
		#20
		write_register(COLOUR_WR_REG, {8'h2, 24'h112244});		// Send colours for third LED
		#20
		read_register(STATUS_REG);											// Check sending status
		#200
		write_register(CONTROL_REG, 32'h2);							// Trigger manual send (second bit in control register)
		
		#10000
		write_register(CONTROL_REG, 32'b1);							// Reset auto send
		#20
		read_register(CONTROL_REG);										// Check control register read
		
		#10000
		write_register(CONTROL_REG, 32'b0);							// Clear auto send
		#20
		read_register(CONTROL_REG);										// Check control register read

/*
		#10000
		write_register(COLOUR_RD_REG, {8'h0, 24'h0});				// Set read led to led[0]
		#200
		read_register(COLOUR_RD_REG);										// Read the colour for led[0]

		#10000
		write_register(COLOUR_RD_REG, {8'h2, 24'h0});				// Set read led to led[2]
		#200
		read_register(COLOUR_RD_REG);										// Read the colour for led[2]

		wait (interrupt_o);
		@(posedge clk)
		#20
		read_register(STATUS_REG);
		#20
		write_register(COLOUR_WR_REG, {8'h0, 24'h998877});			// Send colours for first LED
		#20

		#10000
		write_register(COLOUR_RD_REG, {8'h0, 24'h0});				// Set read led to led[0]
		#200
		read_register(COLOUR_RD_REG);										// Read the colour for led[0]
	*/

		forever
			begin
				@(posedge clk)
				reset_n = 1'b1;
			end
		
	end

// Writes data to a memory mapped register using APB
task write_register;
	input [5:0]  reg_address;
	input [31:0] reg_data;
	
	begin
		@(posedge clk)
		#1
		apb_paddr = reg_address;
		apb_pwdata = reg_data;
		apb_pwrite = 1'b1;
		apb_psel = 1'b1;
		
		// Write Access Phase
		@(posedge clk)
		#1
		apb_penable = 1'b1;
		
		// End Write Phase
		wait (apb_pready);
		@(posedge clk)
		apb_psel = 1'b0;
		apb_paddr = 6'h0;
		apb_pwdata = 32'h0;
		apb_pwrite = 1'b0;
		apb_penable = 1'b0;		
	end
endtask

task read_register;
	input [5:0]  reg_address;

	begin
		@(posedge clk)
		#1
		apb_paddr = reg_address;
		apb_pwrite = 1'b0;
		apb_psel = 1'b1;
		
		// Read Access Phase
		@(posedge clk)
		#1
		apb_penable = 1'b1;
		
		// End Read Phase
		wait (apb_pready);
		@(posedge clk)
		apb_psel = 1'b0;
		apb_paddr = 6'h0;
		apb_penable = 1'b0;
	end
endtask

endmodule