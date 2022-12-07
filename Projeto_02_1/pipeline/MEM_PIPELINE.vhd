library ieee;
use ieee.std_logic_1164.all;

-- VE SE FAZ O PULO D0 BEQ OU DO BNE - BRANCH

-- ACESSA OS DADOS NA MEMORIA, COM LW OU SW

-- SAEM ALGUNS PONTOS PRO WB

-- FORWARD DO ENDEREÇO DE ESCRITA DE REGISTRADOR PARA REGISTRADOR


entity MEM_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
   DATA_SIZE : natural := 32;
	 REG_ADDR_SIZE : natural := 5;
	 CONTROL_SIZE : natural := 4;
	 OPCODE_SIZE : natural := 6;
	 ULA_SELECTOR_SIZE : natural := 4;
	 IMEDIATO_SIZE : natural := 16;
	 FUNC_SIZE : natural := 6
	 
  );
  port   (
	 CLK : in std_logic;
	 
	 ----------- INPUTS -------------
--	 BEQ_OR_BNE : in std_logic;
--	 BEQ			: in std_logic;
--	 WR_RAM : in std_logic;
--	 RD_RAM : in std_logic;
	 CONTROL : in std_logic_vector(CONTROL_SIZE-1 downto 0);
	 
	 -- FLAG ZERO DA ULA
	 ZERO_ULA : in std_logic;
	 ULA_RESULT : in std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 DATA_WR		: in std_logic_vector(DATA_SIZE-1 downto 0);
	
	 ---------- OUTPUTS -------------
	 SELECTOR_BRANCH : out std_logic;
	 DATA_RD : out std_logic_vector(DATA_SIZE-1 downto 0)
	 
  );
end entity;

architecture arquitetura of MEM_PIPELINE is

signal branch_sig : std_logic;

signal bne_or_beq : std_logic;
signal beq			: std_logic;
signal wr_ram		: std_logic;
signal rd_ram		: std_logic;

begin

MUX_BEQ_BNE : entity work.MUX2x1
	port map ( IN_A => not(ZERO_ULA), IN_B => ZERO_ULA, SELECTOR => beq, DATA_OUT => branch_sig );

RAM : entity work.RAMMIPS  generic map(DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => DATA_SIZE)
          port map (CLK => CLK, ADDR => ULA_RESULT, DATA_IN => DATA_WR, DATA_OUT => DATA_RD, we => wr_ram, re => rd_ram, ENABLE => '1' );
			 
			 
-------------------------------------
wr_ram <= CONTROL(0);
rd_ram <= CONTROL(1);
bne_or_beq <= CONTROL(2);
beq <= CONTROL(3);
-------------- OUTPUTS --------------
SELECTOR_BRANCH <= branch_sig and bne_or_beq;
-------------------------------------

end architecture;