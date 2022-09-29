library IEEE;
use ieee.std_logic_1164.all;

entity display7Seg is
	 generic 
	 (
	 	 DATA_SIZE : natural := 4
	 );
    port
    (
		DATA_IN : in  std_logic_vector(DATA_SIZE-1 downto 0);
		ENABLE : in std_logic;
		CLK : in std_logic
    );
end entity;

architecture comportamento of display7Seg is

  signal reg_out : std_logic_vector(DATA_SIZE-1 downto 0);
  signal out_7seg : std_logic_vector(6 downto 0);
  
begin

REG : entity work.registradorGenerico generic map (DATA_SIZE => DATA_SIZE)
		port map (DIN => DATA_IN, DOUT => reg_out, ENABLE => ENABLE, CLK => CLK);
		
CONVERTER : entity work.conversorHex7Seg
				port map(dadoHex => reg_out, saida7seg => out_7seg);
	
end architecture;