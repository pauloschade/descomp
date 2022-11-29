library IEEE;
use ieee.std_logic_1164.all;

entity displaysController is
	 generic 
	 (
		 DATA_SIZE : natural := 4;
		 HEX_SIZE : natural := 7;
		 LED_N : natural := 4;
		 DISPLAYS_N : natural := 6
	 );
    port
    (
		DATA_IN : in std_logic_vector(DATA_SIZE-1 downto 0);
		
		LED_0_3 : out std_logic_vector(LED_N-1 downto 0); 
		LED_4_7 : out std_logic_vector(LED_N-1 downto 0); 
		
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

CONVERTER_0 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(3 downto 0), saida7seg => HEX0);

CONVERTER_1 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(7 downto 4), saida7seg => HEX1);

CONVERTER_2 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(11 downto 8), saida7seg => HEX2);
			
CONVERTER_3 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(15 downto 12), saida7seg => HEX3);

CONVERTER_4 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(19 downto 16), saida7seg => HEX4);
			
CONVERTER_5 : entity work.conversorHex7Seg
				port map(dadoHex => DATA_IN(23 downto 20), saida7seg => HEX5);
				
LED_0_3 <= DATA_IN(27 downto 24);
LED_4_7 <= DATA_IN(31 downto 28);


end architecture;