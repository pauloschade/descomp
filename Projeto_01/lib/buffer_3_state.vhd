library IEEE;
use ieee.std_logic_1164.all;

entity buffer_3_state is
    port(
        DATA_IN  : in std_logic;
        ENABLE : in std_logic;
        DATA_OUT    : out std_logic_vector(7 downto 0)
	);
end entity;

architecture comportamento of buffer_3_state is
begin
    -- A DATA_OUT esta ativa quando o ENABLE = 1.
    DATA_OUT <= "ZZZZZZZZ" when (ENABLE = '0') else "0000000" & DATA_IN;
end architecture;