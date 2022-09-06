library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;



architecture assincrona of memoriaROM is

  CONSTANT NOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT LDA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT LDI : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT STA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
		  -- armazena 4 na 257
		  tmp(0) := LDI & "0" & x"04";
		  tmp(1) := STA & "1" & x"01";
		  
		  -- armazena 3 na 256
		  tmp(2) := LDI & "0" & x"03";
		  tmp(3) := STA & "1" & x"00";
		  
		  -- soma o que esta na 256 com acumulador
		  tmp(4) := SOMA & "1" & x"00";
		  tmp(5) := SOMA & "1" & x"00";
		  
		  -- subtrai o que esta na 257 com acumulador
		  tmp(6) := SUB & "1" & x"01";
		  
		  -- NOP
		  tmp(7) := NOP & "0" & x"00";
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;