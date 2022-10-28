library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic 
	 ( 
		DATA_SIZE : natural := 4;
		SELECTOR_SIZE : natural := 6
	 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR((SELECTOR_SIZE-1) downto 0);
      saida:    out STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0)
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		
      saida <= soma when (seletor = 6x"20") else 
					subtracao when (seletor = 6x"22") else 
					entradaA;
end architecture;