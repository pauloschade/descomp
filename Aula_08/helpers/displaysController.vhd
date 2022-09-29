library IEEE;
use ieee.std_logic_1164.all;

entity displaysController is
	 generic 
	 (
		 DATA_SIZE : natural := 4;
		 DISPLAYS_N : natural := 6
	 );
    port
    (
		DATA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
		ADDRESSES : in  std_logic_vector(DISPLAYS_N-1 downto 0);
		ENABLE : in std_logic;
		CLK : in std_logic;
		DISPLAYS_ON : out std_logic_vector(DISPLAYS_N-1 downto 0)
    );
end entity;

architecture comportamento of displaysController is

	signal enable_displays : std_logic_vector(DISPLAYS_N-1 downto 0);
  
begin

HEX0: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(0), CLK => CLK);

HEX1: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(1), CLK => CLK);

HEX2: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(2), CLK => CLK);
			
HEX3: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(3), CLK => CLK);

HEX4: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(4), CLK => CLK);
			
HEX5: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(5), CLK => CLK);

			
-------------------- CONTROLLER USAGE ------------------------
enable_displays(0) <= ADDRESSES(0) and ENABLE;
enable_displays(1) <= ADDRESSES(1) and ENABLE;
enable_displays(2) <= ADDRESSES(2) and ENABLE;
enable_displays(3) <= ADDRESSES(3) and ENABLE;
enable_displays(4) <= ADDRESSES(4) and ENABLE;	
enable_displays(5) <= ADDRESSES(5) and ENABLE;
--------------------------------------------------------------


-------------------- OUTPUT ------------------------
DISPLAYS_ON <= enable_displays;
-----------------------------------------------------




end architecture;