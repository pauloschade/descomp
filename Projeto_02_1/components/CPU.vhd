library ieee;
use ieee.std_logic_1164.all;

entity CPU is
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
	 INSTRUCTION : in std_logic_vector(DATA_SIZE-1 downto 0);
	 CONTROL : in std_logic_vector(CONTROL_SIZE-1 downto 0);
	 ULA_OP : in std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 JAL_ADDR : in std_logic_vector(DATA_SIZE-1 downto 0);
	 --OUT
	 OPCODE : out std_logic_vector(OPCODE_SIZE-1 downto 0);
	 FUNC : out std_logic_vector(FUNC_SIZE-1 downto 0);
	 SIG_EXT_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --TEST
	 data_ula_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 data_r1_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 data_r2_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 data_rwr_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 ------
	 
	 IS_BEQ_OR_BNE : out std_logic
  );
end entity;


architecture arquitetura of CPU is
	signal pc_in : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rs : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal reg_3_addr : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	
	signal data_out_rs : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_out_rt : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_write_R3 : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal ULA_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal data_rt_or_sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal flag_zero : std_logic;
	
	signal data_ram_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal lui : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal bne_or_beq_mux_out : std_logic;
	
	------- CONTROL sigs-------------------------------------------
	signal wr_ram : std_logic;
	signal rd_ram : std_logic;
	signal bne_or_beq : std_logic;
	signal beq : std_logic;
	signal mux_ula_mem : std_logic_vector(1 downto 0);
	signal mux_rt_imediato_selector : std_logic;
	signal ula_op_selector : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	signal wr_reg : std_logic;
	signal ori_andi : std_logic;
	signal mux_r3_selector : std_logic_vector(1 downto 0);
	---------------------------------------------------------------
	

begin

MUX_RT_RD_JAL : entity work.muxGenerico4x1  generic map (DATA_SIZE => REG_ADDR_SIZE)
	port map ( IN_A => rt, IN_B => rd, IN_C => 5x"1F", IN_D => 5x"00", SELECTOR => mux_r3_selector, DATA_OUT => reg_3_addr );

ESTENDE : entity work.estendeSinalGenerico  generic map (DATA_IN_SIZE => IMEDIATO_SIZE, DATA_OUT_SIZE => DATA_SIZE)
	port map ( DATA_IN => imediato, SELECTOR => ori_andi, DATA_OUT => sig_ext );
	
REGS : entity work.bancoReg generic map (DATA_SIZE => DATA_SIZE, REG_ADDR_SIZE => REG_ADDR_SIZE)
          port map 
			(  CLK => CLK,
				ADDR_A => rs, ADDR_B => rt, ADDR_C => reg_3_addr,
				DATA_WR => data_write_R3,
				OUT_A => data_out_rs, OUT_B => data_out_rt,
				ENABLE_WR => wr_reg
			);
			


MUX_RT_OR_IMEDIATO : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map ( IN_A => data_out_rt, IN_B => sig_ext, MUX_SELECTOR => mux_rt_imediato_selector, DATA_OUT => data_rt_or_sig_ext );
			
ULA : entity work.ULASomaSub  generic map(DATA_SIZE => DATA_SIZE, SELECTOR_SIZE => ULA_SELECTOR_SIZE)
          port map (IN_A => data_out_rs, IN_B => data_rt_or_sig_ext, SELECTOR => ULA_OP, FLAG_Z => flag_zero ,DATA_OUT => ULA_out);
			 
MUX_BEQ_BNE : entity work.MUX2x1
	port map ( IN_A => not(flag_zero), IN_B => flag_zero, SELECTOR => beq, DATA_OUT => bne_or_beq_mux_out );
			 
			 
RAM : entity work.RAMMIPS  generic map(DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => DATA_SIZE)
          port map (CLK => CLK, ADDR => ULA_out, DATA_IN => data_out_rt, DATA_OUT => data_ram_out, we => wr_ram, re => rd_ram, ENABLE => '1' );
			 
MUX_ULA_OR_RAM : entity work.muxGenerico4x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => ULA_out, IN_B => data_ram_out, IN_C => JAL_ADDR, IN_D => lui, SELECTOR => mux_ula_mem, DATA_OUT => data_write_R3 );		
			 
--------------------------------------------------------------------------------

----------------- TYPE R -------------------
OPCODE <= INSTRUCTION(31 downto 26);
rs <= INSTRUCTION(25 downto 21);
rt <= INSTRUCTION(20 downto 16);
rd <= INSTRUCTION(15 downto 11);
FUNC <= INSTRUCTION(5 downto 0);
--------------------------------------------

----------------- TYPE I -------------------
imediato <= INSTRUCTION(15 downto 0);
--------------------------------------------

------------------ LUI ---------------------
lui <= imediato & ( DATA_SIZE-IMEDIATO_SIZE-1 downto 0 => '0' );
--------------------------------------------


------------------------------ CONTROL ----------------------------------------
wr_ram <= CONTROL(0);
rd_ram <= CONTROL(1);
bne_or_beq <= CONTROL(2);
beq <= CONTROL(3);
mux_ula_mem <= CONTROL(5 downto 4);
mux_rt_imediato_selector <= CONTROL(6);
wr_reg  <= CONTROL(7);
ori_andi <= CONTROL(8);
mux_r3_selector <= CONTROL(10 downto 9);
-------------------------------------------------------------------------------

---- OUT
IS_BEQ_OR_BNE <= bne_or_beq_mux_out and bne_or_beq;
SIG_EXT_OUT <= sig_ext;


-------TEST
data_ula_out <= ULA_out;
data_r1_out <= data_out_rs;
data_r2_out <= data_out_rt;
data_rwr_out <= data_write_R3;
----------

end architecture;