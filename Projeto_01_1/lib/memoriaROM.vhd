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
  constant ANDB : std_logic_vector(3 downto 0) := "1011";
  constant CLT  : std_logic_vector(3 downto 0) := "1100";
  constant JLT  : std_logic_vector(3 downto 0) := "1101";

  
  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
  
--tmp(0) := STA & "000" & "111111101"; -- STA @509
--
--tmp(1) := LDA & "111" & "111111100"; -- LDA [7] @508
--
--tmp(2) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(3) := JEQ & "000" & "000000001"; -- JEQ @1
--
--tmp(4) := LDA & "110" & "000001000"; -- LDA [6] @8
--
--tmp(5) := STA & "110" & "100000001"; -- STA [6] @257
--
--tmp(6) := STA & "000" & "111111101"; -- STA @509
--
--tmp(7) := JMP & "000" & "000000001"; -- JMP @1

tmp(0) := LDI & "110" & "000000000"; -- LDI [6] $0

tmp(1) := LDI & "111" & "000001000"; -- LDI [7] $8

tmp(2) := STA & "111" & "000001101"; -- STA [7] @13

tmp(3) := CLT & "110" & "000001101"; -- CLT [6] @13

tmp(4) := JLT & "000" & "000000000"; -- JLT @0

tmp(5) := LDA & "110" & "000001101"; -- LDA [6] @13

tmp(6) := LDA & "111" & "000001001"; -- LDA [7] @9

tmp(7) := JMP & "000" & "000000000"; -- JMP @0

		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;