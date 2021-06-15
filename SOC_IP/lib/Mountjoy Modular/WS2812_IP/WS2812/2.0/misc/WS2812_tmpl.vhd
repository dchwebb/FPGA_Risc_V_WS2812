component WS2812 is
    port(
        clk_i: in std_logic;
        resetn_i: in std_logic;
        led_ctl_o: out std_logic;
        debug_o: out std_logic;
        apb_penable_i: in std_logic;
        apb_psel_i: in std_logic;
        apb_pwrite_i: in std_logic;
        apb_paddr_i: in std_logic_vector(5 downto 0);
        apb_pwdata_i: in std_logic_vector(31 downto 0);
        apb_prdata_o: out std_logic_vector(31 downto 0);
        apb_pslverr_o: out std_logic;
        apb_pready_o: out std_logic;
        int_o: out std_logic
    );
end component;

__: WS2812 port map(
    clk_i=>,
    resetn_i=>,
    led_ctl_o=>,
    debug_o=>,
    apb_penable_i=>,
    apb_psel_i=>,
    apb_pwrite_i=>,
    apb_paddr_i=>,
    apb_pwdata_i=>,
    apb_prdata_o=>,
    apb_pslverr_o=>,
    apb_pready_o=>,
    int_o=>
);
