library ieee;
use ieee.std_logic_1164.all;

entity ID_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 REG_ADDR_SIZE : natural := 5;
	 CONTROL_SIZE : natural := 11;
	 OPCODE_SIZE : natural := 6;
	 ULA_SELECTOR_SIZE : natural := 4;
	 IMEDIATO_SIZE : natural := 16;
	 FUNC_SIZE : natural := 6
	 
  );
  port   (
	 CLK : in std_logic;
	 -- IN
	 --	IF
	 INSTRUCTION : in std_logic_vector(DATA_SIZE-1 downto 0);
	 --	WB
	 ENABLE_REG : in std_logic;
	 ADDR_REG : in std_logic_vector(REG_ADDR_SIZE-1 downto 0); 
	 DATA_WR : in std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 -- OUT CONTROL 
	 --	WB
	 WB_ENABLE_REG : out std_logic;
	 WB_SELECTOR_ULA_MEM : out std_logic_vector(1 downto 0);
	 
	 --	MEM
	 MEM_BEQ_OR_BNE : out std_logic;
	 MEM_WR_RAM : out std_logic;
	 MEM_RD_RAM : out std_logic;
	 MEM_BEQ : out std_logic;
	 
	 --	EX
	 EX_SELECTOR_R3 : out std_logic_vector(1 downto 0);
	 EX_ULA_OP : out std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 EX_SELECTOR_RT_OR_IMEDIATO : out std_logic;
	 
	 
	 --OUT REGS
	 SIG_EXT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_R1 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_R2 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --OUT JMP
	 JMP_SELECTOR : out std_logic;
	 JR_SELECTOR  : out std_logic;
	 
	 ADDR_RT : out std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 ADDR_RD : out std_logic_vector(REG_ADDR_SIZE-1 downto 0)
  );
end entity;

architecture arquitetura of ID_PIPELINE is

	signal control : std_logic_vector(CONTROL_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	signal ori_andi : std_logic_vector;
	
	--------------------- REGS ---------------------------
	signal rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rs : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	------------------------------------------------------

begin

DECODER : entity work.decoderMaster  generic map (OPCODE_SIZE => OPCODE_SIZE, FUNC_SIZE => FUNC_SIZE, ULA_SELECTOR_SIZE => ULA_SELECTOR_SIZE, CONTROL_SIZE => CONTROL_SIZE)
	port map (OPCODE => opcode, FUNC => func, CONTROL_DATA => control, ULA_OP => EX_ULA_OP);
	
REGS : entity work.bancoReg generic map (DATA_SIZE => DATA_SIZE, REG_ADDR_SIZE => REG_ADDR_SIZE)
          port map 
			(  CLK => CLK,
				ADDR_A => rs, ADDR_B => rt, ADDR_C => ADDR_REG,
				DATA_WR => DATA_WR,
				OUT_A => DATA_R1, OUT_B => DATA_R2,
				ENABLE_WR => ENABLE_REG
			);
	
ESTENDE : entity work.estendeSinalGenerico  generic map (DATA_IN_SIZE => IMEDIATO_SIZE, DATA_OUT_SIZE => DATA_SIZE)
	port map ( DATA_IN => imediato, SELECTOR => ori_andi, DATA_OUT => SIG_EXT );
	
-------------------------------------------------------------------------------
-------------------------------- TO BE STORED IN REGS -------------------------
-------------------------------------------------------------------------------	
-------- CONTROL -----------------------
MEM_WR_RAM <= control(0);
MEM_RD_RAM <= control(1);
MEM_BEQ_OR_BNE <= control(2);
MEM_BEQ <= control(3);
WB_SELECTOR_ULA_MEM <= control(5 downto 4);
EX_SELECTOR_RT_OR_IMEDIATO <= control(6);
WB_ENABLE_REG  <= control(7);
EX_SELECTOR_R3 <= control(10 downto 9);
----------------------------------------
----------- REGS -----------------------
-- ADDR
ADDR_RT <= rt;
ADDR_RS <= rs;

-- DATA

----------------------------------------

-------------------------------------------------------------------------------
------------------------------------ TO HELP ----------------------------------
-------------------------------------------------------------------------------	
---------- INSTRCUTION ---------------
imediato <= INSTRUCTION(15 downto 0);
OPCODE <= INSTRUCTION(31 downto 26);
rs <= INSTRUCTION(25 downto 21);
rt <= INSTRUCTION(20 downto 16);
rd <= INSTRUCTION(15 downto 11);
FUNC <= INSTRUCTION(5 downto 0);
--------------------------------------

------------- OTHER ------------------
ori_andi <= control(8);
--------------------------------------

end architecture;