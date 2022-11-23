library ieee;
use ieee.std_logic_1164.all;

entity MUX4x1 is
  port (
    IN_A, IN_B, IN_C, IN_D : in std_logic;
    seletor_MUX : in std_logic_vector(1 downto 0);
    saida_MUX : out std_logic
  );
end entity;

architecture comportamento of MUX4x1 is
  begin
    saida_MUX <= IN_B when (seletor_MUX = "01") else 
					  IN_C when (seletor_MUX = "10") else 
					  IN_D when (seletor_MUX = "11") else 
					  IN_A;
end architecture;