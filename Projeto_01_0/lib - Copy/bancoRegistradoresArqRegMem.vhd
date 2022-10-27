library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoRegistradoresArqRegMem is
    generic
    (
        DATA_SIZE        : natural := 8;
        REGS_N : natural := 3   --Resulta em 2^3=8 posicoes
    );

-- Leitura e escrita de um registrador.
    port
    (
        CLK        : in std_logic;
        ADDR       : in std_logic_vector((REGS_N-1) downto 0);
        DATA_IN    : in std_logic_vector((DATA_SIZE-1) downto 0);
        ENABLE: in std_logic := '0';
        DATA_OUT          : out std_logic_vector((DATA_SIZE -1) downto 0)
    );
end entity;

architecture comportamento of bancoRegistradoresArqRegMem is

    subtype palavra_t is std_logic_vector((DATA_SIZE-1) downto 0);
    type memoria_t is array(2**REGS_N-1 downto 0) of palavra_t;

    -- Declaracao dos registradores:
    shared variable registrador : memoria_t;

begin
    process(CLK) is
    begin
        if (rising_edge(CLK)) then
            if (ENABLE = '1') then
                registrador(to_integer(unsigned(ADDR))) := DATA_IN;
            end if;
        end if;
    end process;
    DATA_OUT <= registrador(to_integer(unsigned(ADDR)));
end architecture;