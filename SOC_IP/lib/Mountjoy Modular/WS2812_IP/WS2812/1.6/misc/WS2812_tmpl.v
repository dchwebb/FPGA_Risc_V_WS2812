    WS2812 __(.clk_i( ),
        .resetn_i( ),
        .led_ctl_o( ),
        .debug_o( ),
        .apb_penable_i( ),
        .apb_psel_i( ),
        .apb_pwrite_i( ),
        .apb_paddr_i( ),
        .apb_pwdata_i( ),
        .apb_prdata_o( ),
        .apb_pslverr_o( ),
        .apb_pready_o( ),
        .int_o( ));
