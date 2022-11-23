

library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
   generic (
         OPCODE_SIZE: natural := 6;
			FUNC_SIZE : natural := 6;
         CONTROL_SIZE: natural := 11
  );
  port ( 
			OPCODE : in std_logic_vector(OPCODE_SIZE-1 downto 0);
			FUNC : in std_logic_vector(FUNC_SIZE-1 downto 0);
         DATA_OUT : out std_logic_vector(CONTROL_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  ------ ALL ZERO
  constant IS_ZERO  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000000";

  constant ADD : std_logic_vector(FUNC_SIZE-1 downto 0)   := "100000";
  constant SUB : std_logic_vector(FUNC_SIZE-1 downto 0)   := "100010";
  
  
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  constant JMP : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000010";
  
  alias enable_wr_ram : std_logic is DATA_OUT(0);
  alias enable_rd_ram : std_logic is DATA_OUT(1);
  alias beqs : std_logic is DATA_OUT(2);
  alias mux_ula_mem : std_logic is DATA_OUT(3);
  alias ula_op : std_logic_vector(3 downto 0) is DATA_OUT(7 downto 4);
  alias mux_rt_imediato : std_logic is DATA_OUT(8);
  alias enable_wr_reg : std_logic is DATA_OUT(9);
  alias mux_rt_rd : std_logic is DATA_OUT(10);
  alias mux_beq_jmp : std_logic is DATA_OUT(11);
  
  begin
  
  enable_wr_ram <= '1' when (OPCODE = SW) else '0';
  
  enable_rd_ram <= '1' when (OPCODE = LW) else '0';
  
  beqs <= '1' when (OPCODE = BEQ) else '0';
  
  mux_ula_mem <= '0' when (OPCODE = IS_ZERO) else '1';
  
  ula_op <= "0010" when (OPCODE = LW) or (OPCODE = SW) or (FUNC = ADD) else 
				"0110" when (OPCODE = BEQ) or (FUNC = SUB) else
				"0000";
  
  mux_rt_imediato <= '0' when (OPCODE = IS_ZERO) else '1';
  
  enable_wr_reg <= '1' when (OPCODE = LW) else '0';
						 
  mux_rt_rd <= '0' when (FUNC = IS_ZERO) else '1';
  
  mux_beq_jmp <= '1' when (OPCODE = JMP) else '0';
  
end architecture;