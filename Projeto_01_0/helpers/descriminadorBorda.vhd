library IEEE;
use ieee.std_logic_1164.all;

entity descriminadorBorda is
	 generic(
		  DATA_SIZE : natural := 8
	 );
    port(
        DATA_IN  : in std_logic;
		  ENABLE : in std_logic;
		  CLR : in std_logic;
		  CLK : in std_logic;
        DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
	 );
end entity;

architecture comportamento of descriminadorBorda is

	signal key_0_edge : std_logic;
	signal key_0_in : std_logic;
	
begin

KEY0 : entity work.buffer_3_state
			port map (DATA_IN => key_0_in, ENABLE => ENABLE, DATA_OUT => DATA_OUT);
			
EDGE : entity work.edgeDetector
  port map(clk => CLK, entrada => not(DATA_IN), saida => key_0_edge);

FF_KEY_0 : entity work.flipFlop
  port map(DIN => '1', DOUT => key_0_in, ENABLE => '1', RST => CLR, CLK => key_0_edge);
			
			
end architecture;