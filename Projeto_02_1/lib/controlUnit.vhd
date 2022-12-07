

library ieee;
use ieee.std_logic_1164.all;

entity controlUnit is
   generic (
         OPCODE_SIZE: natural := 6;
         CONTROL_SIZE: natural := 13
  );
  port ( 
			OPCODE : in std_logic_vector(OPCODE_SIZE-1 downto 0);
			FUNC   : in std_logic_vector(OPCODE_SIZE-1 downto 0);
			TYPE_R : out std_logic;
         DATA_OUT : out std_logic_vector(CONTROL_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of controlUnit is

  ------ ALL ZERO
  constant IS_ZERO  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000000";

  
  constant LW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "100011";
  constant SW  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "101011";
  
  constant JMP : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000010";
  constant JAL : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000011";
  constant BEQ : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000100";
  constant BNE : std_logic_vector(OPCODE_SIZE-1 downto 0) := "000101";
  
  constant LUI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001111";
  
  constant ADDI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001000";
  constant ANDI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001100";
  constant ORI  : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001101";
  constant SLTI : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001010";
  
  constant JR : std_logic_vector(OPCODE_SIZE-1 downto 0) := "001000";
  



-------------------------------------------------------------------------
  constant NORI: std_logic_vector(OPCODE_SIZE-1 downto 0) := "100111";
-------------------------------------------------------------------------




  alias enable_wr_ram : std_logic is DATA_OUT(0);
  alias enable_rd_ram : std_logic is DATA_OUT(1);
  alias bne_or_beq : std_logic is DATA_OUT(2);
  alias beqs : std_logic is DATA_OUT(3);
  alias mux_ula_mem : std_logic_vector is DATA_OUT(5 downto 4);
  alias mux_rt_imediato : std_logic is DATA_OUT(6);
  alias enable_wr_reg : std_logic is DATA_OUT(7);
  alias ori_andi : std_logic is DATA_OUT(8);
  alias mux_r3 : std_logic_vector is DATA_OUT(10 downto 9);
  alias mux_beq_jmp : std_logic is DATA_OUT(11);
  alias mux_jr : std_logic is DATA_OUT(12);
  
  begin
  
  enable_wr_ram <= '1' when (OPCODE = SW) else '0';
  
  enable_rd_ram <= '1' when (OPCODE = LW) else '0';
  
  bne_or_beq <= '1' when (OPCODE = BEQ) or (OPCODE = BNE) else '0';
  
  beqs <= '1' when (OPCODE = BEQ) else '0';
  
  mux_ula_mem <= "00" when (OPCODE = IS_ZERO) or (OPCODE = ORI) or (OPCODE = NORI) or (OPCODE = ANDI) or (OPCODE = ADDI) or (OPCODE = SLTI)  else
					  "10" when (OPCODE = JAL) else
					  "11" when (OPCODE = LUI) else
					  "01";
   
  mux_rt_imediato <= '0' when (OPCODE = IS_ZERO) or (OPCODE = BEQ) or (OPCODE = BNE) else '1';
  
  enable_wr_reg <= '1' when (OPCODE = LW) or (OPCODE = IS_ZERO and not(FUNC = JR)) or (OPCODE = ORI) 
								or (OPCODE = ANDI) or (OPCODE = ADDI) or (OPCODE = SLTI) 
								or (OPCODE = JAL)  or (OPCODE = LUI)
				  else '0';
  
  ori_andi <= '1' when (OPCODE = ORI) or (OPCODE = ANDI) or (OPCODE = NORI) else '0';
						 
  mux_r3 <= "10" when (OPCODE = JAL) or (FUNC = JR and OPCODE = IS_ZERO) else
				"01" when (OPCODE = IS_ZERO) else 
				"00";
  
  mux_beq_jmp <= '1' when (OPCODE = JMP) or (OPCODE = JAL) else '0';
  
  mux_jr <= '1' when (FUNC = JR and OPCODE = IS_ZERO) else '0';
  
  TYPE_R <= '1' when (OPCODE = IS_ZERO) else '0';
  
end architecture;