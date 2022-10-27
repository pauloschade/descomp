library ieee;
use ieee.std_logic_1164.all;

entity muxGenerico4x1 is
  -- Total de bits das entradas e saidas
  generic (DATA_SIZE : natural := 8);
  port (
    entrada_0, entrada_1, entrada_2 : in std_logic_vector((DATA_SIZE-1) downto 0);
    seletor_MUX : in std_logic_vector(1 downto 0);
    saida_MUX : out std_logic_vector((DATA_SIZE-1) downto 0)
  );
end entity;

architecture comportamento of muxGenerico4x1 is
  begin
    saida_MUX  <= entrada_0 when (seletor_MUX = "00") else 
				      entrada_1 when (seletor_MUX = "01") else
				      entrada_2 when (seletor_MUX = "10") else
				      entrada_0;
end architecture;