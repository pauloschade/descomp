library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logicaDesvio is
	generic (
         CONTROL_SIZE: natural := 8;
			SELECTOR_SIZE: natural := 2
  );
    port (
			control : in std_logic_vector(CONTROL_SIZE-1 downto 0);
			selector : out std_logic_vector(SELECTOR_SIZE-1 downto 0)
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