library ieee;
use ieee.std_logic_1164.all;

entity simplemux is
  port (
    IN_A, IN_B : in std_logic;
    seletor_MUX : in std_logic;
    saida_MUX : out std_logic
  );
end entity;

architecture comportamento of simplemux is
  begin
    saida_MUX <= IN_B when (seletor_MUX = '1') else IN_A;
end architecture;