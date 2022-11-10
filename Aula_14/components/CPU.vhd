library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 REG_ADDR_SIZE : natural := 5;
	 CONTROL_SIZE : natural := 11;
	 opcode_SIZE : natural := 6;
	 ULA_SELECTOR_SIZE : natural := 4;
	 IMEDIATO_SIZE : natural := 16;
	 funcSIZE : natural := 6;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	 CLK : in std_logic;
	 INSTRUCTION : in std_logic_vector(DATA_SIZE-1 downto 0);
	 SIG_EXT_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --TEST
	 data_r1_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 data_r2_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 data_rwr_out : out std_logic_vector(DATA_SIZE-1 downto 0);
	 ------
	 
	 BEQ_AND_ZERO : out std_logic
  );
end entity;


architecture arquitetura of CPU is
	signal pc_in : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rs : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt_or_rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	
	signal opcode : std_logic_vector(opcode_SIZE-1 downto 0);
	signal func : std_logic_vector(funcSIZE-1 downto 0);
	
	signal data_out_rs : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_out_rt : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_write_R3 : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal ULA_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal data_rt_or_sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal flag_zero : std_logic;
	
	signal data_ram_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal control : std_logic_vector(CONTROL_SIZE-1 downto 0);
	------- control sigs-------------------------------------------
	signal wr_ram : std_logic;
	signal rd_ram : std_logic;
	signal beq : std_logic;
	signal mux_ula_ram_selector : std_logic;
	signal ula_op_selector : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	signal mux_rt_imediato_selector : std_logic;
	signal wr_reg : std_logic;
	signal mux_rt_rd_selector : std_logic;
	---------------------------------------------------------------
	

begin

MUX_RT_OR_RD : entity work.generic_MUX_2x1  generic map (DATA_SIZE => REG_ADDR_SIZE)
	port map (IN_A => rt, IN_B => rd, MUX_SELECTOR => mux_rt_rd_selector, DATA_OUT => rt_or_rd );

ESTENDE : entity work.estendeSinalGenerico  generic map (DATA_IN_SIZE => IMEDIATO_SIZE, DATA_OUT_SIZE => DATA_SIZE)
	port map (DATA_IN => imediato, DATA_OUT => sig_ext );
	
REGS : entity work.bancoReg generic map (DATA_SIZE => DATA_SIZE, REG_ADDR_SIZE => REG_ADDR_SIZE)
          port map 
			(  CLK => CLK,
				ADDR_A => rs, ADDR_B => rt, ADDR_C => rt_or_rd,
				DATA_WR => data_write_R3,
				OUT_A => data_out_rs, OUT_B => data_out_rt,
				ENABLE_WR => wr_reg
			);
			


MUX_RT_OR_IMEDIATO : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => data_out_rt, IN_B => sig_ext, MUX_SELECTOR => mux_rt_imediato_selector ,DATA_OUT => data_rt_or_sig_ext );
			
ULA : entity work.ULASomaSub  generic map(DATA_SIZE => DATA_SIZE, SELECTOR_SIZE => ULA_SELECTOR_SIZE)
          port map (IN_A => data_out_rs, IN_B => data_rt_or_sig_ext, SELECTOR => ula_op_selector, FLAG_Z => flag_zero ,DATA_OUT => ULA_out);
			 
RAM : entity work.RAMMIPS  generic map(DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => DATA_SIZE)
          port map (CLK => CLK, ADDR => ULA_out, DATA_IN => data_out_rt, DATA_OUT => data_ram_out, we => wr_ram, re => rd_ram, ENABLE => '1' );
			 
MUX_ULA_OR_RAM : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => ULA_out, IN_B => data_ram_out, MUX_SELECTOR => mux_ula_ram_selector, DATA_OUT => data_write_R3 );		
	

DECODER : entity work.decoderInstru  generic map (OPCODE_SIZE => OPCODE_SIZE, CONTROL_SIZE => CONTROL_SIZE)
	port map (OPCODE => opcode, DATA_OUT => control);		
			 
--------------------------------------------------------------------------------

----------------- TYPE R -------------------
opcode <= INSTRUCTION(31 downto 26);
rs <= INSTRUCTION(25 downto 21);
rt <= INSTRUCTION(20 downto 16);
rd <= INSTRUCTION(15 downto 11);
func <= INSTRUCTION(5 downto 0);
--------------------------------------------

----------------- TYPE I -------------------
imediato <= INSTRUCTION(15 downto 0);
--------------------------------------------


----------------- control ------------------
wr_ram <= control(0);
rd_ram <= control(1);
beq <= control(2);
mux_ula_ram_selector <= control(3);
ula_op_selector <= control(7 downto 4);
mux_rt_imediato_selector <= control(8);
wr_reg  <= control(9);
mux_rt_rd_selector <= control(10);
--------------------------------------------------------------------------------

---- OUT
BEQ_AND_ZERO <= beq and flag_zero;
SIG_EXT_OUT <= sig_ext;


-------TEST
data_r1_out <= data_out_rs;
data_r2_out <= data_out_rt;
data_rwr_out <= data_write_R3;
----------

end architecture;