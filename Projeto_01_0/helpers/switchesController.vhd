library IEEE;
use ieee.std_logic_1164.all;

entity switchesController is
	 generic(
		  DATA_SIZE : natural := 8;
		  SW_N : natural := 10;
		  SW_GROUPS_N : natural := 3
		  
	 );
    port(
        DATA_IN  : in std_logic_vector(SW_N-1 downto 0) := "1010100101";
        ADDRESSES  : in std_logic_vector(SW_GROUPS_N-1 downto 0);
		  ENABLE : in std_logic;
        DATA_OUT    : out std_logic_vector(DATA_SIZE-1 downto 0)
	 );
end entity;

architecture comportamento of switchesController is
	
	signal enable_sw : std_logic_vector(SW_GROUPS_N-1 downto 0);
	signal sw_group_0_data : std_logic_vector(DATA_SIZE-1 downto 0);
	signal sw_8_data : std_logic;
	signal sw_9_data : std_logic;
	--signal temp_out : std_logic_vector(SW_N-1 downto 0);
	
begin

SW07 : entity work.buffer_3_state_8portas
			port map (DATA_IN => sw_group_0_data, ENABLE => enable_sw(0), DATA_OUT => DATA_OUT);
			
SW8 : entity work.buffer_3_state
			port map (DATA_IN => sw_8_data, ENABLE => enable_sw(1), DATA_OUT => DATA_OUT);
			
SW9 : entity work.buffer_3_state
			port map (DATA_IN => sw_9_data, ENABLE => enable_sw(2), DATA_OUT => DATA_OUT);
			

enable_sw(0) <= ENABLE and ADDRESSES(0);
enable_sw(1) <= ENABLE and ADDRESSES(1);
enable_sw(2) <= ENABLE and ADDRESSES(2);

sw_group_0_data <= DATA_IN(SW_N-SW_GROUPS_N downto 0);
sw_8_data <= DATA_IN(8);
sw_9_data <= DATA_IN(9);
			
end architecture;