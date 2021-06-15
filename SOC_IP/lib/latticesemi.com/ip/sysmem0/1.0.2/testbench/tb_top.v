`ifndef TB_TOP
`define TB_TOP

`timescale 1 ns / 1 ps

`include "lscc_ahblmem_master.v"
`include "lscc_data_checker.v"
`include "lscc_fifo_master.v"

module tb_top();
	
// ----------------------------
// Local Parameter
// ----------------------------
`include "dut_params.v"
localparam CNTR_OVERRIDE  = 0;
localparam TARGET_COUNTER = 50; // cycles

// ----------------------------
// Common Signals
// ----------------------------

reg                   ahbl_hclk_i;
reg                   ahbl_hresetn_i;
// ----------------------------
// AHB-Lite Slave Interface 0
// ----------------------------
wire                  ahbl_s0_hsel_i;
wire                  ahbl_s0_hready_i;
wire [31:0]           ahbl_s0_haddr_i;
wire [2:0]            ahbl_s0_hburst_i;
wire [2:0]            ahbl_s0_hsize_i;
wire                  ahbl_s0_hmastlock_i;
wire [3:0]            ahbl_s0_hprot_i;
wire [1:0]            ahbl_s0_htrans_i;
wire                  ahbl_s0_hwrite_i;
wire [DATA_WIDTH-1:0] ahbl_s0_hwdata_i;

wire                  ahbl_s0_hreadyout_o;
wire                  ahbl_s0_hresp_o;
wire [DATA_WIDTH-1:0] ahbl_s0_hrdata_o;

// ----------------------------
// AHB-Lite Slave Interface 1
// ----------------------------
wire                   ahbl_s1_hsel_i;
wire                   ahbl_s1_hready_i;
wire [31:0]            ahbl_s1_haddr_i;
wire [2:0]             ahbl_s1_hburst_i;
wire [2:0]             ahbl_s1_hsize_i;
wire                   ahbl_s1_hmastlock_i;
wire [3:0]             ahbl_s1_hprot_i;
wire [1:0]             ahbl_s1_htrans_i;
wire                   ahbl_s1_hwrite_i;
wire [DATA_WIDTH-1:0]  ahbl_s1_hwdata_i;

wire                   ahbl_s1_hreadyout_o;
wire                   ahbl_s1_hresp_o;
wire [DATA_WIDTH-1:0]  ahbl_s1_hrdata_o;

// ----------------------------
// FIFO Interface
// ----------------------------
reg                    fifo_clk_i;

wire                   fifo_wr_en_i;
wire [7:0]             fifo_wr_data_i;
wire                   fifo_interface_en_i;
wire                   fifo_address_rst_i;
wire                   fifo_full_o;

// ----------------------------
// Control Signals
// ----------------------------

wire                   ahbl_s0_errgen_o;
wire                   ahbl_s1_errgen_o;
wire [DATA_WIDTH-1:0]  s0_exp_data_o;
wire [DATA_WIDTH-1:0]  s1_exp_data_o;

wire [7:0]             mstr_state_o;
wire                   done_o;

// ----------------------------
// Clock Register
// ----------------------------

reg [31:0] clock_prot_r = {32{1'b0}};

// ----------------------------
// System Counter 
// ----------------------------

wire [31:0] safe_count_o;

// ----------------------------
// DUT instance
// ----------------------------

`include "dut_inst.v"
GSR GSR_INST ( .GSR_N(1'b1), .CLK(1'b0));

// ----------------------------
// Master Module
// ----------------------------

lscc_ahblmem_master #(
    .ADDR_DEPTH             (ADDR_DEPTH),
    .DATA_WIDTH             (DATA_WIDTH),
    .MEMORY_TYPE            (MEMORY_TYPE),
    .PORT_COUNT             (PORT_COUNT),
    .ECC_ENABLE             (ECC_ENABLE),
    .REGMODE_S0             (REGMODE_S0),
    .REGMODE_S1             (REGMODE_S1),
    .RESET_MODE_S0          (RESET_MODE_S0),
    .RESET_MODE_S1          (RESET_MODE_S1),
    .BYTE_ENABLE_S0         (BYTE_ENABLE_S0),
    .BYTE_ENABLE_S1         (BYTE_ENABLE_S1),
    .S0_START_ADDR          (S0_START_ADDR),
    .S1_START_ADDR          (S1_START_ADDR),
    .S0_END_ADDR            (S0_END_ADDR),
    .S1_END_ADDR            (S1_END_ADDR),
    .ACCESS_TYPE_S0         (ACCESS_TYPE_S0),
    .ACCESS_TYPE_S1         (ACCESS_TYPE_S1),
    .UNALIGNED_ACCESS_EN_S0 (UNALIGNED_ACCESS_EN_S0),
    .UNALIGNED_ACCESS_EN_S1 (UNALIGNED_ACCESS_EN_S1),
    .SHIFT_DIRECTION_S0     (SHIFT_DIRECTION_S0),
    .SHIFT_DIRECTION_S1     (SHIFT_DIRECTION_S1),
    .INIT_FILE              (INIT_FILE),
    .INIT_FILE_FORMAT       (INIT_FILE_FORMAT),
    .TARGET_COUNTER         (TARGET_COUNTER),
    .CNTR_OVERRIDE          (CNTR_OVERRIDE)
) u_mstr0 (
    .ahbl_hclk_i            (ahbl_hclk_i),
    .ahbl_hresetn_i         (ahbl_hresetn_i),
    .fifo_hold_i            (fifo_interface_en_i),

// ----------------------------
// AHB-Lite Master Interface 0
// ----------------------------
    .ahbl_s0_hreadyout_i    (ahbl_s0_hreadyout_o),
    .ahbl_s0_hresp_i        (ahbl_s0_hresp_o),
    .ahbl_s0_hrdata_i       (ahbl_s0_hrdata_o),

    .ahbl_s0_hsel_o         (ahbl_s0_hsel_i),
    .ahbl_s0_hready_o       (ahbl_s0_hready_i),
    .ahbl_s0_haddr_o        (ahbl_s0_haddr_i),
    .ahbl_s0_hburst_o       (ahbl_s0_hburst_i),
    .ahbl_s0_hsize_o        (ahbl_s0_hsize_i),
    .ahbl_s0_hmastlock_o    (ahbl_s0_hmastlock_i),
    .ahbl_s0_hprot_o        (ahbl_s0_hprot_i),
    .ahbl_s0_htrans_o       (ahbl_s0_htrans_i),
    .ahbl_s0_hwrite_o       (ahbl_s0_hwrite_i),
    .ahbl_s0_hwdata_o       (ahbl_s0_hwdata_i),

// ----------------------------
// AHB-Lite Master Interface 1
// ----------------------------
    .ahbl_s1_hreadyout_i   (ahbl_s1_hreadyout_o),
    .ahbl_s1_hresp_i       (ahbl_s1_hresp_o),
    .ahbl_s1_hrdata_i      (ahbl_s1_hrdata_o),
						   
    .ahbl_s1_hsel_o        (ahbl_s1_hsel_i),
    .ahbl_s1_hready_o      (ahbl_s1_hready_i),
    .ahbl_s1_haddr_o       (ahbl_s1_haddr_i),
    .ahbl_s1_hburst_o      (ahbl_s1_hburst_i),
    .ahbl_s1_hsize_o       (ahbl_s1_hsize_i),
    .ahbl_s1_hmastlock_o   (ahbl_s1_hmastlock_i),
    .ahbl_s1_hprot_o       (ahbl_s1_hprot_i),
    .ahbl_s1_htrans_o      (ahbl_s1_htrans_i),
    .ahbl_s1_hwrite_o      (ahbl_s1_hwrite_i),
    .ahbl_s1_hwdata_o      (ahbl_s1_hwdata_i),

// ----------------------------
// Master State
// ----------------------------
    .mstr_state_o          (mstr_state_o),
    .done_o                (done_o),
    .safe_count_o          (safe_count_o)
);

lscc_data_checker # (
    .ADDR_DEPTH             (ADDR_DEPTH),
    .DATA_WIDTH             (DATA_WIDTH),
    .PORT_COUNT             (PORT_COUNT),
    .REGMODE_S0             (REGMODE_S0),
    .REGMODE_S1             (REGMODE_S1),
    .BYTE_ENABLE_S0         (BYTE_ENABLE_S0),
    .BYTE_ENABLE_S1         (BYTE_ENABLE_S1),
    .S0_START_ADDR          (S0_START_ADDR),
    .S1_START_ADDR          (S1_START_ADDR),
    .S0_END_ADDR            (S0_END_ADDR),
    .S1_END_ADDR            (S1_END_ADDR),
    .ACCESS_TYPE_S0         (ACCESS_TYPE_S0),
    .ACCESS_TYPE_S1         (ACCESS_TYPE_S1),
    .UNALIGNED_ACCESS_EN_S0 (UNALIGNED_ACCESS_EN_S0),
    .UNALIGNED_ACCESS_EN_S1 (UNALIGNED_ACCESS_EN_S1),
    .SHIFT_DIRECTION_S0     (SHIFT_DIRECTION_S0),
    .SHIFT_DIRECTION_S1     (SHIFT_DIRECTION_S1),
    .INIT_FILE              (INIT_FILE),
    .INIT_FILE_FORMAT       (INIT_FILE_FORMAT),
    .FIFO_STREAMER_EN       (FIFO_STREAMER_EN),
    .FIFO_START_ADDR        (FIFO_START_ADDR)
) data_chk0 (
    .ahbl_hclk_i            (ahbl_hclk_i),
    .ahbl_hresetn_i         (ahbl_hresetn_i),
				            
    .ahbl_s0_hsel_i         (ahbl_s0_hsel_i),
    .ahbl_s0_hready_i       (ahbl_s0_hready_i),
    .ahbl_s0_haddr_i        (ahbl_s0_haddr_i),
    .ahbl_s0_hburst_i       (ahbl_s0_hburst_i),
    .ahbl_s0_hsize_i        (ahbl_s0_hsize_i),
    .ahbl_s0_hmastlock_i    (ahbl_s0_hmastlock_i),
    .ahbl_s0_hprot_i        (ahbl_s0_hprot_i),
    .ahbl_s0_htrans_i       (ahbl_s0_htrans_i),
    .ahbl_s0_hwrite_i       (ahbl_s0_hwrite_i),
    .ahbl_s0_hwdata_i       (ahbl_s0_hwdata_i),

    .ahbl_s0_hrdata_o       (ahbl_s0_hrdata_o),
    .ahbl_s0_hreadyout_o    (ahbl_s0_hreadyout_o),

    .ahbl_s1_hsel_i         (ahbl_s1_hsel_i),
    .ahbl_s1_hready_i       (ahbl_s1_hready_i),
    .ahbl_s1_haddr_i        (ahbl_s1_haddr_i),
    .ahbl_s1_hburst_i       (ahbl_s1_hburst_i),
    .ahbl_s1_hsize_i        (ahbl_s1_hsize_i),
    .ahbl_s1_hmastlock_i    (ahbl_s1_hmastlock_i),
    .ahbl_s1_hprot_i        (ahbl_s1_hprot_i),
    .ahbl_s1_htrans_i       (ahbl_s1_htrans_i),
    .ahbl_s1_hwrite_i       (ahbl_s1_hwrite_i),
    .ahbl_s1_hwdata_i       (ahbl_s1_hwdata_i),

    .ahbl_s1_hrdata_o       (ahbl_s1_hrdata_o),
    .ahbl_s1_hreadyout_o    (ahbl_s1_hreadyout_o),

    .fifo_clk_i             (fifo_clk_i),
    .fifo_wr_en_i           (fifo_wr_en_i),
    .fifo_wr_data_i         (fifo_wr_data_i),
    .fifo_interface_en_i    (fifo_interface_en_i),
    .fifo_address_rst_i     (fifo_address_rst_i),
							
    .fifo_full_i            (fifo_full_o),

    .ahbl_s0_errgen_o       (ahbl_s0_errgen_o),
    .ahbl_s1_errgen_o       (ahbl_s1_errgen_o),
    .s0_exp_data_o          (s0_exp_data_o),
    .s1_exp_data_o          (s1_exp_data_o)
);

// ----------------------------
// Error Check
// ----------------------------

reg s0_data_chk_r = 1'b0;
reg s1_data_chk_r = 1'b0;

always @ (posedge ahbl_hclk_i) begin
    s0_data_chk_r <= ahbl_s0_errgen_o | s0_data_chk_r;
    s1_data_chk_r <= ahbl_s1_errgen_o | s1_data_chk_r;
end

if(PORT_COUNT == 2) begin
    always @ (posedge ahbl_hclk_i) begin
        if(ahbl_s0_hresp_o == 1'b1 || ahbl_s1_hresp_o == 1'b1) begin
            if(ahbl_s0_hresp_o == 1'b1) begin
                $display("-----------------------------------------------------");
                $display("!!!!!!!!!!! PORT S0 AHBL PROTOCOL FAILED !!!!!!!!!!!!");
                $display("-----------------------------------------------------");         
            end 
            if(ahbl_s1_hresp_o == 1'b1) begin
                $display("-----------------------------------------------------");
                $display("!!!!!!!!!!! PORT S1 AHBL PROTOCOL FAILED !!!!!!!!!!!!");
                $display("-----------------------------------------------------");        
            end
            $finish;
        end
    end
end
else begin
    always @ (posedge ahbl_hclk_i) begin
        if(ahbl_s0_hresp_o == 1'b1) begin
            $display("-----------------------------------------------------");
            $display("!!!!!!!!!!! PORT S0 AHBL PROTOCOL FAILED !!!!!!!!!!!!");
            $display("-----------------------------------------------------");
            $finish;
        end 
    end
end

always @ (posedge ahbl_hclk_i) begin
    if(done_o == 1'b1) begin
        if(ACCESS_TYPE_S0 == "R/O" || ACCESS_TYPE_S0 == "R/W") begin
            if(s0_data_chk_r == 1'b1) begin
                $display("-----------------------------------------------------");
                $display("!!!!!!!!!!!!! PORT S0 SIMULATION FAILED !!!!!!!!!!!!!");
                $display("-----------------------------------------------------");
            end
            else begin
                $display("-----------------------------------------------------");
                $display("------------- PORT S0 SIMULATION PASSED -------------");
                $display("-----------------------------------------------------");
            end
        end
        if(PORT_COUNT == 2 && (ACCESS_TYPE_S1 == "R/O" || ACCESS_TYPE_S1 == "R/W")) begin 
            if(s1_data_chk_r == 1'b1) begin
                $display("-----------------------------------------------------");
                $display("!!!!!!!!!!!!! PORT S1 SIMULATION FAILED !!!!!!!!!!!!!");
                $display("-----------------------------------------------------");
            end
            else begin
                $display("-----------------------------------------------------");
                $display("------------- PORT S1 SIMULATION PASSED -------------");
                $display("-----------------------------------------------------");
            end
        end
        $finish;
    end
    else begin
        if(ACCESS_TYPE_S0 == "R/O" || ACCESS_TYPE_S0 == "R/W") begin
            if(ahbl_s0_errgen_o == 1'b1) begin
                $display("ERROR on port S0 after %h cycles, during %h state", clock_prot_r, mstr_state_o);
            end
        end

        if(PORT_COUNT == 2 && (ACCESS_TYPE_S1 == "R/O" || ACCESS_TYPE_S1 == "R/W")) begin 
            if(ahbl_s1_errgen_o == 1'b1) begin
                $display("ERROR on port S1 after %h cycles, during %h state", clock_prot_r, mstr_state_o);
            end
        end
    end
end

lscc_fifo_master # (
    .FIFO_EN (FIFO_STREAMER_EN)
) fifo_master (
    .clk_i               (fifo_clk_i),
    .rstn_i              (ahbl_hresetn_i),

    .fifo_wr_en_o        (fifo_wr_en_i),
    .fifo_wr_data_o      (fifo_wr_data_i),
    .fifo_interface_en_o (fifo_interface_en_i), 
    .fifo_address_rst_o  (fifo_address_rst_i),

    .fifo_full_o         (fifo_full_o)
);

// ----------------------------
// Reset and Clock generation
// ----------------------------
initial begin
    ahbl_hclk_i = 1'b0;
    forever #10 ahbl_hclk_i = ~ahbl_hclk_i;
end

initial begin
    ahbl_hresetn_i = 1'b0;
    #20;
    @(posedge ahbl_hclk_i);
    ahbl_hresetn_i = 1'b1;
end

if(FIFO_CLK_BYPASS) begin
    always @ (*) begin
        fifo_clk_i = ahbl_hclk_i;
    end
end
else begin
    initial begin
        fifo_clk_i = 1'b0;
        #5;
        forever #15 fifo_clk_i = ~fifo_clk_i;
    end
end

// ----------------------------
// Simulation runaway protection
// ----------------------------
generate
    always @ (posedge ahbl_hclk_i) begin
        if(ahbl_hresetn_i == 1'b1) begin
            if(clock_prot_r < safe_count_o) begin
                clock_prot_r <= clock_prot_r + 1'b1;
            end
            else begin
                $finish;
            end
        end
    end
endgenerate

endmodule
`endif
