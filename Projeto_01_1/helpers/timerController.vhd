library IEEE;
use ieee.std_logic_1164.all;

entity timerController is
	 generic(
		 DATA_SIZE : natural := 8
		  
	 );
    port(
		CLK      :   in std_logic;
      ENABLE   :   in std_logic;
      CLR : in std_logic;
		SELECTOR : in std_logic_vector(1 downto 0);
      DATA_OUT :   out std_logic_vector(DATA_SIZE-1 downto 0)
	 );
end entity;

architecture comportamento of timerController is
	
	signal data_out_1sec : std_logic;
	signal data_out_faster : std_logic;
	signal data_out_super : std_logic;
	signal data_out_blaster : std_logic;
	signal ula_out : std_logic;
	signal reg_data : std_logic;
	--signal temp_out : std_logic_vector(SW_N-1 downto 0);
	
begin
			
baseTempo_1SEC: entity work.divisorGenerico generic map (divisor => 25000000)   -- divide por 50MH.
           port map (CLK => CLK, saida_clk => data_out_1sec);
			  
baseTempo_FASTER: entity work.divisorGenerico generic map (divisor => 250000)   -- divide por 0.5MH.
           port map (CLK => CLK, saida_clk => data_out_faster);
			  
baseTempo_SUPER: entity work.divisorGenerico generic map (divisor => 25000)   -- divide por 50kH.
           port map (CLK => CLK, saida_clk => data_out_super);
			  
baseTempo_BLASTER: entity work.divisorGenerico generic map (divisor => 2500)   -- divide por 0.5kH.
           port map (CLK => CLK, saida_clk => data_out_blaster);

MUX_TEMPO :  entity work.simplemux
			port map(
				IN_A => data_out_1sec, 
				IN_B => data_out_faster,
				IN_C => data_out_super,
				IN_D => data_out_blaster,
				seletor_MUX => SELECTOR,
				saida_MUX => ula_out
	);
			
registraUmSegundo: entity work.flipFlop
   port map (
				DIN => '1', DOUT => reg_data,
				ENABLE => '1', CLK => ula_out,
				RST => CLR
	);
			
buf : entity work.buffer_3_state
			port map (DATA_IN => reg_data, ENABLE => ENABLE, DATA_OUT => DATA_OUT);
			
end architecture;
