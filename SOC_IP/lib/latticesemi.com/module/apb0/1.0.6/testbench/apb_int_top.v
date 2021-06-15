// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2019 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------
//
//   Permission:

//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:

//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.

// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591


//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)

//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com

// -----------------------------------------------------------------------------
//
//
// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : apb_int_top.v
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

`ifndef APB_INT_TOP
`define APB_INT_TOP

`timescale 1 ns / 1 ps

`include "lscc_apb_master_dummy.v"
`include "lscc_apb_slave_dummy.v"

module apb_int_top (
input         apb_pclk_i        ,
input         apb_presetn_i     ,

input  [0:0] apb_mstr_dummy_in ,
output [0:0] apb_mstr_dummy_out,
input  [2:0] apb_slv_dummy_in  ,
output [2:0] apb_slv_dummy_out
);

`include "dut_params.v"

// Instantiating Dummy Masters
  wire                    apb_s00_psel_slv_i   ;
  wire [M_ADDR_WIDTH-1:0] apb_s00_paddr_slv_i  ;
  wire                    apb_s00_pwrite_slv_i ;
  wire [DATA_WIDTH-1:0]   apb_s00_pwdata_slv_i ;
  wire                    apb_s00_penable_slv_i;
  wire                    apb_s00_pready_slv_o ;
  wire                    apb_s00_pslverr_slv_o;
  wire [DATA_WIDTH-1:0]   apb_s00_prdata_slv_o ;

  wire                    apb_m00_psel_mstr_o   ;
  wire [M_ADDR_WIDTH-1:0] apb_m00_paddr_mstr_o  ;
  wire                    apb_m00_pwrite_mstr_o ;
  wire [DATA_WIDTH-1:0]   apb_m00_pwdata_mstr_o ;
  wire                    apb_m00_penable_mstr_o;
  wire                    apb_m00_pready_mstr_i ;
  wire                    apb_m00_pslverr_mstr_i;
  wire [DATA_WIDTH-1:0]   apb_m00_prdata_mstr_i ;

  wire                    apb_m01_psel_mstr_o   ;
  wire [M_ADDR_WIDTH-1:0] apb_m01_paddr_mstr_o  ;
  wire                    apb_m01_pwrite_mstr_o ;
  wire [DATA_WIDTH-1:0]   apb_m01_pwdata_mstr_o ;
  wire                    apb_m01_penable_mstr_o;
  wire                    apb_m01_pready_mstr_i ;
  wire                    apb_m01_pslverr_mstr_i;
  wire [DATA_WIDTH-1:0]   apb_m01_prdata_mstr_i ;

  wire                    apb_m02_psel_mstr_o   ;
  wire [M_ADDR_WIDTH-1:0] apb_m02_paddr_mstr_o  ;
  wire                    apb_m02_pwrite_mstr_o ;
  wire [DATA_WIDTH-1:0]   apb_m02_pwdata_mstr_o ;
  wire                    apb_m02_penable_mstr_o;
  wire                    apb_m02_pready_mstr_i ;
  wire                    apb_m02_pslverr_mstr_i;
  wire [DATA_WIDTH-1:0]   apb_m02_prdata_mstr_i ;

  lscc_apb_master_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  apb_mst_00 (
    .apb_pclk_i        (apb_pclk_i             ),
    .apb_presetn_i     (apb_presetn_i          ),
    .apb_psel_o        (apb_s00_psel_slv_i   ),
    .apb_paddr_o       (apb_s00_paddr_slv_i  ),
    .apb_pwdata_o      (apb_s00_pwdata_slv_i ),
    .apb_pwrite_o      (apb_s00_pwrite_slv_i ),
    .apb_penable_o     (apb_s00_penable_slv_i),
    .apb_pready_i      (apb_s00_pready_slv_o ),
    .apb_pslverr_i     (apb_s00_pslverr_slv_o),
    .apb_prdata_i      (apb_s00_prdata_slv_o ),
    .apb_mstr_dummy_in (apb_mstr_dummy_in[0]  ),
    .apb_mstr_dummy_out(apb_mstr_dummy_out[0] ));


// Instantiating Dummy Slaves
  lscc_apb_slave_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  apb_slv_00 (
    .apb_pclk_i       (apb_pclk_i              ),
    .apb_presetn_i    (apb_presetn_i           ),
    .apb_psel_i       (apb_m00_psel_mstr_o   ),
    .apb_paddr_i      (apb_m00_paddr_mstr_o  ),
    .apb_pwdata_i     (apb_m00_pwdata_mstr_o ),
    .apb_pwrite_i     (apb_m00_pwrite_mstr_o ),
    .apb_penable_i    (apb_m00_penable_mstr_o),
    .apb_pready_o     (apb_m00_pready_mstr_i ),
    .apb_pslverr_o    (apb_m00_pslverr_mstr_i),
    .apb_prdata_o     (apb_m00_prdata_mstr_i ),
    .apb_slv_dummy_in (apb_slv_dummy_in[0]    ),
    .apb_slv_dummy_out(apb_slv_dummy_out[0]   ));

  lscc_apb_slave_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  apb_slv_01 (
    .apb_pclk_i       (apb_pclk_i              ),
    .apb_presetn_i    (apb_presetn_i           ),
    .apb_psel_i       (apb_m01_psel_mstr_o   ),
    .apb_paddr_i      (apb_m01_paddr_mstr_o  ),
    .apb_pwdata_i     (apb_m01_pwdata_mstr_o ),
    .apb_pwrite_i     (apb_m01_pwrite_mstr_o ),
    .apb_penable_i    (apb_m01_penable_mstr_o),
    .apb_pready_o     (apb_m01_pready_mstr_i ),
    .apb_pslverr_o    (apb_m01_pslverr_mstr_i),
    .apb_prdata_o     (apb_m01_prdata_mstr_i ),
    .apb_slv_dummy_in (apb_slv_dummy_in[1]    ),
    .apb_slv_dummy_out(apb_slv_dummy_out[1]   ));

  lscc_apb_slave_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  apb_slv_02 (
    .apb_pclk_i       (apb_pclk_i              ),
    .apb_presetn_i    (apb_presetn_i           ),
    .apb_psel_i       (apb_m02_psel_mstr_o   ),
    .apb_paddr_i      (apb_m02_paddr_mstr_o  ),
    .apb_pwdata_i     (apb_m02_pwdata_mstr_o ),
    .apb_pwrite_i     (apb_m02_pwrite_mstr_o ),
    .apb_penable_i    (apb_m02_penable_mstr_o),
    .apb_pready_o     (apb_m02_pready_mstr_i ),
    .apb_pslverr_o    (apb_m02_pslverr_mstr_i),
    .apb_prdata_o     (apb_m02_prdata_mstr_i ),
    .apb_slv_dummy_in (apb_slv_dummy_in[2]    ),
    .apb_slv_dummy_out(apb_slv_dummy_out[2]   ));


`include "dut_inst.v"

endmodule
`endif
