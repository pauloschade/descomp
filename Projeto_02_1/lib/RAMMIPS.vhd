library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAMMIPS IS
   generic (
          DATA_SIZE: natural := 32;
          ADDRESS_SIZE: natural := 32;
          MEMORY_SIZE:  natural := 6 );   -- 64 posicoes de 32 bits cada
   port ( clk      : IN  STD_LOGIC;
          ADDR     : IN  STD_LOGIC_VECTOR (ADDRESS_SIZE-1 DOWNTO 0);
          DATA_IN  : in std_logic_vector(DATA_SIZE-1 downto 0);
          DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
          we, re, ENABLE : in std_logic
        );
end entity;

architecture assincrona OF RAMMIPS IS
  type blocoMemoria IS ARRAY(0 TO 2**MEMORY_SIZE - 1) OF std_logic_vector(DATA_SIZE-1 DOWNTO 0);

  signal memRAM: blocoMemoria;
--  Caso queira inicializar a RAM (para testes):
--  attribute ram_init_file : string;
--  attribute ram_init_file of memRAM:
--  signal is "RAMcontent.mif";

-- Utiliza uma quantidade menor de endereços locais:
   signal ADDRLocal : std_logic_vector(MEMORY_SIZE-1 downto 0);

begin

  -- Ajusta o enderecamento para o acesso de 32 bits.
  ADDRLocal <= ADDR(MEMORY_SIZE+1 downto 2);

  process(clk)
  begin
      if(rising_edge(clk)) then
          if(we = '1' and ENABLE='1') then
              memRAM(to_integer(unsigned(ADDRLocal))) <= DATA_IN;
          end if;
      end if;
  end process;

  -- A leitura deve ser sempre assincrona:
  DATA_OUT <= memRAM(to_integer(unsigned(ADDRLocal))) when (re = '1' and ENABLE='1') else (others => 'Z');

end architecture;