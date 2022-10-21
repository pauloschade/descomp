library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( DATA_SIZE : natural := 4 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(1 downto 0);
      saida:    out STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
		flag:		 out std_logic
    );
end entity;

architecture comportamento of ULASomaSub is

	constant selector_sum  : std_logic_vector(1 downto 0) := "00";
	constant selector_sub  : std_logic_vector(1 downto 0) := "01";
	constant selector_pass : std_logic_vector(1 downto 0) := "10";
	constant selector_and  : std_logic_vector(1 downto 0) := "11";
	
   signal soma :      STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
   signal sub  : STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
	signal pass : STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
	signal andb : STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
	
    begin
      soma <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      sub  <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
		andb <= entradaA and entradaB;
		pass <= entradaB;
		
      saida <= soma when seletor = selector_sum else
					sub when seletor = selector_sub else
					andb when seletor = selector_and else
					pass;
		flag <= not(sub(0) or sub(1) or sub(2) or sub(3) or sub(4) or sub(5) or sub(6) or sub(7));
					
end architecture;