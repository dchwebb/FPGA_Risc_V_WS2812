/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Propel (64-bit)
    2.0.2104292220
    Soft IP Version: 2.2
    2021 06 17 16:21:13
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module WS2812 (clk_i, resetn_i, led_ctl_o, debug_o, apb_penable_i, apb_psel_i,
    apb_pwrite_i, apb_paddr_i, apb_pwdata_i, apb_prdata_o, apb_pslverr_o,
    apb_pready_o, int_o)/* synthesis syn_black_box syn_declare_black_box=1 */;
    input  clk_i;
    input  resetn_i;
    output  led_ctl_o;
    output  debug_o;
    input  apb_penable_i;
    input  apb_psel_i;
    input  apb_pwrite_i;
    input  [5:0]  apb_paddr_i;
    input  [31:0]  apb_pwdata_i;
    output  [31:0]  apb_prdata_o;
    output  apb_pslverr_o;
    output  apb_pready_o;
    output  int_o;
endmodule