library ieee;
use ieee.std_logic_1164.all;

entity Projeto2 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 OPCODE_SIZE : natural := 6;
	 FUNC_SIZE : natural := 6;
	 INSTRUCTIONS_SIZE : natural := 13;
	 IMEDIATO_SIZE : natural := 26;
	 CONTROL_SIZE : natural := 13;
	 ULA_SELECTOR_SIZE : natural := 4;
	 HEX_SIZE : natural := 7;
	 LED_N : natural := 10;
	 SW_N : natural := 10;
	 
	 simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
	 KEY_IN : in std_logic;
	 ------------------ FPGA -----------------------------
	 HEX0 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX1 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 HEX2 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX3 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX4 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX5 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 
	 SW : in std_logic_vector(SW_N-1 downto 0);
	 
	 KEY : in std_logic_vector(3 downto 0);
	 
	 LEDR : out std_logic_vector(LED_N-1 downto 0)
	 ------------------- TEST -----------------------------
--	 REG1_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 REG2_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 PC_DATA  : out std_logic_vector(DATA_SIZE-1 downto 0)
--	 ULA_DATA_OUTER : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 SIG_EXTEN : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 BEQ_OR_JMP : out std_logic;
--	 OPCODE_OUTPUT : out std_logic_vector(OPCODE_SIZE-1 downto 0);
--	 ULA_OPERATION : out std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
--	 CONTROL_DATA_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
--	 DATA_WR : out std_logic_vector(DATA_SIZE-1 downto 0)
	 
  );
end entity;


architecture arquitetura of Projeto2 is

	signal CLK : std_logic;
	--------------------------------------- SIGS --------------------------------------------
	---------------- IF -----------------
	--- INPUT
	 signal imediato_jmp :  std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	 signal beq_jmp_selector : std_logic;
	 signal jr_addr : std_logic_vector(DATA_SIZE-1 downto 0);

	 signal jr_selector : std_logic;
	 signal sig_ext_plus_pc : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal selector_branch : std_logic;
	---
	 
	--- OUTPUT
	 --	TEST
	 signal pc_curr : std_logic_vector(DATA_SIZE-1 downto 0);
	 --	EXEC
	 signal exec_pc_plus_4 : std_logic_vector(DATA_SIZE-1 downto 0);
	 --	ID
	 signal id_instruction : out std_logic_vector(DATA_SIZE-1 downto 0);
	---
	--------------------------------------
	---------------- ID ------------------
	--- INPUT
	--	WB
--	 signal enable_reg : std_logic;
--	 signal addr_reg : std_logic_vector(REG_ADDR_SIZE-1 downto 0); 
--	 signal data_wr : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	-- OUTPUT 
	--	WB
	 signal wb_enable_reg : std_logic;
	 signal wb_selector_ula_mem : out std_logic_vector(1 downto 0);
	 
	 --	MEM
	 signal mem_beq_or_bne : std_logic;
	 signal mem_wr_ram : std_logic;
	 signal mem_rd_ram : std_logic;
	 signal mem_beq : std_logic;
	 
	 --	EX
	 signal ex_selector_r3 : std_logic_vector(1 downto 0);
	 signal ex_ula_op : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 signal ex_selector_rt_or_imediato : out std_logic;
	 
	 
	 --OUT REGS
	 signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal data_r1 : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal data_r2 : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --OUT JMP
	 signal jmp_selector : std_logic;
	 signal jr_selector  : std_logic;
	 
	 signal addr_rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 signal addr_rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0)
	---
	
	 

	
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY_IN;                       
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => CLK);
--CLK <= KEY_IN;
end generate;



IF_PIPE : entity work.IF_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					IMEDIATO => imediato_jmp,
					BEQ_JMP_SELECTOR => beq_jmp_selector,
					JR_ADDR => jr_addr,
					JR_SELECTOR => jr_selector,
					SIG_EXT_PLUS_PC => sig_ext_plus_pc,
					SELECTOR_BRANCH => selector_branch,
					---------- OUTPUTS -----------------
					PC_CURR => pc_curr,
					EXEC_PC_PLUS_4_OUT => exec_pc_plus_4,
					ID_INSTRUCTION => id_instruction
				);
				

ID_PIPE : entity work.ID_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					INSTRUCTION => id_instruction,
					
					---------- OUTPUTS -----------------
					WB_ENABLE_REG => wb_enable_reg,
					WB_SELECTOR_ULA_MEM => wb_selector_ula_mem,
					MEM_BEQ_OR_BNE => mem_beq_or_bne,
					
				);

--MUX_TEST : entity work.generic_MUX_2x1 generic map(DATA_SIZE => DATA_SIZE)
--				port map(IN_A => pc, IN_B => ula_out, MUX_SELECTOR => SW(SW_N-1) ,DATA_OUT => signal_teste);
--				
--HEX_LED : entity work.displaysController generic map (DATA_SIZE => DATA_SIZE)
--				port map(DATA_IN => signal_teste, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, LED_0_3 => LEDR(3 downto 0), LED_4_7 => LEDR(7 downto 4));

				
------------------------------------------------------			
--mux_beq_jmp_selector <= control(11);
--mux_jr_selector <= control(12);
--imediato <= rom_out(IMEDIATO_SIZE-1 downto 0);
------------------------------------------------------
--BEQ_OR_JMP <= control(CONTROL_SIZE-1);
--SIG_EXTEN <= sig_ext;
--OPCODE_OUTPUT <= opcode;
--PC_DATA <= pc;
--ULA_DATA_OUTER <= ula_out;
--CONTROL_DATA_IN <= control;
------------------------------------------------------
end architecture;
