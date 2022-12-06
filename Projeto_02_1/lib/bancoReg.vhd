library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apendice C (Register Files) do COD (Patterson & Hennessy).

entity bancoReg is
    generic
    (
        DATA_SIZE        : natural := 32;
        REG_ADDR_SIZE : natural := 5   --Resulta em 2^5=32 posicoes
    );
-- Leitura de 2 registradores e escrita em 1 registrador simultaneamente.
    port
    (
        CLK        : in std_logic;
--
        ADDR_A       : in std_logic_vector((REG_ADDR_SIZE-1) downto 0);
        ADDR_B       : in std_logic_vector((REG_ADDR_SIZE-1) downto 0);
        ADDR_C       : in std_logic_vector((REG_ADDR_SIZE-1) downto 0);
--
        DATA_WR      : in std_logic_vector((DATA_SIZE-1) downto 0);
--
        ENABLE_WR      : in std_logic;
        OUT_A          : out std_logic_vector((DATA_SIZE -1) downto 0);
        OUT_B          : out std_logic_vector((DATA_SIZE -1) downto 0)
    );
end entity;

architecture comportamento of bancoReg is

    subtype palavra_t is std_logic_vector((DATA_SIZE-1) downto 0);
    type memoria_t is array(2**REG_ADDR_SIZE-1 downto 0) of palavra_t;

function initMemory
        return memoria_t is variable tmp : memoria_t := (others => (others => '0'));
  begin
        -- Inicializa os endereços:
        tmp(0) := x"AAAAAAAA";  -- Nao deve ter efeito.
        tmp(8)  := 32x"00";  -- $t0 = 0x00
        tmp(9)  := 32x"0A";  -- $t1 = 0x0A
        tmp(10) := 32x"0B";  -- $t2 = 0x0B
        tmp(11) := 32x"0C";  -- $t3 = 0x0C
        tmp(12) := 32x"0D";  -- $t4 = 0x0D
        tmp(13) := 32x"16";  -- $t5 = 0x16
        return tmp;
    end initMemory;

    -- Declaracao dos registradores:
    shared variable registrador : memoria_t := initMemory;
    constant zero : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');
begin
    process(CLK) is
    begin
        if (rising_edge(CLK)) then
		  --if (falling_edge(CLK)) then
            if (ENABLE_WR = '1') then
                registrador(to_integer(unsigned(ADDR_C))) := DATA_WR;
            end if;
        end if;
    end process;
    -- Se endereco = 0 : retorna ZERO
    OUT_B <= zero when to_integer(unsigned(ADDR_B)) = to_integer(unsigned(zero)) else
				 DATA_WR when (ADDR_C = ADDR_B) else
				 registrador(to_integer(unsigned(ADDR_B)));
				 
    OUT_A <= zero when to_integer(unsigned(ADDR_A)) = to_integer(unsigned(zero)) else
				 DATA_WR when (ADDR_C = ADDR_A) else
				 registrador(to_integer(unsigned(ADDR_A)));
end architecture;