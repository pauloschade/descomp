library IEEE;
use ieee.std_logic_1164.all;

entity keysController is
	 generic(
		  DATA_SIZE : natural := 8;
		  KEYS_N : natural := 5
	 );
    port(
        DATA_IN  : in std_logic_vector(KEYS_N-1 downto 0) := "00000";
        ADDRESSES  : in std_logic_vector(KEYS_N-1 downto 0);
		  ENABLE : in std_logic;
		  CLR_0 : in std_logic;
		  CLR_1 : in std_logic;
		  CLK : in std_logic;
        DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
	 );
end entity;

architecture comportamento of keysController is

	signal enable_keys : std_logic_vector(KEYS_N-1 downto 0);
	--signal temp_out : std_logic_vector(KEYS_N-1 downto 0);
	
begin

KEY0 : entity work.descriminadorBorda
			port map (DATA_IN => DATA_IN(0), ENABLE => enable_keys(0), CLR => CLR_0, CLK => CLK, DATA_OUT => DATA_OUT);
			
KEY1 : entity work.descriminadorBorda
			port map (DATA_IN => DATA_IN(1), ENABLE => enable_keys(1), CLR => CLR_1, CLK => CLK, DATA_OUT => DATA_OUT);
			
KEY2 : entity work.buffer_3_state
			port map (DATA_IN => DATA_IN(2), ENABLE => enable_keys(2), DATA_OUT => DATA_OUT);
			
KEY3 : entity work.buffer_3_state
			port map (DATA_IN => DATA_IN(3), ENABLE => enable_keys(3), DATA_OUT => DATA_OUT);
			
RESET_KEY : entity work.buffer_3_state
			port map (DATA_IN => DATA_IN(4), ENABLE => enable_keys(4), DATA_OUT => DATA_OUT);
			

enable_keys(0) <= ENABLE and ADDRESSES(0);
enable_keys(1) <= ENABLE and ADDRESSES(1);
enable_keys(2) <= ENABLE and ADDRESSES(2);
enable_keys(3) <= ENABLE and ADDRESSES(3);
enable_keys(4) <= ENABLE and ADDRESSES(4);
			
end architecture;