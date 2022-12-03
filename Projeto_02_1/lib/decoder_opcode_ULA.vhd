

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

  -- ULA
  constant AND_ULA  : std_logic_vector(DATA_SIZE-1 downto 0)  := "0000";
  constant OR_ULA  : std_logic_vector(DATA_SIZE-1 downto 0)   := "0001";
  constant ADD_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0010";
  constant SUB_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0110";
  constant SLT_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0111";
  
  constant ADDI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001000";
  constant ANDI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001100";
  constant ORI  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001101";
  constant SLTI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001010";
  
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  constant BNE : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000101";
  
  begin
  
  DATA_OUT <= AND_ULA when (OPCODE = ANDI) else
				  OR_ULA  when (OPCODE = ORI)  else
				  ADD_ULA when (OPCODE = LW) or (OPCODE = SW) or (OPCODE = ADDI) else 
				  SUB_ULA when (OPCODE = BEQ) or (OPCODE = BNE) else
				  SLT_ULA when (OPCODE = SLTI) else
				  "0000";
  
end architecture;