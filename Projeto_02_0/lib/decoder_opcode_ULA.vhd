

library ieee;
use ieee.std_logic_1164.all;

entity decoder_opcode_ULA is
   generic (
			OPCODE_SIZE : natural := 6;
			DATA_SIZE : natural := 4
  );
  port ( 
			OPCODE : in std_logic_vector(OPCODE_SIZE-1 downto 0);
         DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of decoder_opcode_ULA is

  constant ADD_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0010";
  constant SUB_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0110";
  
  
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  
  begin
  
  DATA_OUT <= ADD_ULA when (OPCODE = LW) or (OPCODE = SW) else 
				  SUB_ULA when (OPCODE = BEQ) else
				  "0000";
  
end architecture;