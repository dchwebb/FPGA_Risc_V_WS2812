// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2019 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : lscc_ahbl_slave_dummy.v
// Title                 :
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial release.
// =============================================================================

`ifndef LSCC_AHBL_SLAVE_DUMMY
`define LSCC_AHBL_SLAVE_DUMMY

`include "lscc_dummy_model_lfsr.v"

module lscc_ahbl_slave_dummy #(
parameter                   DATA_WIDTH = 32,
parameter                   ADDR_WIDTH = 32) 
(
// Clock and Reset
input                       ahbl_hclk_i       ,
input                       ahbl_hresetn_i    ,
// AHB-Lite I/F
input                       ahbl_hsel_i       ,
input                       ahbl_hready_i     ,
input [ADDR_WIDTH-1:0]      ahbl_haddr_i      ,
input [2:0]                 ahbl_hburst_i     ,
input [2:0]                 ahbl_hsize_i      ,
input                       ahbl_hmastlock_i  ,
input [3:0]                 ahbl_hprot_i      ,
input [1:0]                 ahbl_htrans_i     ,
input [DATA_WIDTH-1:0]      ahbl_hwdata_i     ,
input                       ahbl_hwrite_i     ,
output reg                  ahbl_hreadyout_o  ,
output reg                  ahbl_hresp_o      ,
output reg [DATA_WIDTH-1:0] ahbl_hrdata_o     ,

input                       ahbl_slv_dummy_in ,
output reg                  ahbl_slv_dummy_out
);

localparam [ADDR_WIDTH-1:0] ADDR_POLY  = {1'b1,{(ADDR_WIDTH/2-1){1'b0}},1'b1,{(ADDR_WIDTH/2-4){1'b0}},3'h4};
localparam [ADDR_WIDTH-1:0] ADDR_INIT  = {{(ADDR_WIDTH-3){1'b0}},3'h4};

localparam                  CTRL_WIDTH = 11;
localparam [CTRL_WIDTH-1:0] CTRL_POLY  = 11'h480;
localparam [CTRL_WIDTH-1:0] CTRL_INIT  = 11'h001;

reg                   dummy_in_r;
reg  [DATA_WIDTH-1:0] data_r;
reg                   hwite_r;
reg                   hresp_r;
reg                   active_tx_r;
reg                   ahbl_req_r;


wire                  addr_gen_en_w;
wire                  addr_lfsr_out_w;
wire                  ctrl_lfsr_out_w;
wire                  ahbl_req_w;
wire                  ahbl_ready_w;
wire                  hresp_assert_cond_w;
wire                  hresp_to_asrt_w;

assign ahbl_req_w       = ahbl_hsel_i & ahbl_htrans_i[1];
assign addr_gen_en_w    = dummy_in_r & ahbl_req_w;
assign ahbl_ready_w     = ahbl_hreadyout_o & ahbl_hready_i;
assign hresp_to_asrt_w  = (addr_lfsr_out_w ^ dummy_in_r) & ahbl_hrdata_o[DATA_WIDTH-1]; // condition for HRESP assertion



  always @(posedge ahbl_hclk_i or negedge ahbl_hresetn_i) begin
    if (~ahbl_hresetn_i) begin
      dummy_in_r         <= 1'b0;
      ahbl_hreadyout_o   <= 1'b1;
      hwite_r            <= 1'b1;
      active_tx_r        <= 1'b0;
      ahbl_hresp_o       <= 1'b0;
      hresp_r            <= 1'b0;
      ahbl_slv_dummy_out <= 1'b0;
      data_r             <= {DATA_WIDTH{1'b0}};
      ahbl_hrdata_o      <= {DATA_WIDTH{1'b0}};
    end
    else begin
      dummy_in_r         <= ahbl_slv_dummy_in;
      // HREADYOUT logic
      if (ahbl_req_w && ahbl_ready_w) begin
        active_tx_r      <= 1'b1;
        hwite_r          <= ahbl_hwrite_i;
        if (~ahbl_hwrite_i && hresp_to_asrt_w) 
          ahbl_hreadyout_o <= 1'b0;
        else
          ahbl_hreadyout_o <= (~hwite_r & active_tx_r) ? 1'b0 : // Negates when outstanding read
                              ahbl_hwrite_i;                    // Negates when current tx is read
      end
      else if (active_tx_r && ~ahbl_req_w && ahbl_hreadyout_o) begin
        active_tx_r      <= 1'b0;
        ahbl_hreadyout_o <= 1'b1;
      end 
      else if (ahbl_req_r)
        ahbl_hreadyout_o <= 1'b1;            // There is 1 cycle delay for current read and outstanding read
      ahbl_req_r         <= ahbl_req_w && ahbl_ready_w;
      // HRESP logic
      if (ahbl_req_w && ahbl_ready_w && ~ahbl_hwrite_i && hresp_to_asrt_w)
        ahbl_hresp_o     <= 1'b1;
      else if (hresp_r && ahbl_hresp_o)
        ahbl_hresp_o     <= 1'b0;
      hresp_r            <= ahbl_hresp_o;
      // HRDATA logic
      if (ahbl_req_w && ahbl_ready_w && ahbl_hwrite_i) 
        data_r           <= {data_r[DATA_WIDTH-2:0], data_r[DATA_WIDTH-1]} ^ ahbl_hwdata_i;
      else if (ahbl_req_r && ~hwite_r)
        ahbl_hrdata_o    <= data_r;
      ahbl_slv_dummy_out  <= addr_lfsr_out_w ^ ctrl_lfsr_out_w;
    end
  end

  // LFSR for address
  lscc_dummy_model_lfsr #(
      .LFSR_WIDTH (ADDR_WIDTH),
      .POLYNOMIAL (ADDR_POLY ),
      .LFSR_INIT  (ADDR_INIT ),
      .O_PARALLEL (0         ))
    addr_gen (
      .clk_i      (ahbl_hclk_i    ), 
      .rst_i      (~ahbl_hresetn_i), 
      .add_i      (addr_gen_en_w  ), 
      .enb_i      (dummy_in_r     ), 
      .din_i      (ahbl_haddr_i   ),
      .dout_o     (addr_lfsr_out_w));

  // LFSR for control
  lscc_dummy_model_lfsr #(
      .LFSR_WIDTH (CTRL_WIDTH),
      .POLYNOMIAL (CTRL_POLY ),
      .LFSR_INIT  (CTRL_INIT ),
      .O_PARALLEL (0         ))
    ctrl_gen (
      .clk_i      (ahbl_hclk_i    ), 
      .rst_i      (~ahbl_hresetn_i), 
      .add_i      (addr_gen_en_w  ), 
      .enb_i      (dummy_in_r     ), 
      .din_i      ({ahbl_hburst_i,ahbl_hsize_i,ahbl_hmastlock_i,ahbl_hprot_i}),
      .dout_o     (ctrl_lfsr_out_w));      
endmodule
`endif

