

library ieee;
use ieee.std_logic_1164.all;

entity decoderMaster is
   generic (
			FUNC_SIZE : natural := 6;
			OPCODE_SIZE : natural := 6;
			CONTROL_SIZE : natural := 13;
			ULA_SELECTOR_SIZE : natural := 4
  );
  port ( 
			OPCODE : in std_logic_vector(OPCODE_SIZE-1 downto 0);
			FUNC : in std_logic_vector(FUNC_SIZE-1 downto 0);
			CONTROL_DATA : out std_logic_vector(CONTROL_SIZE-1 downto 0);
         	ULA_OP : out std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of decoderMaster is

  signal is_type_r : std_logic;
  
  signal opcode_ula_op : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
  signal func_ula_op : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
  
  begin
  
CONTROL_UNIT : entity work.controlUnit generic map(OPCODE_SIZE => OPCODE_SIZE, CONTROL_SIZE => (CONTROL_SIZE))
					port map(OPCODE => OPCODE, TYPE_R => is_type_r, FUNC => FUNC, DATA_OUT => CONTROL_DATA);

DECODER_OPCODE : entity work.decoder_opcode_ULA generic map (OPCODE_SIZE => OPCODE_SIZE, DATA_SIZE => ULA_SELECTOR_SIZE)
					  port map(OPCODE => OPCODE, DATA_OUT => opcode_ula_op);
					  
DECODER_FUNC : entity work.decoder_func_ULA generic map (FUNC_SIZE => FUNC_SIZE, DATA_SIZE => ULA_SELECTOR_SIZE)
					  port map(FUNC => FUNC, DATA_OUT => func_ula_op);
					  
MUX_ULA_OP : entity work.generic_MUX_2x1  generic map (DATA_SIZE => ULA_SELECTOR_SIZE)
	port map (IN_A => opcode_ula_op, IN_B => func_ula_op, MUX_SELECTOR => is_type_r, DATA_OUT => ULA_OP);
  
end architecture;