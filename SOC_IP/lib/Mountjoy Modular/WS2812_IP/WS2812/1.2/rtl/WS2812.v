
/*******************************************************************************
    Verilog netlist generated by IPGEN Lattice Propel (64-bit)
    2.0.2104292220
    Soft IP Version: 1.2
    2021 06 10 09:32:50
*******************************************************************************/
/*******************************************************************************
    Wrapper Module generated per user settings.
*******************************************************************************/
module WS2812 (clk_i, 
        resetn_i, 
        led_ctl_o, 
        apb_penable_i, 
        apb_psel_i, 
        apb_pwrite_i, 
        apb_paddr_i, 
        apb_pwdata_i, 
        apb_prdata_o, 
        apb_pslverr_o, 
        apb_pready_o) ;
    input clk_i ; 
    input resetn_i ; 
    output led_ctl_o ; 
    input apb_penable_i ; 
    input apb_psel_i ; 
    input apb_pwrite_i ; 
    input [5:0] apb_paddr_i ; 
    input [31:0] apb_pwdata_i ; 
    output [31:0] apb_prdata_o ; 
    output apb_pslverr_o ; 
    output apb_pready_o ; 
    WS2812_ipgen_WS2812_module #(.FAMILY("MachXO3LF")) WS2812_module_inst (.clk_i(clk_i), 
                .resetn_i(resetn_i), 
                .led_ctl_o(led_ctl_o), 
                .apb_penable_i(apb_penable_i), 
                .apb_psel_i(apb_psel_i), 
                .apb_pwrite_i(apb_pwrite_i), 
                .apb_paddr_i(apb_paddr_i[5:0]), 
                .apb_pwdata_i(apb_pwdata_i[31:0]), 
                .apb_prdata_o(apb_prdata_o[31:0]), 
                .apb_pslverr_o(apb_pslverr_o), 
                .apb_pready_o(apb_pready_o)) ; 
endmodule



module WS2812_ipgen_WS2812_module (
    input wire clk_i, 
    input wire resetn_i, 
    output wire led_ctl_o, 
    input wire apb_penable_i,  // apb Enable
    input wire apb_psel_i,  // apb Slave select
    input wire apb_pwrite_i,  // apb write 1, read 0
    input wire [5:0] apb_paddr_i, 
    input wire [31:0] apb_pwdata_i, 
    output reg [31:0] apb_prdata_o, 
    output reg apb_pslverr_o,  // apb slave error
    output reg apb_pready_o) ;
    reg [5:0] apb_paddr_r ; 
    reg [31:0] apb_pwdata_r ; 
    // State machine to control APB bus
    reg [2:0] SM_APB ; 
    localparam sm_idle = 3'b000 ; 
    localparam sm_access = 3'b001 ; 
    localparam sm_ready = 3'b010 ; 
    always
        @(posedge clk_i or 
            negedge resetn_i)
        begin
            if ((~resetn_i)) 
                begin
                    SM_APB <=  sm_idle ;
                    apb_prdata_o <=  32'b0 ;
                    apb_pready_o <=  1'b0 ;
                    apb_pslverr_o <=  1'b0 ;
                end
            else
                begin
                    case (SM_APB)
                    sm_idle : 
                        if (apb_psel_i) 
                            begin
                                SM_APB <=  sm_access ;
                                apb_pready_o <=  1'b1 ;
                            end
                    sm_access : 
                        begin
                            apb_pready_o <=  1'b0 ;
                            SM_APB <=  sm_idle ;
                            if (apb_penable_i) 
                                begin
                                    if (apb_pwrite_i) 
                                        begin
                                            apb_paddr_r <=  apb_paddr_i ;
                                            apb_pwdata_r <=  apb_pwdata_i ;
                                        end
                                    else
                                        begin
                                            // address 0 return write address, address 4 return write data
                                            if ((apb_paddr_i == 6'h0)) 
                                                apb_prdata_o <=  apb_paddr_r ;
                                            else
                                                apb_prdata_o <=  apb_pwdata_r ;
                                        end
                                end
                        end
                    sm_ready : 
                        begin
                            SM_APB <=  sm_idle ;
                            apb_pready_o <=  1'b0 ;
                        end
                    endcase 
                end
        end
    assign led_ctl_o = apb_psel_i ; 
endmodule


