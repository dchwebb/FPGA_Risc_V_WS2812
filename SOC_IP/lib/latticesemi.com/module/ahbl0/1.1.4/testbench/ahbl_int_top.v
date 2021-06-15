// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2019 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------

//   Permission:

//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.


//   Disclaimer:

//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.

// -----------------------------------------------------------------------------

//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591


//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)

//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com

// -----------------------------------------------------------------------------

// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : ahbl_int_top.v
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

`ifndef AHBL_INT_TOP
`define AHBL_INT_TOP

`timescale 1 ns / 1 ps

`include "lscc_ahbl_master_dummy.v"
`include "lscc_ahbl_slave_dummy.v"

module ahbl_int_top (
input         ahbl_hclk_i        ,
input         ahbl_hresetn_i     ,

input  [0:0] ahbl_mstr_dummy_in ,
output [0:0] ahbl_mstr_dummy_out,
input  [1:0] ahbl_slv_dummy_in  ,
output [1:0] ahbl_slv_dummy_out
);

`include "dut_params.v"

// Instantiating Dummy Masters
  wire                    ahbl_s00_hsel_slv_i     ;
  wire                    ahbl_s00_hready_slv_i   ;
  wire [M_ADDR_WIDTH-1:0] ahbl_s00_haddr_slv_i    ;
  wire [2:0]              ahbl_s00_hburst_slv_i   ;
  wire [2:0]              ahbl_s00_hsize_slv_i    ;
  wire                    ahbl_s00_hmastlock_slv_i;
  wire [3:0]              ahbl_s00_hprot_slv_i    ;
  wire [1:0]              ahbl_s00_htrans_slv_i   ;
  wire [DATA_WIDTH-1:0]   ahbl_s00_hwdata_slv_i   ;
  wire                    ahbl_s00_hwrite_slv_i   ;
  wire                    ahbl_s00_hreadyout_slv_o;
  wire                    ahbl_s00_hresp_slv_o    ;
  wire [DATA_WIDTH-1:0]   ahbl_s00_hrdata_slv_o   ;

  wire                    ahbl_m00_hsel_mstr_o     ;
  wire                    ahbl_m00_hready_mstr_o   ;
  wire [M_ADDR_WIDTH-1:0] ahbl_m00_haddr_mstr_o    ;
  wire [2:0]              ahbl_m00_hburst_mstr_o   ;
  wire [2:0]              ahbl_m00_hsize_mstr_o    ;
  wire                    ahbl_m00_hmastlock_mstr_o;
  wire [3:0]              ahbl_m00_hprot_mstr_o    ;
  wire [1:0]              ahbl_m00_htrans_mstr_o   ;
  wire [DATA_WIDTH-1:0]   ahbl_m00_hwdata_mstr_o   ;
  wire                    ahbl_m00_hwrite_mstr_o   ;
  wire                    ahbl_m00_hready_mstr_i   ;
  wire                    ahbl_m00_hresp_mstr_i    ;
  wire [DATA_WIDTH-1:0]   ahbl_m00_hrdata_mstr_i   ;

  wire                    ahbl_m01_hsel_mstr_o     ;
  wire                    ahbl_m01_hready_mstr_o   ;
  wire [M_ADDR_WIDTH-1:0] ahbl_m01_haddr_mstr_o    ;
  wire [2:0]              ahbl_m01_hburst_mstr_o   ;
  wire [2:0]              ahbl_m01_hsize_mstr_o    ;
  wire                    ahbl_m01_hmastlock_mstr_o;
  wire [3:0]              ahbl_m01_hprot_mstr_o    ;
  wire [1:0]              ahbl_m01_htrans_mstr_o   ;
  wire [DATA_WIDTH-1:0]   ahbl_m01_hwdata_mstr_o   ;
  wire                    ahbl_m01_hwrite_mstr_o   ;
  wire                    ahbl_m01_hready_mstr_i   ;
  wire                    ahbl_m01_hresp_mstr_i    ;
  wire [DATA_WIDTH-1:0]   ahbl_m01_hrdata_mstr_i   ;

  lscc_ahbl_master_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  ahbl_mst_00 (
    .ahbl_hclk_i        (ahbl_hclk_i             ),
    .ahbl_hresetn_i     (ahbl_hresetn_i          ),
    .ahbl_hsel_o        (ahbl_s00_hsel_slv_i     ),
    .ahbl_hready_o      (ahbl_s00_hready_slv_i   ),
    .ahbl_haddr_o       (ahbl_s00_haddr_slv_i    ),
    .ahbl_hburst_o      (ahbl_s00_hburst_slv_i   ),
    .ahbl_hsize_o       (ahbl_s00_hsize_slv_i    ),
    .ahbl_hmastlock_o   (ahbl_s00_hmastlock_slv_i),
    .ahbl_hprot_o       (ahbl_s00_hprot_slv_i    ),
    .ahbl_htrans_o      (ahbl_s00_htrans_slv_i   ),
    .ahbl_hwdata_o      (ahbl_s00_hwdata_slv_i   ),
    .ahbl_hwrite_o      (ahbl_s00_hwrite_slv_i   ),
    .ahbl_hreadyout_i   (ahbl_s00_hreadyout_slv_o),
    .ahbl_hresp_i       (ahbl_s00_hresp_slv_o    ),
    .ahbl_hrdata_i      (ahbl_s00_hrdata_slv_o   ),
    .ahbl_mstr_dummy_in (ahbl_mstr_dummy_in[0]   ),
    .ahbl_mstr_dummy_out(ahbl_mstr_dummy_out[0]  ));

// Instantiating Dummy Slaves
  lscc_ahbl_slave_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  ahbl_slv_00 (
    .ahbl_hclk_i       (ahbl_hclk_i              ),
    .ahbl_hresetn_i    (ahbl_hresetn_i           ),
    .ahbl_hsel_i       (ahbl_m00_hsel_mstr_o     ),
    .ahbl_hready_i     (ahbl_m00_hready_mstr_o   ),
    .ahbl_haddr_i      (ahbl_m00_haddr_mstr_o    ),
    .ahbl_hburst_i     (ahbl_m00_hburst_mstr_o   ),
    .ahbl_hsize_i      (ahbl_m00_hsize_mstr_o    ),
    .ahbl_hmastlock_i  (ahbl_m00_hmastlock_mstr_o),
    .ahbl_hprot_i      (ahbl_m00_hprot_mstr_o    ),
    .ahbl_htrans_i     (ahbl_m00_htrans_mstr_o   ),
    .ahbl_hwdata_i     (ahbl_m00_hwdata_mstr_o   ),
    .ahbl_hwrite_i     (ahbl_m00_hwrite_mstr_o   ),
    .ahbl_hreadyout_o  (ahbl_m00_hready_mstr_i   ),
    .ahbl_hresp_o      (ahbl_m00_hresp_mstr_i    ),
    .ahbl_hrdata_o     (ahbl_m00_hrdata_mstr_i   ),
    .ahbl_slv_dummy_in (ahbl_slv_dummy_in[0]     ),
    .ahbl_slv_dummy_out(ahbl_slv_dummy_out[0]    ));
  lscc_ahbl_slave_dummy #(
    .DATA_WIDTH(DATA_WIDTH  ),
    .ADDR_WIDTH(M_ADDR_WIDTH))
  ahbl_slv_01 (
    .ahbl_hclk_i       (ahbl_hclk_i              ),
    .ahbl_hresetn_i    (ahbl_hresetn_i           ),
    .ahbl_hsel_i       (ahbl_m01_hsel_mstr_o     ),
    .ahbl_hready_i     (ahbl_m01_hready_mstr_o   ),
    .ahbl_haddr_i      (ahbl_m01_haddr_mstr_o    ),
    .ahbl_hburst_i     (ahbl_m01_hburst_mstr_o   ),
    .ahbl_hsize_i      (ahbl_m01_hsize_mstr_o    ),
    .ahbl_hmastlock_i  (ahbl_m01_hmastlock_mstr_o),
    .ahbl_hprot_i      (ahbl_m01_hprot_mstr_o    ),
    .ahbl_htrans_i     (ahbl_m01_htrans_mstr_o   ),
    .ahbl_hwdata_i     (ahbl_m01_hwdata_mstr_o   ),
    .ahbl_hwrite_i     (ahbl_m01_hwrite_mstr_o   ),
    .ahbl_hreadyout_o  (ahbl_m01_hready_mstr_i   ),
    .ahbl_hresp_o      (ahbl_m01_hresp_mstr_i    ),
    .ahbl_hrdata_o     (ahbl_m01_hrdata_mstr_i   ),
    .ahbl_slv_dummy_in (ahbl_slv_dummy_in[1]     ),
    .ahbl_slv_dummy_out(ahbl_slv_dummy_out[1]    ));

`include "dut_inst.v"

endmodule
`endif
