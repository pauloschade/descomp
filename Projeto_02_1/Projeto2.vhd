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
	 REG_ADDR_SIZE : natural := 5;
	 
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
	---
	 
	--- OUTPUT
	 --	TEST
	 signal pc_curr : std_logic_vector(DATA_SIZE-1 downto 0);
	 --	EXEC
	 signal pc_plus_4 : std_logic_vector(DATA_SIZE-1 downto 0);
	 --	ID
	 signal instruction : std_logic_vector(DATA_SIZE-1 downto 0);
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
	 signal enable_reg : std_logic;
	 signal selector_ula_mem : std_logic_vector(1 downto 0);
	 
	 --	MEM
	 signal beq_or_bne : std_logic;
	 signal wr_ram : std_logic;
	 signal rd_ram : std_logic;
	 signal beq : std_logic;
	 
	 --	EX
	 signal selector_r3 : std_logic_vector(1 downto 0);
	 signal ula_op : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 signal selector_rt_or_imediato : std_logic;
	 
	 
	 --OUT REGS
	 signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal data_r1 : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal data_r2 : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --OUT JMP
	 signal jmp_selector : std_logic;
	 signal jr_selector  : std_logic;
	 
	 signal addr_rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 signal addr_rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	---

	--------------------------------------
	---------------- EX ------------------
	--- INPUT
	---
	--- OUTPUT
	 signal ula_result : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal sig_ext_plus_pc : std_logic_vector(DATA_SIZE-1 downto 0);
	 signal zero_ula : std_logic;
	 signal wb_addr_reg : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 signal addr_reg    : std_logic_vector(REG_ADDR_SIZE-1 downto 0);

	--------------------------------------
	---------------- MEM -----------------
	--- INPUT
	---
	--- OUTPUT
	signal selector_branch : std_logic;
	signal rd_data : std_logic_vector(DATA_SIZE-1 downto 0);
	--------------------------------------
	---------------- WB ------------------
	--- INPUT
	---
	--- OUTPUT
	signal data_wr_regs : std_logic_vector(DATA_SIZE-1 downto 0);
	signal wb_enable_reg : std_logic;
	--------------------------------------
	
	
	----------------- TESTE ---------------------
	signal signal_teste : std_logic_vector(DATA_SIZE-1 downto 0);
	
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
					EX_PC_PLUS_4 => pc_plus_4,
					INSTRUCTION => instruction
				);
				

ID_PIPE : entity work.ID_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => 16)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					-- TODOOOO
					INSTRUCTION => instruction,
					--WB
					ENABLE_REG_WR => wb_enable_reg,
					ADDR_REG => wb_addr_reg,
					DATA_WR => data_wr_regs,
					---------- OUTPUTS -----------------
					WB_ENABLE_REG => enable_reg,
					WB_SELECTOR_ULA_MEM => selector_ula_mem,

					MEM_BEQ_OR_BNE => beq_or_bne,
					MEM_WR_RAM => wr_ram,
					MEM_RD_RAM => rd_ram,
					MEM_BEQ => beq,

					EX_SELECTOR_R3 => selector_r3,
					EX_ULA_OP => ula_op,
					EX_SELECTOR_RT_OR_IMEDIATO => selector_rt_or_imediato,

					SIG_EXT => sig_ext,
					DATA_R1 => data_r1,
					DATA_R2 => data_r2,
					JMP_SELECTOR => jmp_selector,
					JR_SELECTOR => jr_selector,
					ADDR_RT => addr_rt,
					ADDR_RD => addr_rd
				);

EX_PIPE : entity work.EX_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					DATA_R1 => data_r1,
					DATA_R2 => data_r2,
					SIG_EXT => sig_ext,
					ULA_OP => ula_op,
					SELECTOR_R3 => selector_r3,
					SELECTOR_RT_OR_IMEDIATO => selector_rt_or_imediato,
					PC_PLUS_4 => pc_plus_4,
					ADDR_RT => addr_rt,
					ADDR_RD => addr_rd,
					---------- OUTPUTS -----------------
					ULA_RESULT => ula_result,
					SIG_EXT_PLUS_PC => sig_ext_plus_pc,
					ZERO_ULA => zero_ula,
					WB_ADDR_REG => addr_reg
				);

MEM_PIPE : entity work.MEM_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					ULA_RESULT => ula_result,
					BEQ_OR_BNE => beq_or_bne,
					WR_RAM => wr_ram,
					RD_RAM => rd_ram,
					BEQ => beq,
					ZERO_ULA => zero_ula,
					DATA_WR => data_r2,
					---------- OUTPUTS -----------------
					DATA_RD => rd_data,
					SELECTOR_BRANCH => selector_branch
				);

WB_PIPE : entity work.WB_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					SELECTOR_ULA_MEM => selector_ula_mem,
					ULA_RESULT => ula_result,
					DATA_RD => rd_data,
					JAL_ADDR => pc_plus_4,
					LUI_ADDR => 32x"00", -- TODO ADD LUI
					---------- OUTPUTS -----------------
					DATA_WR => data_wr_regs
				);


wb_enable_reg <= enable_reg;
wb_addr_reg <= addr_reg;


MUX_TEST : entity work.generic_MUX_2x1 generic map(DATA_SIZE => DATA_SIZE)
				port map(IN_A => pc_curr, IN_B => ula_result, MUX_SELECTOR => SW(SW_N-1) ,DATA_OUT => signal_teste);
				
HEX_LED : entity work.displaysController generic map (DATA_SIZE => DATA_SIZE)
				port map(DATA_IN => signal_teste, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, LED_0_3 => LEDR(3 downto 0), LED_4_7 => LEDR(7 downto 4));

end architecture;
				
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
