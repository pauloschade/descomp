library ieee;
use ieee.std_logic_1164.all;

entity EX_PIPELINE is
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
	 --	GENERAL
	 
	 --	ID
	 SELECTOR_R3 : in std_logic_vector(1 downto 0);
	 ULA_OP : in std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 SELECTOR_RT_OR_IMEDIATO : in std_logic;
	 
	 -- REGS
	 SIG_EXT : in std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_R1 : in std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_R2 : in std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 ADDR_RT : in std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 ADDR_RD : in std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 
	 -- OUT
	 --	MEM
	 MEM_SIG_EXT_PC_PLUS_4 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 MEM_ZERO_ULA : out std_logic_vector(DATA_SIZE-1 downto 0);
	 MEM_ULA_RESULT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --	WB
	 WB_ADDR_REG : out std_logic_vector(REG_ADDR_SIZE-1 downto 0)
	 
	 
  );
end entity;

architecture arquitetura of EX_PIPELINE is

signal rt_or_imediato : std_logic_vector(DATA_SIZE-1 downto 0);

begin

SOMADOR :  entity work.somadorGenerico  generic map (DATA_SIZE => DATA_SIZE)
	port map( IN_A => pc_plus_4, IN_B => sig_ext_shifted, DATA_OUT => pc_plus_sig_ext);

MUX_RT_OR_IMEDIATO : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map ( IN_A => DATA_R2, IN_B => SIG_EXT, MUX_SELECTOR => SELECTOR_RT_OR_IMEDIATO, DATA_OUT => rt_or_imediato );
	
ULA : entity work.ULASomaSub  generic map(DATA_SIZE => DATA_SIZE, SELECTOR_SIZE => ULA_SELECTOR_SIZE)
          port map (IN_A => DATA_R1, IN_B => rt_or_imediato, SELECTOR => ULA_OP, FLAG_Z => MEM_ZERO_ULA ,DATA_OUT => MEM_ULA_RESULT);

MUX_RT_RD_JAL : entity work.muxGenerico4x1  generic map (DATA_SIZE => REG_ADDR_SIZE)
	port map ( IN_A => ADDR_RT, IN_B => ADDR_RD, IN_C => 5x"1F", IN_D => 5x"00", SELECTOR => SELECTOR_R3, DATA_OUT => WB_ADDR_REG );

end architecture;