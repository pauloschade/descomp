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
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
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
		  -- Deve desviar para a posição 14
		  tmp(0) := JSR & "0" & x"0E";
		  
		  -- Deve desviar para a posição 5
		  tmp(1) := JMP & "0" & x"05";
		  
		  -- Deve desviar para a posição 9
		  tmp(2) := JEQ & "0" & x"09";
		  
		  -- NOP
		  tmp(3) := NOP & "0" & x"00";
		  tmp(4) := NOP & "0" & x"00";
		  
		  -- Carrega acumulador com valor 5
		  tmp(5) := LDI & "0" & x"05";
		  
		  -- Armazena 5 na posição 256 da memória
		  tmp(6) := STA & "1" & x"00";
		  
		  -- A comparação deve fazer o flagIgual ser 1
		  tmp(7) := CEQ & "1" & x"00";
		  
		  -- Vai testar o flagIgual depois do jump
		  tmp(8) := JMP & "0" & x"02";
		  
		  -- NOP
		  tmp(9) := NOP & "0" & x"00";
		  
		  -- 	Carrega acumulador com valor 4
		  tmp(10) := LDI & "0" & x"04";
		  
		  -- 	Compara com valor 5, deve fazer o flagIgual ser 0
		  tmp(11) := CEQ & "1" & x"00";
		  
		  -- Não deve ocorrer o desvio
		  tmp(12) := JEQ & "0" & x"03";
		  
		  -- Fim. Deve ficar neste laço
		  tmp(13) := JMP & "0" & x"0D";
		  
		  -- NOP
		  tmp(14) := NOP & "0" & x"00";
		  
		   -- Retorna para a posição 1
		  tmp(15) := RET & "0" & x"00";
		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;