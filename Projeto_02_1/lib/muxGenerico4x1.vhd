library ieee;
use ieee.std_logic_1164.all;

entity muxGenerico4x1 is
  -- Total de bits das entradas e saidas
  generic (DATA_SIZE : natural := 8);
  port (
    IN_A, IN_B, IN_C : in std_logic_vector((DATA_SIZE-1) downto 0);
	 IN_D : in std_logic_vector((DATA_SIZE-1) downto 0);
    SELECTOR : in std_logic_vector(1 downto 0);
    DATA_OUT : out std_logic_vector((DATA_SIZE-1) downto 0)
  );
end entity;

architecture comportamento of muxGenerico4x1 is
  begin
    DATA_OUT  <=  IN_A when (SELECTOR = "00") else 
				      IN_B when (SELECTOR = "01") else
				      IN_C when (SELECTOR = "10") else
				      IN_A;
end architecture;