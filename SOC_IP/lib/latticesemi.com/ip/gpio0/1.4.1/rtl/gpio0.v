
// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
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
// File                  :lscc_apb2lmmi.v
// Title                 :
// Dependencies          :
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0.
// Author(s)             : Rommel.Edillorana@latticesemi.com
// Mod. Date             : 11/9/2017 4:02:30 PM
// Changes Made          : Initial release.
// =============================================================================
//==========================================================================
// Module : lscc_apb2lmmi
//==========================================================================
module gpio0_ipgen_lscc_apb2lmmi #(parameter DATA_WIDTH = 32, 
        parameter ADDR_WIDTH = 16, 
        parameter REG_OUTPUT = 1) (
    //--begin_param--
    //----------------------------
    // Parameters
    //----------------------------
    // Data width
    // Address width
    // enable registered output
    //--end_param--
    //--begin_ports--
    //----------------------------
    // Global Signals (Clock and Reset)
    //----------------------------
    input clk_i,  // apb clock
    input rst_n_i,  // active low reset
    //----------------------------
    // APB Interface
    //----------------------------
    input apb_penable_i,  // apb enable
    input apb_psel_i,  // apb slave select
    input apb_pwrite_i,  // apb write 1, read 0
    input [(ADDR_WIDTH - 1):0] apb_paddr_i,  // apb address
    input [(DATA_WIDTH - 1):0] apb_pwdata_i,  // apb write data
    output reg apb_pready_o,  // apb ready
    output reg apb_pslverr_o,  // apb slave error
    output reg [(DATA_WIDTH - 1):0] apb_prdata_o,  // apb read data
    //----------------------------
    // LMMI-Extended Interface
    //----------------------------
    input lmmi_ready_i,  // slave is ready to start new transaction
    input lmmi_rdata_valid_i,  // read transaction is complete
    input lmmi_error_i,  // error indicator
    input [(DATA_WIDTH - 1):0] lmmi_rdata_i,  // read data
    output reg lmmi_request_o,  // start transaction
    output reg lmmi_wr_rdn_o,  // write 1, read 0
    output reg [(ADDR_WIDTH - 1):0] lmmi_offset_o,  // address/offset
    output reg [(DATA_WIDTH - 1):0] lmmi_wdata_o,  // write data
    output wire lmmi_resetn_o // reset to LMMI inteface
        ) ;
    //--end_ports--
    //--------------------------------------------------------------------------
    //--- Local Parameters/Defines ---
    //--------------------------------------------------------------------------
    localparam ST_BUS_IDLE = 4'b0001 ; 
    localparam ST_BUS_REQ = 4'b0010 ; // APB_SETUP
    localparam ST_BUS_DAT = 4'b0100 ; // APB_ACCESS
    localparam ST_BUS_WAIT = 4'b1000 ; 
    localparam SM_WIDTH = 4 ; 
    //--------------------------------------------------------------------------
    //--- Combinational Wire/Reg ---
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    //--- Registers ---
    //--------------------------------------------------------------------------
    reg [(SM_WIDTH - 1):0] bus_sm_ns ; 
    reg [(SM_WIDTH - 1):0] bus_sm_cs ; 
    assign lmmi_resetn_o = rst_n_i ; 
    generate
        if (REG_OUTPUT) 
            begin : genblk1
                reg lmmi_request_nxt ; 
                reg lmmi_wr_rdn_nxt ; 
                reg [(ADDR_WIDTH - 1):0] lmmi_offset_nxt ; 
                reg [(DATA_WIDTH - 1):0] lmmi_wdata_nxt ; 
                reg apb_pready_nxt ; 
                reg apb_pslverr_nxt ; 
                reg [(DATA_WIDTH - 1):0] apb_prdata_nxt ; 
                //--------------------------------------------
                //-- Bus Statemachine --
                //--------------------------------------------
                always
                    @(*)
                    begin
                        bus_sm_ns = bus_sm_cs ;
                        case (bus_sm_cs)
                        ST_BUS_REQ : 
                            begin
                                if (lmmi_ready_i) 
                                    begin
                                        if (lmmi_wr_rdn_o) 
                                            begin
                                                bus_sm_ns = ST_BUS_WAIT ;
                                            end
                                        else
                                            begin
                                                if (lmmi_rdata_valid_i) 
                                                    bus_sm_ns = ST_BUS_WAIT ;
                                                else
                                                    bus_sm_ns = ST_BUS_DAT ;
                                            end
                                    end
                                else
                                    begin
                                        bus_sm_ns = ST_BUS_REQ ;
                                    end
                            end
                        ST_BUS_DAT : 
                            begin
                                if (lmmi_rdata_valid_i) 
                                    bus_sm_ns = ST_BUS_WAIT ;
                                else
                                    bus_sm_ns = ST_BUS_DAT ;
                            end
                        ST_BUS_WAIT : 
                            begin
                                bus_sm_ns = ST_BUS_IDLE ;
                            end
                        default : 
                            begin
                                if (apb_psel_i) 
                                    bus_sm_ns = ST_BUS_REQ ;
                                else
                                    bus_sm_ns = ST_BUS_IDLE ;
                            end
                        endcase 
                    end//--always @*--
                //--------------------------------------------
                //-- APB to LMMI conversion --
                //--------------------------------------------
                always
                    @(*)
                    begin
                        lmmi_request_nxt = lmmi_request_o ;
                        lmmi_wr_rdn_nxt = lmmi_wr_rdn_o ;
                        lmmi_offset_nxt = lmmi_offset_o ;
                        lmmi_wdata_nxt = lmmi_wdata_o ;
                        apb_pready_nxt = apb_pready_o ;
                        apb_pslverr_nxt = 1'b0 ;
                        apb_prdata_nxt = apb_prdata_o ;
                        case (bus_sm_cs)
                        ST_BUS_REQ : 
                            begin
                                if (lmmi_ready_i) 
                                    begin
                                        lmmi_request_nxt = 1'b0 ;
                                        lmmi_wr_rdn_nxt = 1'b0 ;
                                        if (lmmi_wr_rdn_o) 
                                            begin
                                                apb_pready_nxt = 1'b1 ;
                                            end
                                        else
                                            begin
                                                if (lmmi_rdata_valid_i) 
                                                    begin
                                                        apb_pready_nxt = 1'b1 ;
                                                        apb_prdata_nxt = lmmi_rdata_i ;
                                                        apb_pslverr_nxt = lmmi_error_i ;
                                                    end
                                            end
                                    end
                            end
                        ST_BUS_DAT : 
                            begin
                                if (lmmi_rdata_valid_i) 
                                    begin
                                        apb_pready_nxt = 1'b1 ;
                                        apb_prdata_nxt = lmmi_rdata_i ;
                                        apb_pslverr_nxt = lmmi_error_i ;
                                    end
                            end
                        ST_BUS_WAIT : 
                            begin
                                apb_pready_nxt = 1'b0 ;
                            end
                        default : 
                            begin
                                apb_pready_nxt = 1'b0 ;
                                if (apb_psel_i) 
                                    begin
                                        lmmi_request_nxt = 1'b1 ;
                                        lmmi_wr_rdn_nxt = apb_pwrite_i ;
                                        lmmi_offset_nxt = apb_paddr_i ;
                                        lmmi_wdata_nxt = apb_pwdata_i ;
                                    end
                                else
                                    begin
                                        lmmi_request_nxt = 1'b0 ;
                                        lmmi_wr_rdn_nxt = 1'b0 ;
                                    end
                            end
                        endcase 
                    end//--always @*--
                //--------------------------------------------
                //-- Sequential block --
                //--------------------------------------------
                always
                    @(posedge clk_i or 
                        negedge rst_n_i)
                    begin
                        if ((~rst_n_i)) 
                            begin
                                bus_sm_cs <=  ST_BUS_IDLE ;
                                /*AUTORESET*/
                                // Beginning of autoreset for uninitialized flops
                                apb_prdata_o <=  {(1 + (DATA_WIDTH - 1)){1'b0}} ;
                                apb_pready_o <=  {1{1'b0}} ;
                                apb_pslverr_o <=  {1{1'b0}} ;
                                lmmi_offset_o <=  {(1 + (ADDR_WIDTH - 1)){1'b0}} ;
                                lmmi_request_o <=  {1{1'b0}} ;
                                lmmi_wdata_o <=  {(1 + (DATA_WIDTH - 1)){1'b0}} ;
                                lmmi_wr_rdn_o <=  {1{1'b0}} ;
                                // End of automatics
                            end
                        else
                            begin
                                bus_sm_cs <=  bus_sm_ns ;
                                lmmi_request_o <=  lmmi_request_nxt ;
                                lmmi_wr_rdn_o <=  lmmi_wr_rdn_nxt ;
                                lmmi_offset_o <=  lmmi_offset_nxt ;
                                lmmi_wdata_o <=  lmmi_wdata_nxt ;
                                apb_pready_o <=  apb_pready_nxt ;
                                apb_pslverr_o <=  apb_pslverr_nxt ;
                                apb_prdata_o <=  apb_prdata_nxt ;
                            end
                    end//--always @(posedge clk_i or negedge rst_n_i)--
            end
        else
            begin : genblk1
                // REG_OUTPUT == 0
                //--------------------------------------------
                //-- Bus Statemachine --
                //--------------------------------------------
                always
                    @(*)
                    begin
                        bus_sm_ns = bus_sm_cs ;
                        case (bus_sm_cs)
                        ST_BUS_IDLE : 
                            begin
                                if (apb_psel_i) 
                                    bus_sm_ns = ST_BUS_REQ ;
                                else
                                    bus_sm_ns = ST_BUS_IDLE ;
                            end
                        ST_BUS_REQ : 
                            begin
                                if (lmmi_ready_i) 
                                    if (((~apb_pwrite_i) && (~lmmi_rdata_valid_i))) 
                                        bus_sm_ns = ST_BUS_DAT ;
                                    else
                                        // Write access will go to IDLE when ready
                                        bus_sm_ns = ST_BUS_IDLE ;
                                else
                                    bus_sm_ns = ST_BUS_REQ ;
                            end
                        ST_BUS_DAT : 
                            begin
                                if ((apb_penable_i && ((~apb_pwrite_i) && lmmi_rdata_valid_i))) 
                                    bus_sm_ns = ST_BUS_IDLE ;
                                else
                                    bus_sm_ns = ST_BUS_DAT ;
                            end
                        default : 
                            begin
                                bus_sm_ns = ST_BUS_IDLE ;
                            end
                        endcase 
                    end//--always @*--
                //--------------------------------------------
                //-- LMMI request --
                //--------------------------------------------
                always
                    @(*)
                    begin
                        lmmi_request_o = (bus_sm_ns == ST_BUS_REQ) ;
                        lmmi_wr_rdn_o = apb_pwrite_i ;
                        lmmi_offset_o = apb_paddr_i ;
                        lmmi_wdata_o = apb_pwdata_i ;
                    end//--always @*--
                //--------------------------------------------
                //-- APB outputs --
                //--------------------------------------------
                always
                    @(*)
                    begin
                        apb_prdata_o = lmmi_rdata_i ;
                        apb_pslverr_o = (lmmi_rdata_valid_i && lmmi_error_i) ;
                        if (apb_pwrite_i) 
                            begin
                                apb_pready_o = lmmi_ready_i ;
                            end
                        else
                            begin
                                apb_pready_o = (lmmi_ready_i && lmmi_rdata_valid_i) ;
                            end
                    end//--always @*--
                //--------------------------------------------
                //-- Sequential block --
                //--------------------------------------------
                always
                    @(posedge clk_i or 
                        negedge rst_n_i)
                    begin
                        if ((~rst_n_i)) 
                            begin
                                bus_sm_cs <=  ST_BUS_IDLE ;
                            end
                        else
                            begin
                                bus_sm_cs <=  bus_sm_ns ;
                            end
                    end//--always @(posedge clk_i or negedge rst_n_i)--
            end
    endgenerate

//--------------------------------------------------------------------------
//--- Module Instantiation ---
//--------------------------------------------------------------------------
//--lscc_apb2lmmi--
endmodule



`timescale 1ns/10ps
// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
// Copyright (c) 2018 by Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// --------------------------------------------------------------------
//
// Permission:
//
// Lattice SG Pte. Ltd. grants permission to use this code
// pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
// Disclaimer:
//
// This VHDL or Verilog source code is intended as a design reference
// which illustrates how these types of functions can be implemented.
// It is the user's responsibility to verify their design for
// consistency and functionality through the use of formal
// verification methods. Lattice provides no warranty
// regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                     Lattice SG Pte. Ltd.
//                     101 Thomson Road, United Square #07-02
//                     Singapore 307591
//
//
//                     TEL: 1-800-Lattice (USA and Canada)
//                     +65-6631-2000 (Singapore)
//                     +1-503-268-8001 (other locations)
//
//                     web: http://www.latticesemi.com/
//                     email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
// FILE DETAILS
// Project : <GPIO>
// File : lscc_gpio.v
// Title :
// Dependencies : 1.
//              : 2.
// Description :
// =============================================================================
// REVISION HISTORY
// Version : 1.0
// Author(s) : TP
// Mod. Date : 07/11/2019
// Changes Made : Initial version of RTL
// -----------------------------------------------------------------------------
// Version : 1.1
// Author(s) :
// Mod. Date :
// Changes Made :
// =============================================================================
module gpio0_ipgen_lscc_gpio #(parameter FAMILY = "LIFCL", 
        parameter integer OFFSET_WIDTH = 4, 
        parameter DIRECTION_DEF_VAL = "FFFFFFFF", 
        parameter integer IO_LINES_COUNT = 32, 
        parameter INT_TYPE = 32'h00000000, 
        parameter INT_METHOD = 32'h00000000, 
        parameter INT_ENABLE = 32'h00000000, 
        parameter OUT_RESET_VAL = "FFFFFFFF", 
        parameter EXTERNAL_BUF = 0, 
        parameter IF_USER_INTF = "LMMI", 
        parameter ADDR_WIDTH = 6) (
    // 0 = Edge Interrupt, 1 = Level Interrupt
    // if (INT_TYPE = 0) then 0 = Rising Edge, 1 = Falling Edge,
    // else 0 = High Level, 1 = Low Level
    // 1: Remove IO Buffer, 0: Keep IO Buffer (Default - compatible with previous release)
    // Interface type "LMMI" "AHBL" or "APB"
    // Width of Address signal in the I/F
    // parameters
    // LMMI Interface
    input clk_i, 
    input resetn_i, 
    input [(IO_LINES_COUNT - 1):0] lmmi_wdata_i, 
    output [(IO_LINES_COUNT - 1):0] lmmi_rdata_o, 
    output lmmi_rdata_valid_o, 
    output lmmi_ready_o, 
    input lmmi_wr_rdn_i, 
    input [(OFFSET_WIDTH - 1):0] lmmi_offset_i, 
    input lmmi_request_i, 
    output int_o, 
    //APB Interface
    input apb_penable_i, 
    input apb_psel_i, 
    input apb_pwrite_i, 
    input [(ADDR_WIDTH - 1):0] apb_paddr_i, 
    input [31:0] apb_pwdata_i, 
    output apb_pready_o, 
    output apb_pslverr_o, 
    output reg [31:0] apb_prdata_o, 
    // IP Core Interface
    input [(IO_LINES_COUNT - 1):0] gpio_i, 
    output [(IO_LINES_COUNT - 1):0] gpio_o, 
    output [(IO_LINES_COUNT - 1):0] gpio_en_o, 
    inout [(IO_LINES_COUNT - 1):0] gpio_io) ;
    // ports
    wire [(IO_LINES_COUNT - 1):0] lmmi_wdata_w ; 
    wire [(IO_LINES_COUNT - 1):0] lmmi_rdata_w ; 
    wire lmmi_rdata_valid_w ; 
    wire lmmi_ready_w ; 
    wire lmmi_wr_rdn_w ; 
    wire [(OFFSET_WIDTH - 1):0] lmmi_offset_w ; 
    wire lmmi_request_w ; 
    wire lmmi_resetn_w ; 
    wire [(ADDR_WIDTH - 1):0] apb_lmmi_offset_w ; 
    wire [(IO_LINES_COUNT - 1):0] apb_prdata_w ; 
    generate
        if ((FAMILY == "iCE40UP")) 
            begin : genblk1
                (* LSC_IP_SC_gpio=1 *) gpio0_ipgen_lscc_gpio_lmmi #(.FAMILY(FAMILY),
                        .OFFSET_WIDTH(OFFSET_WIDTH),
                        .DIRECTION_DEF_VAL(DIRECTION_DEF_VAL),
                        .IO_LINES_COUNT(IO_LINES_COUNT),
                        .INT_TYPE(INT_TYPE),
                        .INT_METHOD(INT_METHOD),
                        .INT_ENABLE(INT_ENABLE),
                        .OUT_RESET_VAL(OUT_RESET_VAL),
                        .IF_USER_INTF(IF_USER_INTF)) lscc_gpio_lmmi_0 (// 0 = Edge Interrupt, 1 = Level Interrupt
                        // if (INT_TYPE = 0) then 0 = Rising Edge, 1 = Falling Edge,
                        // parameters
                        .clk_i(clk_i), 
                            .resetn_i(resetn_i), 
                            // LMMI Interface
                        .lmmi_wdata_i(lmmi_wdata_w), 
                            .lmmi_rdata_o(lmmi_rdata_w), 
                            .lmmi_rdata_valid_o(lmmi_rdata_valid_w), 
                            .lmmi_ready_o(lmmi_ready_w), 
                            .lmmi_wr_rdn_i(lmmi_wr_rdn_w), 
                            .lmmi_offset_i(lmmi_offset_w), 
                            .lmmi_request_i(lmmi_request_w), 
                            .int_o(int_o), 
                            .gpio_io(gpio_io)) ; // ports
            end
        else
            begin : genblk1
                (* LSC_IP_SC_HT_gpio_cnx=1 *) gpio0_ipgen_lscc_gpio_lmmi #(.FAMILY(FAMILY),
                        .OFFSET_WIDTH(OFFSET_WIDTH),
                        .DIRECTION_DEF_VAL(DIRECTION_DEF_VAL),
                        .IO_LINES_COUNT(IO_LINES_COUNT),
                        .INT_TYPE(INT_TYPE),
                        .INT_METHOD(INT_METHOD),
                        .INT_ENABLE(INT_ENABLE),
                        .OUT_RESET_VAL(OUT_RESET_VAL),
                        .EXTERNAL_BUF(EXTERNAL_BUF),
                        .IF_USER_INTF(IF_USER_INTF)) lscc_gpio_lmmi_0 (// 0 = Edge Interrupt, 1 = Level Interrupt
                        // if (INT_TYPE = 0) then 0 = Rising Edge, 1 = Falling Edge,
                        // parameters
                        .clk_i(clk_i), 
                            .resetn_i(resetn_i), 
                            // LMMI Interface
                        .lmmi_wdata_i(lmmi_wdata_w), 
                            .lmmi_rdata_o(lmmi_rdata_w), 
                            .lmmi_rdata_valid_o(lmmi_rdata_valid_w), 
                            .lmmi_ready_o(lmmi_ready_w), 
                            .lmmi_wr_rdn_i(lmmi_wr_rdn_w), 
                            .lmmi_offset_i(lmmi_offset_w), 
                            .lmmi_request_i(lmmi_request_w), 
                            .int_o(int_o), 
                            .gpio_i(gpio_i), 
                            .gpio_o(gpio_o), 
                            .gpio_en_o(gpio_en_o), 
                            .gpio_io(gpio_io)) ; // ports
            end
    endgenerate
    generate
        if ((IF_USER_INTF == "LMMI")) 
            begin : genblk2
                assign lmmi_wdata_w = lmmi_wdata_i ; 
                assign lmmi_wr_rdn_w = lmmi_wr_rdn_i ; 
                assign lmmi_offset_w = lmmi_offset_i ; 
                assign lmmi_request_w = lmmi_request_i ; 
                assign lmmi_rdata_o = lmmi_rdata_w ; 
                assign lmmi_rdata_valid_o = lmmi_rdata_valid_w ; 
                assign lmmi_ready_o = lmmi_ready_w ; 
            end
        else
            if ((IF_USER_INTF == "APB")) 
                begin : genblk2
                    gpio0_ipgen_lscc_apb2lmmi #(.DATA_WIDTH(IO_LINES_COUNT),
                            .ADDR_WIDTH(ADDR_WIDTH),
                            .REG_OUTPUT(1)) lscc_apb2lmmi_0 (.clk_i(clk_i), 
                                .rst_n_i(resetn_i), 
                                //----------------------------
                            // APB Interface
                            //----------------------------
                            .apb_penable_i(apb_penable_i), 
                                .apb_psel_i(apb_psel_i), 
                                .apb_pwrite_i(apb_pwrite_i), 
                                .apb_paddr_i(apb_paddr_i), 
                                .apb_pwdata_i(apb_pwdata_i[(IO_LINES_COUNT - 1):0]), 
                                .apb_pready_o(apb_pready_o), 
                                .apb_pslverr_o(apb_pslverr_o), 
                                .apb_prdata_o(apb_prdata_w), 
                                //----------------------------
                            // LMMI-Extended Interface
                            //----------------------------
                            .lmmi_ready_i(lmmi_ready_w), 
                                .lmmi_rdata_valid_i(lmmi_rdata_valid_w), 
                                .lmmi_error_i(1'b0), 
                                .lmmi_rdata_i(lmmi_rdata_w), 
                                .lmmi_request_o(lmmi_request_w), 
                                .lmmi_wr_rdn_o(lmmi_wr_rdn_w), 
                                .lmmi_offset_o(apb_lmmi_offset_w), 
                                .lmmi_wdata_o(lmmi_wdata_w), 
                                .lmmi_resetn_o(lmmi_resetn_w)) ; 
                    assign lmmi_offset_w = apb_lmmi_offset_w[(OFFSET_WIDTH + 1):2] ; 
                    always
                        @(*)
                        begin
                            if ((IO_LINES_COUNT <= 31)) 
                                begin
                                    apb_prdata_o = {{(32 - IO_LINES_COUNT){1'b0}},
                                            apb_prdata_w} ;
                                end
                            else
                                if ((IO_LINES_COUNT == 32)) 
                                    begin
                                        apb_prdata_o = apb_prdata_w ;
                                    end
                        end
                end
    endgenerate
endmodule



`timescale 1ns/10ps
// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
// Copyright (c) 2018 by Lattice Semiconductor Corporation
// ALL RIGHTS RESERVED
// --------------------------------------------------------------------
//
// Permission:
//
// Lattice SG Pte. Ltd. grants permission to use this code
// pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
// Disclaimer:
//
// This VHDL or Verilog source code is intended as a design reference
// which illustrates how these types of functions can be implemented.
// It is the user's responsibility to verify their design for
// consistency and functionality through the use of formal
// verification methods. Lattice provides no warranty
// regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                     Lattice SG Pte. Ltd.
//                     101 Thomson Road, United Square #07-02
//                     Singapore 307591
//
//
//                     TEL: 1-800-Lattice (USA and Canada)
//                     +65-6631-2000 (Singapore)
//                     +1-503-268-8001 (other locations)
//
//                     web: http://www.latticesemi.com/
//                     email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
// FILE DETAILS
// Project : <GPIO>
// File : lscc_gpio_lmmi.v
// Title :
// Dependencies : 1.
//              : 2.
// Description :
// =============================================================================
// REVISION HISTORY
// Version : 1.0
// Author(s) : TP
// Mod. Date : 02/01/2018
// Changes Made : Initial version of RTL
// -----------------------------------------------------------------------------
// Version : 1.1
// Author(s) :
// Mod. Date :
// Changes Made :
// =============================================================================
module gpio0_ipgen_lscc_gpio_lmmi #(parameter FAMILY = "LIFCL", 
        parameter integer OFFSET_WIDTH = 4, 
        parameter DIRECTION_DEF_VAL = "FFFFFFFF", 
        parameter integer IO_LINES_COUNT = 32, 
        parameter INT_TYPE = 32'h00000000, 
        parameter INT_METHOD = 32'h00000000, 
        parameter INT_ENABLE = 32'h00000000, 
        parameter OUT_RESET_VAL = "FFFFFFFF", 
        parameter EXTERNAL_BUF = 0, 
        parameter IF_USER_INTF = "LMMI") (
    // 0 = Edge Interrupt, 1 = Level Interrupt
    // if (INT_TYPE = 0) then 0 = Rising Edge, 1 = Falling Edge,
    // else 0 = High Level, 1 = Low Level
    // parameters
    // LMMI Interface
    // LMMI System Signals
    input clk_i, 
    input resetn_i, 
    // LMMI Write Signals
    input [(IO_LINES_COUNT - 1):0] lmmi_wdata_i, 
    // LMMI Read Signals
    output [(IO_LINES_COUNT - 1):0] lmmi_rdata_o, 
    output lmmi_rdata_valid_o, 
    // LMMI Controll Signals
    output lmmi_ready_o, 
    input lmmi_wr_rdn_i, 
    input [(OFFSET_WIDTH - 1):0] lmmi_offset_i, 
    input lmmi_request_i, 
    // Lattice Interrupt Interface (LINTR)
    output int_o, 
    // IP Core Interface
    input [(IO_LINES_COUNT - 1):0] gpio_i, 
    output [(IO_LINES_COUNT - 1):0] gpio_o, 
    output [(IO_LINES_COUNT - 1):0] gpio_en_o, 
    inout [(IO_LINES_COUNT - 1):0] gpio_io) ;
    // ports
    function [31:0] convert_str_to_bitvector ; 
        input reg [63:0] string_argument ; 
        integer i ; 
        reg [3:0] temp_bitvector ; 
        reg [31:0] result_bitvector ; 
        reg [63:0] string_arg ; 
        begin
            result_bitvector = 32'h00000000 ;
            string_arg = string_argument ;
            for (i = 0 ; (i < 8) ; i = (i + 1))
                begin
                    case (string_arg[7:0])
                    8'h30 : 
                        temp_bitvector = 'h0 ;
                    8'h31 : 
                        temp_bitvector = 'h1 ;
                    8'h32 : 
                        temp_bitvector = 'h2 ;
                    8'h33 : 
                        temp_bitvector = 'h3 ;
                    8'h34 : 
                        temp_bitvector = 'h4 ;
                    8'h35 : 
                        temp_bitvector = 'h5 ;
                    8'h36 : 
                        temp_bitvector = 'h6 ;
                    8'h37 : 
                        temp_bitvector = 'h7 ;
                    8'h38 : 
                        temp_bitvector = 'h8 ;
                    8'h39 : 
                        temp_bitvector = 'h9 ;
                    8'h41 : 
                        temp_bitvector = 'hA ;
                    8'h42 : 
                        temp_bitvector = 'hB ;
                    8'h43 : 
                        temp_bitvector = 'hC ;
                    8'h44 : 
                        temp_bitvector = 'hD ;
                    8'h45 : 
                        temp_bitvector = 'hE ;
                    8'h46 : 
                        temp_bitvector = 'hF ;
                    8'h61 : 
                        temp_bitvector = 'ha ;
                    8'h62 : 
                        temp_bitvector = 'hb ;
                    8'h63 : 
                        temp_bitvector = 'hc ;
                    8'h64 : 
                        temp_bitvector = 'hd ;
                    8'h65 : 
                        temp_bitvector = 'he ;
                    8'h66 : 
                        temp_bitvector = 'hf ;
                    default : 
                        temp_bitvector = 4'hf ;
                    endcase 
                    result_bitvector = {temp_bitvector,
                            result_bitvector[31:4]} ;
                    string_arg = (string_arg >> 8) ;
                    convert_str_to_bitvector = result_bitvector ;
                end
        end
    endfunction
    localparam [31:0] DIRECTION_DEF_VAL_BITVEC = convert_str_to_bitvector(DIRECTION_DEF_VAL) ; 
    localparam [31:0] OUT_RESET_VAL_BITVEC = convert_str_to_bitvector(OUT_RESET_VAL) ; 
    //Addresses of Registers
    localparam RD_DATA_REG_ADDR = 4'b0000 ; 
    localparam WR_DATA_REG_ADDR = 4'b0001 ; 
    localparam SET_DATA_REG_ADDR = 4'b0010 ; 
    localparam CLEAR_DATA_REG_ADDR = 4'b0011 ; 
    localparam DIRECTION_REG_ADDR = 4'b0100 ; 
    localparam INT_TYPE_REG_ADDR = 4'b0101 ; 
    localparam INT_METHOD_REG_ADDR = 4'b0110 ; 
    localparam INT_STATUS_REG_ADDR = 4'b0111 ; 
    localparam INT_ENABLE_REG_ADDR = 4'b1000 ; 
    localparam INT_SET_REG_ADDR = 4'b1001 ; 
    genvar i ; 
    reg [(IO_LINES_COUNT - 1):0] lmmi_rdata_r ; 
    reg lmmi_rdata_valid_r ; 
    reg [(IO_LINES_COUNT - 1):0] int_status_r ; //  Interrupt Status Register
    //  "write 1 to clear the corresponding bit"
    reg [(IO_LINES_COUNT - 1):0] int_type_r ; 
    reg [(IO_LINES_COUNT - 1):0] int_method_r ; 
    reg [(IO_LINES_COUNT - 1):0] int_enable_r ; 
    reg [(IO_LINES_COUNT - 1):0] direction_r ; 
    wire [(IO_LINES_COUNT - 1):0] tristate_w ; 
    wire [(IO_LINES_COUNT - 1):0] gpio_in ; 
    reg [(IO_LINES_COUNT - 1):0] gpio_in_r ; 
    reg [(IO_LINES_COUNT - 1):0] gpio_in_dr0 ; 
    reg [(IO_LINES_COUNT - 1):0] gpio_in_dr1 ; 
    reg [(IO_LINES_COUNT - 1):0] gpio_out_r ; 
    reg [(IO_LINES_COUNT - 1):0] int_status_next_r ; 
    reg [(IO_LINES_COUNT - 1):0] rising_edge_det_r ; 
    reg [(IO_LINES_COUNT - 1):0] falling_edge_det_r ; 
    wire [(IO_LINES_COUNT - 1):0] lmmi_wdata_w ; 
    wire lmmi_wr_rdn_w ; 
    wire [(OFFSET_WIDTH - 1):0] lmmi_offset_w ; 
    wire lmmi_request_w ; 
    wire lmmi_ready_w ; 
    // lmmi_ready output generation
    wire write_enable_w ; 
    wire read_enable_w ; 
    assign lmmi_rdata_o = lmmi_rdata_r ; 
    assign lmmi_rdata_valid_o = lmmi_rdata_valid_r ; 
    assign lmmi_ready_o = lmmi_ready_w ; 
    assign int_o = (|(int_status_r & int_enable_r)) ; 
    assign tristate_w = (~direction_r) ; 
    //assign gpio_o             = gpio_out_r & (~direction_r);
    assign lmmi_wdata_w = lmmi_wdata_i ; 
    assign lmmi_wr_rdn_w = lmmi_wr_rdn_i ; 
    assign lmmi_offset_w = lmmi_offset_i ; 
    assign lmmi_request_w = lmmi_request_i ; 
    assign lmmi_ready_w = 1'b1 ; 
    assign write_enable_w = ((((lmmi_ready_w == 1'b1) && (lmmi_wr_rdn_w == 1'b1)) && (lmmi_request_w == 1'b1)) ? 1'b1 : 1'b0) ; 
    assign read_enable_w = ((((lmmi_ready_w == 1'b1) && (lmmi_wr_rdn_w == 1'b0)) && (lmmi_request_w == 1'b1)) ? 1'b1 : 1'b0) ; 
    //LMMI write
    always
        @(posedge clk_i)
        begin
            if ((resetn_i == 1'b0)) 
                begin
                    int_type_r <=  INT_TYPE ;
                    int_method_r <=  INT_METHOD ;
                    int_enable_r <=  INT_ENABLE ;
                    direction_r <=  DIRECTION_DEF_VAL_BITVEC[(IO_LINES_COUNT - 1):0] ;
                    gpio_out_r <=  OUT_RESET_VAL_BITVEC[(IO_LINES_COUNT - 1):0] ;
                    int_status_r <=  {IO_LINES_COUNT{1'b0}} ;
                end// lmmi_resetn
            else
                begin
                    int_status_r <=  (int_status_r | int_status_next_r) ;
                    if ((write_enable_w == 1'b1)) 
                        begin
                            case (lmmi_offset_w)
                            WR_DATA_REG_ADDR : 
                                begin
                                    gpio_out_r <=  lmmi_wdata_w[(IO_LINES_COUNT - 1):0] ;
                                end
                            SET_DATA_REG_ADDR : 
                                begin
                                    gpio_out_r <=  (gpio_out_r | lmmi_wdata_w[(IO_LINES_COUNT - 1):0]) ;
                                end
                            CLEAR_DATA_REG_ADDR : 
                                begin
                                    gpio_out_r <=  (gpio_out_r & (~lmmi_wdata_w[(IO_LINES_COUNT - 1):0])) ;
                                end
                            DIRECTION_REG_ADDR : 
                                begin
                                    direction_r <=  lmmi_wdata_w[(IO_LINES_COUNT - 1):0] ;
                                end
                            INT_ENABLE_REG_ADDR : 
                                begin
                                    int_enable_r <=  lmmi_wdata_w[(IO_LINES_COUNT - 1):0] ;
                                end
                            INT_TYPE_REG_ADDR : 
                                begin
                                    int_type_r <=  lmmi_wdata_w[(IO_LINES_COUNT - 1):0] ;
                                end
                            INT_METHOD_REG_ADDR : 
                                begin
                                    int_method_r <=  lmmi_wdata_w[(IO_LINES_COUNT - 1):0] ;
                                end
                            INT_SET_REG_ADDR : 
                                begin
                                    int_status_r <=  ((int_status_r | lmmi_wdata_w[(IO_LINES_COUNT - 1):0]) | int_status_next_r) ;
                                end
                            INT_STATUS_REG_ADDR : 
                                begin
                                    int_status_r <=  ((int_status_r & (~lmmi_wdata_w[(IO_LINES_COUNT - 1):0])) | int_status_next_r) ;
                                end
                            default : 
                                begin
                                end
                            endcase 
                        end// if write_enable_w
                end// posedge clk_i
        end//always
    // LMMI rdata
    if ((IF_USER_INTF == "LMMI")) 
        begin : if_lmmi
            always
                @(posedge clk_i)
                begin
                    if ((resetn_i == 1'b0)) 
                        begin
                            lmmi_rdata_r <=  {IO_LINES_COUNT{1'b0}} ;
                            lmmi_rdata_valid_r <=  1'b0 ;
                        end
                    else
                        begin
                            if ((read_enable_w == 1'b1)) 
                                begin
                                    lmmi_rdata_valid_r <=  1'b1 ;
                                    case (lmmi_offset_w)
                                    RD_DATA_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  gpio_in_dr1 ;
                                        end
                                    WR_DATA_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  gpio_out_r ;
                                        end
                                    DIRECTION_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  direction_r ;
                                        end
                                    INT_ENABLE_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  int_enable_r ;
                                        end
                                    INT_TYPE_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  int_type_r ;
                                        end
                                    INT_METHOD_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  int_method_r ;
                                        end
                                    INT_STATUS_REG_ADDR : 
                                        begin
                                            lmmi_rdata_r[(IO_LINES_COUNT - 1):0] <=  int_status_r ;
                                        end
                                    default : 
                                        begin
                                            lmmi_rdata_r <=  {IO_LINES_COUNT{1'b0}} ;
                                        end// default
                                    endcase 
                                end
                            else
                                begin
                                    lmmi_rdata_valid_r <=  1'b0 ;
                                end
                        end
                end// always
        end
    else
        begin : genblk1
            always
                @(*)
                begin : if_apb
                    if ((read_enable_w == 1'b1)) 
                        begin
                            lmmi_rdata_valid_r = 1'b1 ;
                            case (lmmi_offset_w)
                            RD_DATA_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = gpio_in_dr1 ;
                                end
                            WR_DATA_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = gpio_out_r ;
                                end
                            DIRECTION_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = direction_r ;
                                end
                            INT_ENABLE_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = int_enable_r ;
                                end
                            INT_TYPE_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = int_type_r ;
                                end
                            INT_METHOD_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = int_method_r ;
                                end
                            INT_STATUS_REG_ADDR : 
                                begin
                                    lmmi_rdata_r[(IO_LINES_COUNT - 1):0] = int_status_r ;
                                end
                            default : 
                                begin
                                    lmmi_rdata_r = {IO_LINES_COUNT{1'b0}} ;
                                end// default
                            endcase 
                        end
                    else
                        begin
                            lmmi_rdata_valid_r = 1'b0 ;
                        end
                end
        end
    always
        @(posedge clk_i)
        begin
            if ((resetn_i == 1'b0)) 
                begin
                    gpio_in_r <=  {IO_LINES_COUNT{1'b0}} ;
                    gpio_in_dr0 <=  {IO_LINES_COUNT{1'b0}} ;
                    gpio_in_dr1 <=  {IO_LINES_COUNT{1'b0}} ;
                end
            else
                begin
                    // Added double register to mitigate metastability
                    //    gpio_in_r <= gpio_in;
                    gpio_in_dr0 <=  gpio_in ;
                    gpio_in_dr1 <=  gpio_in_dr0 ;
                    gpio_in_r <=  gpio_in_dr1 ;// gpio_in_r is used for checking the edge
                end
        end// always
    generate
        for (i = 0;(i < IO_LINES_COUNT);i = (i + 1))
        begin : genblk2
            if ((EXTERNAL_BUF == 0)) 
                begin : genblk1
                    if ((FAMILY == "iCE40UP")) 
                        begin : genblk1
                            assign gpio_in[i] = (tristate_w[i] ? gpio_io[i] : gpio_out_r[i]) ; 
                        end
                    else
                        begin : genblk1
                            BB u_BB_data (.B(gpio_io[i]), 
                                        .I(gpio_out_r[i]), 
                                        .T(tristate_w[i]), 
                                        .O(gpio_in[i])) ; 
                        end
                end
            else
                begin : genblk1
                    assign gpio_in[i] = gpio_i[i] ; 
                    assign gpio_o[i] = gpio_out_r[i] ; 
                    assign gpio_en_o[i] = tristate_w[i] ; 
                end
            always
                @(*)
                begin
                    int_status_next_r[i] = 1'b0 ;
                    if ((direction_r[i] == 1'b0)) 
                        begin
                            //current pin is input and interrupt is enabled
                            if ((int_type_r[i] == 1'b0)) 
                                begin
                                    //interrupt type = edge
                                    if ((int_method_r[i] == 1'b1)) 
                                        begin
                                            if ((rising_edge_det_r[i] == 1'b1)) 
                                                begin
                                                    int_status_next_r[i] = 1'b1 ;
                                                end
                                        end
                                    else
                                        if ((falling_edge_det_r[i] == 1'b1)) 
                                            begin
                                                int_status_next_r[i] = 1'b1 ;
                                            end
                                end
                            else
                                begin
                                    //interrupt type = level
                                    if ((int_method_r[i] == 1'b1)) 
                                        begin
                                            if ((gpio_in_dr1[i] == 1'b1)) 
                                                begin
                                                    //High level interrupt
                                                    int_status_next_r[i] = 1'b1 ;
                                                end
                                        end
                                    else
                                        if ((gpio_in_dr1[i] == 1'b0)) 
                                            begin
                                                //Low level interrupt
                                                int_status_next_r[i] = 1'b1 ;
                                            end
                                end
                        end
                    else
                        begin
                            int_status_next_r[i] = 1'b0 ;
                        end
                end// always
            always
                @(*)
                begin
                    if (((gpio_in_r[i] == 1'b0) && (gpio_in_dr1[i] == 1'b1))) 
                        begin
                            rising_edge_det_r[i] = 1'b1 ;
                        end
                    else
                        begin
                            rising_edge_det_r[i] = 1'b0 ;
                        end
                    if (((gpio_in_r[i] == 1'b1) && (gpio_in_dr1[i] == 1'b0))) 
                        begin
                            falling_edge_det_r[i] = 1'b1 ;
                        end
                    else
                        begin
                            falling_edge_det_r[i] = 1'b0 ;
                        end
                end// always
        end
    endgenerate
endmodule



`timescale 1ns/10ps
/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Propel (64-bit)
    2.0.2103172220
    Soft IP Version: 1.4.1
    2021 03 26 11:35:04
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module gpio0 (gpio_io, 
        clk_i, 
        resetn_i, 
        apb_penable_i, 
        apb_psel_i, 
        apb_pwrite_i, 
        apb_paddr_i, 
        apb_pwdata_i, 
        apb_prdata_o, 
        apb_pslverr_o, 
        apb_pready_o, 
        int_o) ;
    inout [7:0] gpio_io ; 
    input clk_i ; 
    input resetn_i ; 
    input apb_penable_i ; 
    input apb_psel_i ; 
    input apb_pwrite_i ; 
    input [5:0] apb_paddr_i ; 
    input [31:0] apb_pwdata_i ; 
    output [31:0] apb_prdata_o ; 
    output apb_pslverr_o ; 
    output apb_pready_o ; 
    output int_o ; 
    gpio0_ipgen_lscc_gpio #(.FAMILY("MachXO3L"),
            .IO_LINES_COUNT(8),
            .EXTERNAL_BUF(0),
            .OUT_RESET_VAL("32'h00000000"),
            .DIRECTION_DEF_VAL("32'h000000FF"),
            .IF_USER_INTF("APB")) lscc_gpio_inst (.gpio_io(gpio_io[7:0]), 
                .gpio_i(8'b00000000), 
                .gpio_o(), 
                .gpio_en_o(), 
                .clk_i(clk_i), 
                .resetn_i(resetn_i), 
                .lmmi_request_i(1'b0), 
                .lmmi_wr_rdn_i(1'b0), 
                .lmmi_offset_i(4'b0000), 
                .lmmi_wdata_i(8'b00000000), 
                .lmmi_rdata_o(), 
                .lmmi_rdata_valid_o(), 
                .lmmi_ready_o(), 
                .apb_penable_i(apb_penable_i), 
                .apb_psel_i(apb_psel_i), 
                .apb_pwrite_i(apb_pwrite_i), 
                .apb_paddr_i(apb_paddr_i[5:0]), 
                .apb_pwdata_i(apb_pwdata_i[31:0]), 
                .apb_prdata_o(apb_prdata_o[31:0]), 
                .apb_pslverr_o(apb_pslverr_o), 
                .apb_pready_o(apb_pready_o), 
                .int_o(int_o)) ; 
endmodule


