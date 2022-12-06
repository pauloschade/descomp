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
	 
	 WB_CONTROL_SIZE   : natural := 3;
	 MEM_CONTROL_SIZE  : natural := 4;
	 EX_CONTROL_SIZE   : natural := 3; -- + ULA OP
	 
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
	
	-- IF -------------------------------------------------------------------------------------------------
	signal pc_plus_4_if_out, pc_plus_4_if_id, pc_plus_4_id_ex, pc_plus_4_ex_mem, pc_plus_4_mem_wb : std_logic_vector(DATA_SIZE-1 downto 0);
	signal instruction_if_out, instruction_if_id : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal dout_reg_if_id : std_logic_vector((DATA_SIZE + DATA_SIZE-1) downto 0);
	-------------------------------------------------------------------------------------------------------
	-- ID -------------------------------------------------------------------------------------------------
	signal control : std_logic_vector(CONTROL_SIZE-1 downto 0);
	signal ula_op_id_out, ula_op_id_ex : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	signal data_r1_id_out, data_r1_id_ex : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_r2_id_out, data_r2_id_ex, data_r2_ex_mem : std_logic_vector(DATA_SIZE-1 downto 0);
	signal sig_ext_id_out, sig_ext_id_ex : std_logic_vector(DATA_SIZE-1 downto 0);
	signal sig_lui_id_out, sig_lui_id_ex, sig_lui_ex_mem, sig_lui_mem_wb  : std_logic_vector(DATA_SIZE-1 downto 0);
	signal rt_addr_id_out, rt_addr_id_ex : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rd_addr_id_out, rd_addr_id_ex : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	
	signal selector_jmp, selector_jr : std_logic;
	signal imediato_jmp : std_logic_vector(25 downto 0);
	
	-- HELP
	signal wb_control_id_out, wb_control_id_ex, wb_control_ex_mem, wb_control_mem_wb : std_logic_vector(WB_CONTROL_SIZE-1 downto 0);
	signal mem_control_id_out, mem_control_id_ex, mem_control_ex_mem : std_logic_vector(MEM_CONTROL_SIZE-1 downto 0);
	signal ex_control_id_out, ex_control_id_ex : std_logic_vector(EX_CONTROL_SIZE-1 downto 0);
	
	constant reg_if_ex_size : natural := DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE + ULA_SELECTOR_SIZE +
		EX_CONTROL_SIZE + MEM_CONTROL_SIZE + WB_CONTROL_SIZE +
		DATA_SIZE;
		
	signal dout_reg_if_ex :  std_logic_vector(reg_if_ex_size-1 downto 0);
	--------------------------------------------------------------------------------------------------------
	-- EX --------------------------------------------------------------------------------------------------
	signal pc_plus_sig_ex_out, pc_plus_sig_ex_mem : std_logic_vector(DATA_SIZE-1 downto 0);
	signal ula_zero_ex_out, ula_zero_ex_mem : std_logic;
	signal ula_result_ex_out, ula_result_ex_mem, ula_result_mem_wb : std_logic_vector(DATA_SIZE-1 downto 0);
	signal reg_wr_addr_ex_out, reg_wr_addr_ex_mem, reg_wr_addr_mem_wb : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	
	constant reg_ex_mem_size : natural := DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE + DATA_SIZE + 
												 MEM_CONTROL_SIZE + WB_CONTROL_SIZE + DATA_SIZE + DATA_SIZE;
	signal dout_reg_ex_mem :  std_logic_vector(reg_ex_mem_size-1 downto 0);
	--------------------------------------------------------------------------------------------------------
	-- MEM -------------------------------------------------------------------------------------------------
	signal ram_rd_data_mem_out, ram_rd_data_mem_wr : std_logic_vector(DATA_SIZE-1 downto 0);
	signal selector_branch : std_logic;
	
	constant reg_mem_wb_size : natural := WB_CONTROL_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + REG_ADDR_SIZE;
	signal dout_reg_mem_wb :  std_logic_vector(reg_mem_wb_size-1 downto 0);
	--------------------------------------------------------------------------------------------------------
	-- WB --------------------------------------------------------------------------------------------------
	signal reg_wr_wb_out: std_logic_vector(DATA_SIZE-1 downto 0);
	--------------------------------------------------------------------------------------------------------
	
	
	----------------- TESTE ---------------------
	signal pc_curr : std_logic_vector(DATA_SIZE-1 downto 0);
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
					BEQ_JMP_SELECTOR => selector_jmp,
					JR_ADDR => data_r1_id_out,
					JR_SELECTOR => selector_jr,
					SIG_EXT_PLUS_PC => pc_plus_sig_ex_mem,
					SELECTOR_BRANCH => selector_branch,
					---------- OUTPUTS -----------------
					PC_CURR => pc_curr,
					EX_PC_PLUS_4 => pc_plus_4_if_out,
					INSTRUCTION => instruction_if_out
				);
				
-----------------------------------------------------------------
------------ REG PIPE HERE ---------
--pc_plus_4_if_id <= pc_plus_4_if_out;
--instruction_if_id <= instruction_if_out;
REG_IF_ID : entity work.registradorGenerico   generic map (DATA_SIZE => (DATA_SIZE + DATA_SIZE))
	port map (
				DIN => instruction_if_out & pc_plus_4_if_out, 
				DOUT => dout_reg_if_id, 
				ENABLE => '1', CLK => CLK
				);
------------------------------------
pc_plus_4_if_id <= dout_reg_if_id(DATA_SIZE-1 downto 0);
instruction_if_id <= dout_reg_if_id(DATA_SIZE+DATA_SIZE-1 downto DATA_SIZE);
-----------------------------------------------------------------
---
imediato_jmp <= instruction_if_id(25 downto 0);
---


ID_PIPE : entity work.ID_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => 16)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					INSTRUCTION => instruction_if_id,
					ENABLE_REG_WR => wb_control_mem_wb(2),
					ADDR_REG => reg_wr_addr_mem_wb,
					DATA_WR => reg_wr_wb_out,
					---------- OUTPUTS -----------------
					CONTROL => control,
					ULA_OP => ula_op_id_out,
					SIG_EXT => sig_ext_id_out,
					SIG_LUI => sig_lui_id_out,
					DATA_R1 => data_r1_id_out,
					DATA_R2 => data_r2_id_out,
					ADDR_RT => rt_addr_id_out,
					ADDR_RD => rd_addr_id_out
				);

------------------------------------------------------------------
---
ex_control_id_out(1 downto 0) <= CONTROL(10 downto 9);
ex_control_id_out(2) <= CONTROL(6);
---
mem_control_id_out <= CONTROL(3 downto 0);
---
wb_control_id_out(1 downto 0) <= CONTROL(5 downto 4);
wb_control_id_out(2) <= CONTROL(7);
---
selector_jmp <= CONTROL(11);
selector_jr <= CONTROL(12);


------------ REG PIPE HERE ---------
--sig_ext_id_ex <= sig_ext_id_out;
--sig_lui_id_ex <= sig_lui_id_out;
--
--data_r1_id_ex <= data_r1_id_out;
--data_r2_id_ex <= data_r2_id_out;
--rt_addr_id_ex <= rt_addr_id_out;
--rd_addr_id_ex <= rd_addr_id_out;
--
--ula_op_id_ex <= ula_op_id_out;
--
--ex_control_id_ex <= ex_control_id_out;
--mem_control_id_ex <= mem_control_id_out;
--wb_control_id_ex <= wb_control_id_out;

REG_ID_EX : entity work.registradorGenerico   generic map (DATA_SIZE => reg_if_ex_size)
	port map 
	(
		DIN => 
		(
			pc_plus_4_if_id & wb_control_id_out &
			mem_control_id_out & ex_control_id_out &
			ula_op_id_out & rd_addr_id_out & 
			rt_addr_id_out & data_r2_id_out &
			data_r1_id_out & sig_lui_id_out &
			sig_ext_id_out
--			sig_ext_id_out & sig_lui_id_out &
--			data_r1_id_out & data_r2_id_out &
--			rt_addr_id_out & rd_addr_id_out &
--			ula_op_id_out  & ex_control_id_out &
--			mem_control_id_out & wb_control_id_out &
--			pc_plus_4_if_id
			
		), 
		DOUT => dout_reg_if_ex, 
		ENABLE => '1', CLK => CLK
	);

pc_plus_4_id_ex <= dout_reg_if_ex(reg_if_ex_size-1 downto 
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE + ULA_SELECTOR_SIZE +
		EX_CONTROL_SIZE + MEM_CONTROL_SIZE + WB_CONTROL_SIZE
		)
);

wb_control_id_ex <= dout_reg_if_ex(reg_if_ex_size - DATA_SIZE - 1 downto 
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE + ULA_SELECTOR_SIZE +
		EX_CONTROL_SIZE + MEM_CONTROL_SIZE
		)
);

mem_control_id_ex <= dout_reg_if_ex(reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE -1 downto 
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE + ULA_SELECTOR_SIZE +
		EX_CONTROL_SIZE
		)
);

ex_control_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE -1 downto 
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE + ULA_SELECTOR_SIZE
		)
);

ula_op_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE -1 downto
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE + REG_ADDR_SIZE
		)
);

rd_addr_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - 
		1 downto
		(
		DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE + 
		REG_ADDR_SIZE
		)
);

rt_addr_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - REG_ADDR_SIZE -
		1 downto (DATA_SIZE + DATA_SIZE + DATA_SIZE + DATA_SIZE)
);

data_r2_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - REG_ADDR_SIZE -
		REG_ADDR_SIZE - 1 downto (DATA_SIZE + DATA_SIZE + DATA_SIZE)
);

data_r1_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - REG_ADDR_SIZE -
		REG_ADDR_SIZE - DATA_SIZE - 1 downto (DATA_SIZE + DATA_SIZE)
);

sig_lui_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - REG_ADDR_SIZE -
		REG_ADDR_SIZE - DATA_SIZE - DATA_SIZE - 1 downto DATA_SIZE
);

sig_ext_id_ex <= dout_reg_if_ex
		(
		reg_if_ex_size - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE - 
		EX_CONTROL_SIZE - ULA_SELECTOR_SIZE - REG_ADDR_SIZE -
		REG_ADDR_SIZE - DATA_SIZE - DATA_SIZE - DATA_SIZE -1 downto 0
);


------------------------------------
------------------------------------------------------------------


EX_PIPE : entity work.EX_PIPELINE generic map(DATA_SIZE => DATA_SIZE, CONTROL_SIZE => EX_CONTROL_SIZE ,IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					DATA_R1 => data_r1_id_ex,
					DATA_R2 => data_r2_id_ex,
					CONTROL => ex_control_id_ex,
					ULA_OP => ula_op_id_ex,
					PC_PLUS_4 => pc_plus_4_id_ex,
					SIG_EXT => sig_ext_id_ex,
					ADDR_RT => rt_addr_id_ex,
					ADDR_RD => rd_addr_id_ex,
					---------- OUTPUTS -----------------
					ULA_RESULT => ula_result_ex_out,
					SIG_EXT_PLUS_PC => pc_plus_sig_ex_out,
					ZERO_ULA => ula_zero_ex_out,
					WB_ADDR_REG => reg_wr_addr_ex_out
				);
				
------------------------------------------------------------------
------------ REG PIPE HERE ---------
--ula_result_ex_mem <= ula_result_ex_out;
--ula_zero_ex_mem <= ula_zero_ex_out;
--pc_plus_sig_ex_mem <= pc_plus_sig_ex_out;
--reg_wr_addr_ex_mem <= reg_wr_addr_ex_out;
--
--data_r2_ex_mem <= data_r2_id_ex;
--
--mem_control_ex_mem <= mem_control_id_ex;
--wb_control_ex_mem <= wb_control_id_ex;
--
--pc_plus_4_ex_mem <= pc_plus_4_id_ex;
--sig_lui_ex_mem <= sig_lui_id_ex;


REG_EX_MEM : entity work.registradorGenerico   generic map (DATA_SIZE => reg_ex_mem_size)
	port map 
	(
		DIN => 
		(
			sig_lui_id_ex & pc_plus_4_id_ex &
			wb_control_id_ex & mem_control_id_ex &
			data_r2_id_ex & reg_wr_addr_ex_out &
			pc_plus_sig_ex_out & ula_result_ex_out &
			ula_zero_ex_out
--			ula_zero_ex_out & ula_result_ex_out & 
--			pc_plus_sig_ex_out & reg_wr_addr_ex_out &
--			data_r2_id_ex & mem_control_id_ex &
--			wb_control_id_ex & pc_plus_4_id_ex &
--			sig_lui_id_ex

		), 
		DOUT => dout_reg_ex_mem, 
		ENABLE => '1', CLK => CLK
	);
	
sig_lui_ex_mem <= dout_reg_ex_mem(reg_ex_mem_size-1 downto 
		(
		DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE + DATA_SIZE + 
		MEM_CONTROL_SIZE + WB_CONTROL_SIZE + DATA_SIZE
		)
);

pc_plus_4_ex_mem <= dout_reg_ex_mem(reg_ex_mem_size - DATA_SIZE -1 downto 
		(
		DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE + DATA_SIZE + 
		MEM_CONTROL_SIZE + WB_CONTROL_SIZE
		)
);

wb_control_ex_mem <= dout_reg_ex_mem(reg_ex_mem_size - DATA_SIZE - DATA_SIZE -1 downto 
		(
		DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE + DATA_SIZE + 
		MEM_CONTROL_SIZE
		)
);

mem_control_ex_mem <= dout_reg_ex_mem(reg_ex_mem_size - DATA_SIZE - DATA_SIZE - WB_CONTROL_SIZE -1 downto 
		(
		DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE + DATA_SIZE
		)
);

data_r2_ex_mem <= dout_reg_ex_mem(
		(
		reg_ex_mem_size - DATA_SIZE - DATA_SIZE - WB_CONTROL_SIZE - MEM_CONTROL_SIZE -1 
		) downto (DATA_SIZE + 1 + DATA_SIZE + REG_ADDR_SIZE)
);

reg_wr_addr_ex_mem <= dout_reg_ex_mem(
		(
		reg_ex_mem_size - DATA_SIZE - DATA_SIZE - 
		WB_CONTROL_SIZE - MEM_CONTROL_SIZE - DATA_SIZE -1 
		) downto (DATA_SIZE + 1 + DATA_SIZE)
);

pc_plus_sig_ex_mem <= dout_reg_ex_mem(
		(
		reg_ex_mem_size - DATA_SIZE - DATA_SIZE - 
		WB_CONTROL_SIZE - MEM_CONTROL_SIZE - DATA_SIZE - REG_ADDR_SIZE -1 
		) downto (DATA_SIZE + 1)
);

ula_result_ex_mem <= dout_reg_ex_mem(
		(
		reg_ex_mem_size - DATA_SIZE - DATA_SIZE - 
		WB_CONTROL_SIZE - MEM_CONTROL_SIZE - DATA_SIZE - 
		REG_ADDR_SIZE - DATA_SIZE -1
		) downto 1
);

ula_zero_ex_mem <= dout_reg_ex_mem(0);

------------------------------------
------------------------------------------------------------------

MEM_PIPE : entity work.MEM_PIPELINE generic map(DATA_SIZE => DATA_SIZE, CONTROL_SIZE => MEM_CONTROL_SIZE ,IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					CONTROL => mem_control_ex_mem,
					ULA_RESULT => ula_result_ex_mem,
					ZERO_ULA => ula_zero_ex_mem,
					DATA_WR => data_r2_ex_mem,
					---------- OUTPUTS -----------------
					DATA_RD => ram_rd_data_mem_out,
					SELECTOR_BRANCH => selector_branch
				);
				
------------------------------------------------------------------
------------ REG PIPE HERE ---------
--wb_control_mem_wb <= wb_control_ex_mem;
--
--ula_result_mem_wb <= ula_result_ex_mem;
--ram_rd_data_mem_wr <= ram_rd_data_mem_out;
--pc_plus_4_mem_wb <= pc_plus_4_ex_mem;
--sig_lui_mem_wb <= sig_lui_ex_mem;

-- reg_wr_addr_mem_wb <= reg_wr_addr_ex_mem;

REG_MEM_WB : entity work.registradorGenerico   generic map (DATA_SIZE => reg_mem_wb_size)
	port map 
	(
		DIN => 
		(
		reg_wr_addr_ex_mem & sig_lui_ex_mem &
		pc_plus_4_ex_mem & ram_rd_data_mem_out &
		ula_result_ex_mem & wb_control_ex_mem
		), 
		DOUT => dout_reg_mem_wb, 
		ENABLE => '1', CLK => CLK
	);
	
reg_wr_addr_mem_wb <= dout_reg_mem_wb(reg_mem_wb_size -1 downto
			(
			WB_CONTROL_SIZE + DATA_SIZE + DATA_SIZE +
			DATA_SIZE + DATA_SIZE
			)
	);
	
sig_lui_mem_wb <= dout_reg_mem_wb(reg_mem_wb_size - REG_ADDR_SIZE -1 downto
			(
			WB_CONTROL_SIZE + DATA_SIZE + DATA_SIZE +
			DATA_SIZE
			)
	);
	
pc_plus_4_mem_wb <= dout_reg_mem_wb(reg_mem_wb_size - REG_ADDR_SIZE - DATA_SIZE -1 downto
			(
			WB_CONTROL_SIZE + DATA_SIZE + DATA_SIZE
			)
	);
	
ram_rd_data_mem_wr <= dout_reg_mem_wb(reg_mem_wb_size - REG_ADDR_SIZE - DATA_SIZE - DATA_SIZE -1 downto
			(
			WB_CONTROL_SIZE + DATA_SIZE
			)
	);
	
ula_result_mem_wb <= dout_reg_mem_wb(reg_mem_wb_size - REG_ADDR_SIZE - DATA_SIZE - DATA_SIZE - DATA_SIZE -1 downto WB_CONTROL_SIZE);
	
wb_control_mem_wb <= dout_reg_mem_wb(reg_mem_wb_size - REG_ADDR_SIZE - DATA_SIZE - DATA_SIZE - DATA_SIZE - DATA_SIZE -1 downto 0);


------------------------------------
------------------------------------------------------------------

WB_PIPE : entity work.WB_PIPELINE generic map(DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
				port map
				(
					CLK => CLK,
					---------- INPUTS ---------------
					SELECTOR_ULA_MEM => wb_control_mem_wb(1 downto 0),
					ULA_RESULT => ula_result_mem_wb,
					DATA_RD => ram_rd_data_mem_wr,
					JAL_ADDR => pc_plus_4_mem_wb,
					LUI_ADDR => sig_lui_mem_wb, 
					---------- OUTPUTS -----------------
					DATA_WR => reg_wr_wb_out
				);


MUX_TEST : entity work.muxGenerico4x1 generic map(DATA_SIZE => DATA_SIZE)
				port map(IN_A => pc_curr, IN_B => ( DATA_SIZE-1 downto REG_ADDR_SIZE => '0' ) & reg_wr_addr_mem_wb, IN_C => ula_result_ex_out, IN_D => reg_wr_wb_out , SELECTOR => SW(SW_N-1 downto SW_N-2) ,DATA_OUT => signal_teste);
				
HEX_LED : entity work.displaysController generic map (DATA_SIZE => DATA_SIZE)
				port map(DATA_IN => signal_teste, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, LED_0_3 => LEDR(3 downto 0), LED_4_7 => LEDR(7 downto 4));
				
LEDR(8) <= wb_control_mem_wb(2);
LEDR(9) <= ula_zero_ex_out;

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
