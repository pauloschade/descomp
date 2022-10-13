library IEEE;
use ieee.std_logic_1164.all;

entity displaysController is
	 generic 
	 (
		 DATA_SIZE : natural := 4;
		 HEX_SIZE : natural := 7;
		 DISPLAYS_N : natural := 6
	 );
    port
    (
		DATA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
		ADDRESSES : in  std_logic_vector(DISPLAYS_N-1 downto 0);
		ENABLE : in std_logic;
		CLK : in std_logic;
	   HEX0 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	   HEX1 : out std_logic_vector(HEX_SIZE-1 downto 0);
	   HEX2 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	   HEX3 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	   HEX4 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	   HEX5 : out std_logic_vector(HEX_SIZE-1 downto 0)
    );
end entity;

architecture comportamento of displaysController is

	signal enable_displays : std_logic_vector(DISPLAYS_N-1 downto 0);
  
begin

disp_HEX0: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(0), CLK => CLK, HEX_OUT => HEX0);

disp_HEX1: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(1), CLK => CLK, HEX_OUT => HEX1);

disp_HEX2: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(2), CLK => CLK, HEX_OUT => HEX2);
			
disp_HEX3: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(3), CLK => CLK, HEX_OUT => HEX3);

disp_HEX4: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(4), CLK => CLK, HEX_OUT => HEX4);
			
disp_HEX5: entity work.display7seg
			port map (DATA_IN => DATA_IN, ENABLE => enable_displays(5), CLK => CLK, HEX_OUT => HEX5);

			
-------------------- CONTROLLER USAGE ------------------------
enable_displays(0) <= ADDRESSES(0) and ENABLE;
enable_displays(1) <= ADDRESSES(1) and ENABLE;
enable_displays(2) <= ADDRESSES(2) and ENABLE;
enable_displays(3) <= ADDRESSES(3) and ENABLE;
enable_displays(4) <= ADDRESSES(4) and ENABLE;	
enable_displays(5) <= ADDRESSES(5) and ENABLE;
--------------------------------------------------------------


end architecture;