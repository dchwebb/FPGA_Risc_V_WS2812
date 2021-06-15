component ahbl0 is
    port(
        ahbl_hclk_i: in std_logic;
        ahbl_hresetn_i: in std_logic;
        ahbl_m01_hready_mstr_i: in std_logic_vector(0 to 0);
        ahbl_m01_hresp_mstr_i: in std_logic_vector(0 to 0);
        ahbl_m01_hrdata_mstr_i: in std_logic_vector(31 downto 0);
        ahbl_m01_hsel_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m01_haddr_mstr_o: out std_logic_vector(31 downto 0);
        ahbl_m01_hburst_mstr_o: out std_logic_vector(2 downto 0);
        ahbl_m01_hsize_mstr_o: out std_logic_vector(2 downto 0);
        ahbl_m01_hmastlock_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m01_hprot_mstr_o: out std_logic_vector(3 downto 0);
        ahbl_m01_htrans_mstr_o: out std_logic_vector(1 downto 0);
        ahbl_m01_hwdata_mstr_o: out std_logic_vector(31 downto 0);
        ahbl_m01_hwrite_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m01_hready_mstr_o: out std_logic_vector(0 to 0);
        ahbl_s00_hsel_slv_i: in std_logic_vector(0 to 0);
        ahbl_s00_haddr_slv_i: in std_logic_vector(31 downto 0);
        ahbl_s00_hburst_slv_i: in std_logic_vector(2 downto 0);
        ahbl_s00_hsize_slv_i: in std_logic_vector(2 downto 0);
        ahbl_s00_hmastlock_slv_i: in std_logic_vector(0 to 0);
        ahbl_s00_hprot_slv_i: in std_logic_vector(3 downto 0);
        ahbl_s00_htrans_slv_i: in std_logic_vector(1 downto 0);
        ahbl_s00_hwdata_slv_i: in std_logic_vector(31 downto 0);
        ahbl_s00_hwrite_slv_i: in std_logic_vector(0 to 0);
        ahbl_s00_hready_slv_i: in std_logic_vector(0 to 0);
        ahbl_s00_hreadyout_slv_o: out std_logic_vector(0 to 0);
        ahbl_s00_hresp_slv_o: out std_logic_vector(0 to 0);
        ahbl_s00_hrdata_slv_o: out std_logic_vector(31 downto 0);
        ahbl_m00_hready_mstr_i: in std_logic_vector(0 to 0);
        ahbl_m00_hresp_mstr_i: in std_logic_vector(0 to 0);
        ahbl_m00_hrdata_mstr_i: in std_logic_vector(31 downto 0);
        ahbl_m00_hsel_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m00_haddr_mstr_o: out std_logic_vector(31 downto 0);
        ahbl_m00_hburst_mstr_o: out std_logic_vector(2 downto 0);
        ahbl_m00_hsize_mstr_o: out std_logic_vector(2 downto 0);
        ahbl_m00_hmastlock_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m00_hprot_mstr_o: out std_logic_vector(3 downto 0);
        ahbl_m00_htrans_mstr_o: out std_logic_vector(1 downto 0);
        ahbl_m00_hwdata_mstr_o: out std_logic_vector(31 downto 0);
        ahbl_m00_hwrite_mstr_o: out std_logic_vector(0 to 0);
        ahbl_m00_hready_mstr_o: out std_logic_vector(0 to 0)
    );
end component;

__: ahbl0 port map(
    ahbl_hclk_i=>,
    ahbl_hresetn_i=>,
    ahbl_m01_hready_mstr_i=>,
    ahbl_m01_hresp_mstr_i=>,
    ahbl_m01_hrdata_mstr_i=>,
    ahbl_m01_hsel_mstr_o=>,
    ahbl_m01_haddr_mstr_o=>,
    ahbl_m01_hburst_mstr_o=>,
    ahbl_m01_hsize_mstr_o=>,
    ahbl_m01_hmastlock_mstr_o=>,
    ahbl_m01_hprot_mstr_o=>,
    ahbl_m01_htrans_mstr_o=>,
    ahbl_m01_hwdata_mstr_o=>,
    ahbl_m01_hwrite_mstr_o=>,
    ahbl_m01_hready_mstr_o=>,
    ahbl_s00_hsel_slv_i=>,
    ahbl_s00_haddr_slv_i=>,
    ahbl_s00_hburst_slv_i=>,
    ahbl_s00_hsize_slv_i=>,
    ahbl_s00_hmastlock_slv_i=>,
    ahbl_s00_hprot_slv_i=>,
    ahbl_s00_htrans_slv_i=>,
    ahbl_s00_hwdata_slv_i=>,
    ahbl_s00_hwrite_slv_i=>,
    ahbl_s00_hready_slv_i=>,
    ahbl_s00_hreadyout_slv_o=>,
    ahbl_s00_hresp_slv_o=>,
    ahbl_s00_hrdata_slv_o=>,
    ahbl_m00_hready_mstr_i=>,
    ahbl_m00_hresp_mstr_i=>,
    ahbl_m00_hrdata_mstr_i=>,
    ahbl_m00_hsel_mstr_o=>,
    ahbl_m00_haddr_mstr_o=>,
    ahbl_m00_hburst_mstr_o=>,
    ahbl_m00_hsize_mstr_o=>,
    ahbl_m00_hmastlock_mstr_o=>,
    ahbl_m00_hprot_mstr_o=>,
    ahbl_m00_htrans_mstr_o=>,
    ahbl_m00_hwdata_mstr_o=>,
    ahbl_m00_hwrite_mstr_o=>,
    ahbl_m00_hready_mstr_o=>
);
