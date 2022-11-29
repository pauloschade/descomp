library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;          -- Biblioteca IEEE para funções aritméticas

entity somadorGenerico is
    generic
    (
        DATA_SIZE : natural := 32
    );
    port
    (
        IN_A, IN_B: in STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
        DATA_OUT:  out STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0)
    );
end entity;

architecture comportamento of somadorGenerico is
    begin
        DATA_OUT <= STD_LOGIC_VECTOR(unsigned(IN_A) + unsigned(IN_B));
end architecture;