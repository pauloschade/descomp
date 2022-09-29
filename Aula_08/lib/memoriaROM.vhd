library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3;
			 opcodeSize: natural := 4
    );
   port (
          address : in std_logic_vector (addrWidth-1 DOWNTO 0);
          data : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;



architecture assincrona of memoriaROM is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
			tmp(0)   := LDA   & "101000000";
			tmp(1)   := STA   & "100100000";
			
			tmp(2)   := LDA   & "101000001";
			tmp(3)   := STA   & "100100001";
			
			tmp(4)   := LDA  &  "101000010";
			tmp(5)   := STA   & "100100010";
			
		   tmp(6)   := LDA   & "101100000";
			tmp(7)   := STA   & "100100011";
			
			tmp(8)   := LDA   & "101100001";
			tmp(9)   := STA   & "100100100";
			
			tmp(10)   := LDA  &  "101100010";
			tmp(11)   := STA   & "100100101";
			
			tmp(12)   := LDA  &  "101100011";
			tmp(13)   := STA   & "100000001";
			
			tmp(14)   := LDA  &  "101100100";
			tmp(15)   := STA   & "100000010";
			
			tmp(16)  := JMP  &  "000000000";
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;