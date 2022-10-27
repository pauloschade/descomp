library IEEE;
use ieee.std_logic_1164.all;

entity buffer_3_state_8portas is
    port(
        DATA_IN  : in std_logic_vector(7 downto 0);
        ENABLE : in std_logic;
        DATA_OUT    : out std_logic_vector(7 downto 0));
end entity;

architecture comportamento of buffer_3_state_8portas is
begin
    -- A DATA_OUT esta ativa quando o ENABLE = 1.
    DATA_OUT <= "ZZZZZZZZ" when (ENABLE = '0') else DATA_IN;
end architecture;