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
			tmp(0)   := LDI   & "000000000";
			tmp(1)   := STA   & "000000000";
			tmp(2)   := STA   & "000000010";
			
			tmp(3)   := LDI   & "000000001";
			tmp(4)   := STA  &  "000000001";
			
			tmp(5)   := NOP   & "000000000";
			
		   tmp(6)   := LDA   & "101100000";
			tmp(7)   := STA   & "100100000";
			
			tmp(8)   := CEQ   & "000000000";
			tmp(9)   := JEQ   & "000001011";
			
			tmp(10)   := JSR  & "000100000";
			
			tmp(11)   := NOP  & "000000000";
			tmp(12)   := JMP  & "000000101";
			
			
			tmp(32)   := STA  & "111111111";
			
			tmp(33)   := LDA  & "000000010";
			
			tmp(34)   := SOMA & "000000001";
			
			tmp(35)  :=  STA  & "000000010";
			
			tmp(36)  :=  STA  & "100000010";
			
			tmp(37)  :=  RET  & "000000000";
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;