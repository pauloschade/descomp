library ieee;
use ieee.std_logic_1164.all;

entity generic_MUX_2x1 is
  -- Total de bits das entradas e saidas
  generic ( DATA_SIZE : natural := 8);
  port (
    IN_A, IN_B : in std_logic_vector((DATA_SIZE-1) downto 0);
    MUX_SELECTOR : in std_logic;
    DATA_OUT : out std_logic_vector((DATA_SIZE-1) downto 0)
  );
end entity;

architecture comportamento of generic_MUX_2x1 is
  begin
    DATA_OUT <= IN_B when (MUX_SELECTOR = '1') else IN_A;
end architecture;