library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logicaDesvio is
	generic (
         controlSize: natural := 8;
			selectorSize: natural := 2
  );
    port (
			control : in std_logic_vector(controlSize-1 downto 0);
			selector : out std_logic_vector(selectorSize-1 downto 0)
	 );
end entity;

architecture comportamento of logicaDesvio is

	 alias JMP : std_logic is control(4);
	 alias RET : std_logic is control(3);
	 alias JSR : std_logic is control(2);
	 alias JEQ : std_logic is control(1);
	 alias flagEqual : std_logic is control(0);
	 
    begin
	 
	 selector(0) <= JMP or (JEQ and flagEqual) or (JSR);
	 selector(1) <= RET;
					
end architecture;