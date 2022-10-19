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
			
			
			tmp(0) := LDI & "000" & "000000000"; -- LDI R0 $0

			tmp(1) := STA & "001" & "000001000"; -- STA R1 @MEM0

			tmp(2) := LDI & "000" & "000000001"; -- LDI R0 $1

			tmp(3) := STA & "000" & "000001001"; -- STA R0 @MEM1

			tmp(4) := LDI & "000" & "000001001"; -- LDI R0 $9

			tmp(5) := STA & "000" & "000001001"; -- STA R0 @MEM9

			tmp(6) := LDI & "001" & "000000000"; -- LDI R1 $0

			tmp(7) := LDI & "010" & "000000000"; -- LDI R2 $0

			tmp(8) := LDI & "011" & "000000000"; -- LDI R3 $0

			tmp(9) := NOP & "000" & "000000000"; -- !RETORNO

			tmp(10) := LDA & "000" & "101100000"; -- LDA R0 @KEY0

			tmp(11) := CEQ & "000" & "000000000"; -- CEQ R0 @0

			tmp(12) := JEQ & "000" & "000001010"; -- JEQ @RETORNO

			tmp(13) := JSR & "000" & "000010000"; -- JSR @INCREMENTA

			tmp(14) := JMP & "000" & "000001010"; -- JMP @RETORNO

			tmp(15) := NOP & "000" & "000000000"; -- !INCREMENTA

			tmp(16) := LDA & "000" & "000001000"; -- LDA R0 $MEM0

			tmp(17) := STA & "000" & "111111111"; -- STA @clr_KEY0

			tmp(18) := CEQ & "001" & "000001001"; -- CEQ R1 @MEM9

			tmp(19) := JEQ & "000" & "000011000"; -- JEQ @DEZENA

			tmp(20) := SOMA & "001" & "000001001"; -- SOMA R1 @MEM1

			tmp(21) := STA & "001" & "100100000"; -- STA R1 @HEX0

			tmp(22) := RET & "000" & "000000000"; -- RET

			tmp(23) := NOP & "000" & "000000000"; -- !DEZENA

			tmp(24) := STA & "000" & "100100000"; -- STA R0 @HEX0

			tmp(25) := CEQ & "010" & "000001001"; -- CEQ R2 @MEM9

			tmp(26) := JEQ & "000" & "000011111"; -- JEQ @CENTENA

			tmp(27) := SOMA & "010" & "000001001"; -- SOMA R2 @MEM1

			tmp(28) := STA & "010" & "100100001"; -- STA R2 @HEX1

			tmp(29) := RET & "000" & "000000000"; -- RET

			tmp(30) := NOP & "000" & "000000000"; -- !CENTENA

			tmp(31) := STA & "000" & "100100001"; -- STA R0 @HEX1

			tmp(32) := CEQ & "011" & "000001001"; -- CEQ R3 @MEM9

			tmp(33) := JEQ & "000" & "000011111"; -- JEQ @CENTENA

			tmp(34) := SOMA & "011" & "000001001"; -- SOMA R3 @MEM1

			tmp(35) := STA & "011" & "100100011"; -- STA R3 @HEX3

			tmp(36) := RET & "000" & "000000000"; -- RET
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;