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
// File                  : lscc_apb_master_dummy.v
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

`ifndef LSCC_APB_MASTER_DUMMY
`define LSCC_APB_MASTER_DUMMY

`include "lscc_dummy_model_lfsr.v"

module lscc_apb_master_dummy 
#(
parameter               DATA_WIDTH = 32,
parameter               ADDR_WIDTH = 32
) 
(
// Clock and Reset
input                   apb_pclk_i   ,
input                   apb_presetn_i,
// AHB-Lite I/F
output reg              apb_psel_o   ,
output [ADDR_WIDTH-1:0] apb_paddr_o  ,
output [DATA_WIDTH-1:0] apb_pwdata_o ,
output reg              apb_pwrite_o ,
output reg              apb_penable_o,
input                   apb_pready_i ,
input                   apb_pslverr_i,
input  [DATA_WIDTH-1:0] apb_prdata_i ,

input                   apb_mstr_dummy_in ,
output reg              apb_mstr_dummy_out
);

localparam [ADDR_WIDTH-1:0] ADDR_POLY  = {1'b1,{(ADDR_WIDTH/2-1){1'b0}},1'b1,{(ADDR_WIDTH/2-4){1'b0}},3'h4};
localparam [ADDR_WIDTH-1:0] ADDR_INIT  = {{(ADDR_WIDTH-3){1'b0}},3'h4};
localparam [DATA_WIDTH-1:0] DATA_POLY  = {8'hB8,{(DATA_WIDTH-8){1'b0}}};
localparam [DATA_WIDTH-1:0] DATA_INIT  = {(DATA_WIDTH/8){8'hA5}};

localparam ST_W      = 3;
localparam ST_IDLE   = 3'b001;
localparam ST_SETUP  = 3'b010;
localparam ST_ACCESS = 3'b100;

reg   [ST_W-1:0] cs_sm         ;
reg   [ST_W-1:0] ns_sm         ;
reg              dummy_in_r    ;

wire             addr_gen_en_w    ;
wire             wdata_gen_en_w   ;
wire             rdata_gen_en_w   ;
wire             prdata_lfsr_out_w;
wire             preset_w         ;



assign addr_gen_en_w    = ns_sm == ST_SETUP;
assign wdata_gen_en_w   = addr_gen_en_w & (apb_paddr_o[ADDR_WIDTH-1] ^ apb_pwdata_o[DATA_WIDTH-1]);
assign rdata_gen_en_w   = (cs_sm == ST_ACCESS) & apb_pready_i & ~apb_pslverr_i & ~apb_pwrite_o;
assign preset_w         = ~apb_presetn_i;


  always @* begin
    ns_sm = cs_sm;
    case(cs_sm) 
      ST_IDLE   : begin
        ns_sm = dummy_in_r ? ST_SETUP : ST_IDLE;
      end
      ST_SETUP  : begin
        ns_sm = ST_ACCESS;
      end
      ST_ACCESS : begin
        if (apb_pready_i)
          ns_sm = dummy_in_r ? ST_SETUP : ST_IDLE;
        else 
          ns_sm = ST_ACCESS;
      end
      default : begin
        ns_sm = ST_IDLE;
      end
    endcase
  end



  always @(posedge apb_pclk_i or negedge apb_presetn_i) begin
    if (~apb_presetn_i) begin
      dummy_in_r         <= 1'b0;
      apb_mstr_dummy_out <= 1'b0;
      apb_psel_o         <= 1'b0;
      apb_pwrite_o       <= 1'b0;
      apb_penable_o      <= 1'b0;
      cs_sm              <= ST_IDLE;
    end
    else begin
      cs_sm              <= ns_sm;
      dummy_in_r         <= apb_mstr_dummy_in;
      case (ns_sm)
        ST_SETUP  : begin
          apb_psel_o     <= 1'b1;
          apb_penable_o  <= 1'b0;
          apb_pwrite_o   <= wdata_gen_en_w;
        end
        ST_ACCESS : begin
          apb_psel_o     <= 1'b1;
          apb_penable_o  <= 1'b1;
        end
        default : begin  // Includes ST_IDLE
          apb_psel_o     <= 1'b0;
          apb_penable_o  <= 1'b0;
        end
      endcase
      
      apb_mstr_dummy_out <= prdata_lfsr_out_w;
    end
  end

  // LFSR for address
  lscc_dummy_model_lfsr #(
      .LFSR_WIDTH (ADDR_WIDTH),
      .POLYNOMIAL (ADDR_POLY ),
      .LFSR_INIT  (ADDR_INIT ),
      .O_PARALLEL (1         ))
    addr_gen (
      .clk_i      (apb_pclk_i        ), 
      .rst_i      (preset_w          ), 
      .enb_i      (addr_gen_en_w     ), 
      .add_i      (1'b0              ),
      .din_i      ({ADDR_WIDTH{1'b0}}),
      .dout_o     (apb_paddr_o       ));

  // LFSR for write data
  lscc_dummy_model_lfsr #(
      .LFSR_WIDTH (DATA_WIDTH),
      .POLYNOMIAL (DATA_POLY ),
      .LFSR_INIT  (DATA_INIT ),
      .O_PARALLEL (1         ))
    wdata_gen (
      .clk_i      (apb_pclk_i        ), 
      .rst_i      (preset_w          ), 
      .enb_i      (wdata_gen_en_w    ), 
      .add_i      (1'b0              ),
      .din_i      ({DATA_WIDTH{1'b0}}),
      .dout_o     (apb_pwdata_o      ));

  // LFSR for read data
  lscc_dummy_model_lfsr #(
      .LFSR_WIDTH (DATA_WIDTH),
      .POLYNOMIAL (DATA_POLY ),
      .LFSR_INIT  (DATA_INIT ),
      .O_PARALLEL (0         ))
    rdata_gen (
      .clk_i      (apb_pclk_i       ), 
      .rst_i      (preset_w         ), 
      .add_i      (rdata_gen_en_w   ),
      .din_i      (apb_prdata_i     ),
      .enb_i      (rdata_gen_en_r   ), 
      .dout_o     (prdata_lfsr_out_w));
endmodule
`endif

