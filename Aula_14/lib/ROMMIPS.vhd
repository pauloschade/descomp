library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROMMIPS IS
   generic (
          dataWidth: natural := 32;
          addrWidth: natural := 32;
			 OPCODE_SIZE: natural := 6;
       memoryAddrWidth:  natural := 6 );   -- 64 posicoes de 32 bits cada
   port (
          ADDR : in  std_logic_vector (addrWidth-1 downto 0);
          DATA_OUT     : out std_logic_vector (dataWidth-1 downto 0) );
end entity;

architecture assincrona OF ROMMIPS IS
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  type blocoMemoria IS ARRAY(0 TO 2**memoryAddrWidth - 1) OF std_logic_vector(dataWidth-1 downto 0);
  
  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
		  -- Deve desviar para a posição 14
		  ------     OPCODE    RS        RT
		  tmp(0) :=    SW & "01010" & "01001" & "0000000000000000";
		  tmp(1) :=    LW & "01010" & "01010" & "0000000000000000";
		  return tmp;
    end initMemory;
	 
	signal memROM : blocoMemoria := initMemory;
   signal EnderecoLocal : std_logic_vector(memoryAddrWidth-1 downto 0);

begin
  EnderecoLocal <= ADDR(memoryAddrWidth+1 downto 2);
  DATA_OUT <= memROM (to_integer(unsigned(EnderecoLocal)));
end architecture;