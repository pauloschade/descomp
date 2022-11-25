

library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
   generic (
         OPCODE_SIZE: natural := 6;
         CONTROL_SIZE: natural := 11
  );
  port ( 
			OPCODE : in std_logic_vector(OPCODE_SIZE-1 downto 0);
			TYPE_R : out std_logic;
         DATA_OUT : out std_logic_vector(CONTROL_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of controlUnit is

  ------ ALL ZERO
  constant IS_ZERO  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000000";
  
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  constant JMP : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000010";
  
  alias enable_wr_ram : std_logic is DATA_OUT(0);
  alias enable_rd_ram : std_logic is DATA_OUT(1);
  alias beqs : std_logic is DATA_OUT(2);
  alias mux_ula_mem : std_logic is DATA_OUT(3);
  alias mux_rt_imediato : std_logic is DATA_OUT(4);
  alias enable_wr_reg : std_logic is DATA_OUT(5);
  alias mux_rt_rd : std_logic is DATA_OUT(6);
  alias mux_beq_jmp : std_logic is DATA_OUT(7);
  
  begin
  
  enable_wr_ram <= '1' when (OPCODE = SW) else '0';
  
  enable_rd_ram <= '1' when (OPCODE = LW) else '0';
  
  beqs <= '1' when (OPCODE = BEQ) else '0';
  
  mux_ula_mem <= '0' when (OPCODE = IS_ZERO) else '1';
  
  mux_rt_imediato <= '0' when (OPCODE = IS_ZERO) or (OPCODE = BEQ) else '1';
  
  enable_wr_reg <= '1' when (OPCODE = LW) or (OPCODE = IS_ZERO) else '0';
						 
  mux_rt_rd <= '1' when (OPCODE = IS_ZERO) else '0';
  
  mux_beq_jmp <= '1' when (OPCODE = JMP) else '0';
  
  TYPE_R <= '1' when (OPCODE = IS_ZERO) else '0';
  
end architecture;