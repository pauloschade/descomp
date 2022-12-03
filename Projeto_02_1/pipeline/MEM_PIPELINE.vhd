library ieee;
use ieee.std_logic_1164.all;

entity MEM_PIPELINE is
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
	 
	 ----------- INPUTS -------------
	 BEQ_OR_BNE : in std_logic;
	 BEQ			: in std_logic;
	 WR_RAM : in std_logic;
	 RD_RAM : in std_logic;
	 
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

--signal rt_or_imediato : std_logic_vector(DATA_SIZE-1 downto 0);

begin

MUX_BEQ_BNE : entity work.MUX2x1
	port map ( IN_A => not(ZERO_ULA), IN_B => ZERO_ULA, SELECTOR => BEQ, DATA_OUT => branch_sig );

RAM : entity work.RAMMIPS  generic map(DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => DATA_SIZE)
          port map (CLK => CLK, ADDR => ULA_RESULT, DATA_IN => DATA_WR, DATA_OUT => DATA_RD, we => WR_RAM, re => RD_RAM, ENABLE => '1' );
			 
			 
-------------------------------------
-------------- OUTPUTS --------------
SELECTOR_BRANCH <= branch_sig and BEQ_OR_BNE;
-------------------------------------

end architecture;