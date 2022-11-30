library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROMMIPS_MIF IS
   generic (
          dataWidth: natural := 32;
          addrWidth: natural := 32;
       memoryAddrWidth:  natural := 6 );   -- 64 posicoes de 32 bits cada
   port (
          ADDR : in  std_logic_vector (addrWidth-1 downto 0);
          DATA_OUT     : out std_logic_vector (dataWidth-1 downto 0) );
end entity;

architecture assincrona OF ROMMIPS_MIF IS
  type blocoMemoria IS ARRAY(0 TO 2**memoryAddrWidth - 1) OF std_logic_vector(dataWidth-1 downto 0);

  signal memROM: blocoMemoria;
  attribute ram_init_file : string;
  attribute ram_init_file of memROM:
  signal is "ROMcontent.mif";

-- Utiliza uma quantidade menor de endereços locais:
   signal ADDRLocal : std_logic_vector(memoryAddrWidth-1 downto 0);

begin
  ADDRLocal <= ADDR(memoryAddrWidth+1 downto 2);
  DATA_OUT <= memROM (to_integer(unsigned(ADDRLocal)));
end architecture;