
module WS2812_module #(parameter FAMILY = "LIFCL", 
        parameter LED_COUNT = 3, 
        parameter CLOCK_FREQUENCY = 38000000) (
    input wire clk_i, 
    input wire resetn_i, 
    output reg led_ctl_o,  // LED control signal
    output reg int_o,  // Interrupt
    output wire debug_o, 
    input wire apb_penable_i,  // apb Enable
    input wire apb_psel_i,  // apb Slave select
    input wire apb_pwrite_i,  // apb write 1, read 0
    input wire [5:0] apb_paddr_i, 
    input wire [31:0] apb_pwdata_i, 
    output reg [31:0] apb_prdata_o, 
    output reg apb_pslverr_o,  // apb slave error
    output reg apb_pready_o) ;
    reg [31:0] status_register ; 
    reg auto_send ; 
    reg [7:0] colour_register ; // Stores the current led number to retrieve colour for
    reg [23:0] led_colour [(LED_COUNT - 1):0] ; 
    reg trigger_transmit ; 
    reg led_sending = 1'b0 ; 
    reg [8:0] clk_counter ; 
    reg [8:0] led_counter ; 
    reg [8:0] led_bit_counter ; 
    reg [8:0] clock_counter ; 
    // Each pulse must be around .42us (= 2.38MHz); 3 pulses needed for each bit: 3 * .42 = 1.26us
    localparam [8:0] CLOCK_DIVIDER = (CLOCK_FREQUENCY / 2380000) ; 
    // Register map
    localparam STATUS_REG = 6'h0 ; // 0x0	STATUS		sending	[0]
    localparam CONTROL_REG = 6'h4 ; // 0x4	CONTROL		auto_send[0]		send		[1]
    localparam COLOUR_WR_REG = 6'h8 ; // 0x8	COLOUR_WR	colour	[23:0]	led_set	[31:24]
    localparam COLOUR_RD_REG = 6'hC ; // 0x12	COLOUR_RD	colour	[23:0]	led_set	[31:24]
    // State machine to control APB bus
    reg [1:0] SM_APB ; 
    localparam sm_idle = 2'b00 ; 
    localparam sm_access = 2'b01 ; 
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
                    status_register <=  32'h0 ;
                    auto_send <=  1'b1 ;
                    trigger_transmit <=  1'b0 ;
                end
            else
                begin
                    case (SM_APB)
                    sm_idle : 
                        begin
                            if (led_sending) 
                                trigger_transmit <=  1'b0 ;
                            if ((apb_psel_i && apb_penable_i)) 
                                begin
                                    SM_APB <=  sm_access ;
                                    apb_pready_o <=  1'b1 ;
                                    if (apb_pwrite_i) 
                                        begin
                                            // Top 8 bits are the led to read - remaining data is redundant
                                            case (apb_paddr_i)
                                            STATUS_REG : 
                                                apb_pslverr_o <=  1'b1 ;
                                            CONTROL_REG : 
                                                // Status register is read-only; return error
                                                begin
                                                    auto_send <=  apb_pwdata_i[0] ;
                                                    if (apb_pwdata_i[1]) 
                                                        trigger_transmit <=  1'b1 ;
                                                end
                                            COLOUR_WR_REG : 
                                                begin
                                                    trigger_transmit <=  auto_send ;// Trigger to start resending data is auto send is configured
                                                    led_colour[apb_pwdata_i[31:24]] <=  apb_pwdata_i[23:0] ;// Top 8 bits are the led to set, lower 24 bits are the colour 
                                                end
                                            COLOUR_RD_REG : 
                                                colour_register <=  apb_pwdata_i[31:24] ;
                                            endcase 
                                        end
                                    else
                                        begin
                                            // Return the colour of the led number specified using the top 8 bits of this register
                                            case (apb_paddr_i)
                                            STATUS_REG : 
                                                apb_prdata_o <=  {31'b0,
                                                        led_sending} ;
                                            CONTROL_REG : 
                                                apb_prdata_o <=  {31'b0,
                                                        auto_send} ;
                                            COLOUR_WR_REG : 
                                                apb_pslverr_o <=  1'b1 ;
                                            COLOUR_RD_REG : 
                                                // Colour write is write only; return error
                                                apb_prdata_o <=  {colour_register,
                                                        led_colour[colour_register]} ;
                                            endcase 
                                        end
                                end
                        end
                    sm_access : 
                        begin
                            apb_pslverr_o <=  1'b0 ;
                            apb_pready_o <=  1'b0 ;
                            SM_APB <=  sm_idle ;
                        end
                    endcase 
                end
        end
    // LED sending state machine
    reg [2:0] SM_Led ; 
    localparam sm_led_idle = 3'b000 ; 
    localparam sm_led_phase1 = 3'b001 ; // First phase of output bit (always 1)
    localparam sm_led_phase2 = 3'b010 ; // Second phase (1 or 0)
    localparam sm_led_phase3 = 3'b011 ; // Third phase (always 0)
    localparam sm_led_reset = 3'b100 ; // Wait until ready to send again
    // Main LED output loop
    always
        @(posedge clk_i or 
            negedge resetn_i)
        begin
            if ((~resetn_i)) 
                begin
                    led_ctl_o <=  1'b0 ;
                    led_counter <=  8'b0 ;
                    led_bit_counter <=  8'b0 ;
                    clock_counter <=  CLOCK_DIVIDER ;
                    int_o <=  1'b0 ;
                    led_sending <=  1'b0 ;
                    SM_Led <=  sm_led_idle ;
                end
            else
                begin
                    int_o <=  1'b0 ;// clear interrupt
                    if (((SM_Led == sm_led_idle) && trigger_transmit)) 
                        begin
                            led_bit_counter <=  8'd23 ;
                            led_counter <=  8'b0 ;
                            led_ctl_o <=  1'b1 ;
                            SM_Led <=  sm_led_phase2 ;
                            clock_counter <=  CLOCK_DIVIDER ;
                            led_sending <=  1'b1 ;
                        end
                    else
                        if (led_sending) 
                            begin
                                if ((clock_counter == 8'h0)) 
                                    begin
                                        clock_counter <=  CLOCK_DIVIDER ;
                                        case (SM_Led)
                                        sm_led_phase1 : 
                                            begin
                                                led_ctl_o <=  1'b1 ;
                                                SM_Led <=  sm_led_phase2 ;
                                            end
                                        sm_led_phase2 : 
                                            begin
                                                led_ctl_o <=  led_colour[led_counter][led_bit_counter] ;// Output the current bit of the current Led
                                                led_bit_counter <=  (led_bit_counter - 8'b1) ;
                                                SM_Led <=  sm_led_phase3 ;
                                                if ((led_bit_counter <= 8'h0)) 
                                                    begin
                                                        if ((led_counter == (LED_COUNT - 1'b1))) 
                                                            begin
                                                                // all LEDs have been transmitted
                                                                SM_Led <=  sm_led_reset ;
                                                            end
                                                        else
                                                            begin
                                                                led_bit_counter <=  8'd23 ;
                                                                led_counter <=  (led_counter + 8'b1) ;// Increment to the next Led
                                                            end
                                                    end
                                            end
                                        sm_led_phase3 : 
                                            begin
                                                led_ctl_o <=  1'b0 ;
                                                SM_Led <=  sm_led_phase1 ;
                                            end
                                        sm_led_reset : 
                                            begin
                                                led_ctl_o <=  1'b0 ;
                                                led_counter <=  (led_counter + 1'b1) ;
                                                if ((led_counter == 250)) 
                                                    begin
                                                        // 120 = 50uS (minimum gap from datasheet, but in practice needs to be longer)
                                                        led_sending <=  1'b0 ;
                                                        int_o <=  1'b1 ;// Fire interrupt
                                                        SM_Led <=  sm_led_idle ;
                                                    end
                                            end
                                        endcase 
                                    end
                                else
                                    begin
                                        clock_counter <=  (clock_counter - 8'h1) ;
                                    end
                            end
                end
        end
    assign debug_o = apb_penable_i ; 
endmodule


