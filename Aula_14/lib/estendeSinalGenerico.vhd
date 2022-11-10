library ieee;
use ieee.std_logic_1164.all;

entity estendeSinalGenerico is
    generic
    (
        DATA_IN_SIZE : natural  :=    16;
        DATA_OUT_SIZE   : natural  :=    32
    );
    port
    (
        -- Input ports
        DATA_IN : in  std_logic_vector(DATA_IN_SIZE-1 downto 0);
        -- Output ports
        DATA_OUT: out std_logic_vector(DATA_OUT_SIZE-1 downto 0)
    );
end entity;

architecture comportamento of estendeSinalGenerico is
begin

    DATA_OUT <= (DATA_OUT_SIZE-1 downto DATA_IN_SIZE => DATA_IN(DATA_IN_SIZE-1) ) & DATA_IN;

end architecture;