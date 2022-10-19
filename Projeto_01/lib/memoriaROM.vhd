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
			
tmp(0) := LDI & "111" & "000000000"; -- LDI R7 $0

tmp(1) := STA & "000" & "000001000"; -- STA R0 @MEM0

tmp(2) := LDI & "111" & "000000001"; -- LDI R7 $1

tmp(3) := STA & "111" & "000001001"; -- STA R7 @MEM1

tmp(4) := LDI & "111" & "000001001"; -- LDI R7 $9

tmp(5) := STA & "111" & "000001110"; -- STA R7 @MEM9

tmp(6) := LDI & "000" & "000000000"; -- LDI R0 $0

tmp(7) := LDI & "001" & "000000000"; -- LDI R1 $0

tmp(8) := LDI & "010" & "000000000"; -- LDI R2 $0

tmp(9) := LDI & "011" & "000000000"; -- LDI R3 $0

tmp(10) := LDI & "100" & "000000000"; -- LDI R4 $0

tmp(11) := LDA & "111" & "101100000"; -- LDA R7 @KEY0

tmp(12) := CEQ & "111" & "000000000"; -- CEQ R7 @0

tmp(13) := JEQ & "000" & "000001011"; -- JEQ @11

tmp(14) := JSR & "000" & "000010000"; -- JSR @16

tmp(15) := JMP & "000" & "000001011"; -- JMP @11

tmp(16) := STA & "000" & "111111111"; -- STA @clr_KEY0

tmp(17) := CEQ & "000" & "000001110"; -- CEQ R0 @MEM9

tmp(18) := JEQ & "000" & "000010110"; -- JEQ @22

tmp(19) := SOMA & "000" & "000001001"; -- SOMA R0 @MEM1

tmp(20) := STA & "000" & "100100000"; -- STA R0 @HEX0

tmp(21) := RET & "000" & "000000000"; -- RET

tmp(22) := LDA & "000" & "000001000"; -- LDA R0 $MEM0

tmp(23) := STA & "000" & "100100000"; -- STA R0 @HEX0

tmp(24) := CEQ & "001" & "000001110"; -- CEQ R1 @MEM9

tmp(25) := JEQ & "000" & "000011101"; -- JEQ @29

tmp(26) := SOMA & "001" & "000001001"; -- SOMA R1 @MEM1

tmp(27) := STA & "001" & "100100001"; -- STA R1 @HEX1

tmp(28) := RET & "000" & "000000000"; -- RET

tmp(29) := LDA & "001" & "000001000"; -- LDA R1 $MEM0

tmp(30) := STA & "001" & "100100001"; -- STA R1 @HEX1

tmp(31) := CEQ & "010" & "000001110"; -- CEQ R2 @MEM9

tmp(32) := JEQ & "000" & "000100100"; -- JEQ @36

tmp(33) := SOMA & "010" & "000001001"; -- SOMA R2 @MEM1

tmp(34) := STA & "010" & "100100010"; -- STA R2 @HEX2

tmp(35) := RET & "000" & "000000000"; -- RET

tmp(36) := LDA & "010" & "000001000"; -- LDA R2 $MEM0

tmp(37) := STA & "010" & "100100010"; -- STA R2 @HEX2

tmp(38) := CEQ & "011" & "000001110"; -- CEQ R3 @MEM9

tmp(39) := JEQ & "000" & "000100100"; -- JEQ @36

tmp(40) := SOMA & "011" & "000001001"; -- SOMA R3 @MEM1

tmp(41) := STA & "011" & "100100011"; -- STA R3 @HEX3

tmp(42) := RET & "000" & "000000000"; -- RET


		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;