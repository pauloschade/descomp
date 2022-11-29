library ieee;
use ieee.std_logic_1164.all;

entity MUX2x1 is
  -- Total de bits das entradas e saidas
  port (
    IN_A, IN_B : in std_logic;
    SELECTOR : in std_logic;
    DATA_OUT : out std_logic
  );
end entity;

architecture comportamento of MUX2x1 is
  begin
    DATA_OUT <= IN_B when (SELECTOR = '1') else IN_A;
end architecture;