library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity IF_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 IMEDIATO_SIZE : natural := 26
  );
  port   (
	 CLK : in std_logic;
	 --------------- INPUT -------------------------------------
	 --	ID
	 IMEDIATO : in std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	 BEQ_JMP_SELECTOR : in std_logic;
	 JR_ADDR : in std_logic_vector(DATA_SIZE-1 downto 0);

	 JR_SELECTOR : in std_logic;
	 SIG_EXT_PLUS_PC : in std_logic_vector(DATA_SIZE-1 downto 0);
	 SELECTOR_BRANCH : in std_logic;
	 --------------- OUTPUT ------------------------------------
	 --	TEST
	 PC_CURR : out std_logic_vector(DATA_SIZE-1 downto 0);
	 --	EXEC
	 EX_PC_PLUS_4 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --	ID
	 INSTRUCTION : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of IF_PIPELINE is

	---------------------- TYPE I ---------------------------------
	signal pc_beq_addr : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_in : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_out : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_plus_4 : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_plus_sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	
	---------------------- TYPE J ---------------------------------
	signal imediato_shifted : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	signal jmp_addr : std_logic_vector(DATA_SIZE-1 downto 0);
	signal beq_jmp_addr  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

MUX_BEQ : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_plus_4, IN_B => SIG_EXT_PLUS_PC, MUX_SELECTOR => SELECTOR_BRANCH, DATA_OUT => pc_beq_addr );

--- MOVE TO EXEC ----------------------------------
--SOMADOR :  entity work.somadorGenerico  generic map (DATA_SIZE => DATA_SIZE)
--	port map( IN_A => pc_plus_4, IN_B => sig_ext_shifted, DATA_OUT => pc_plus_sig_ext);
---------------------------------------------------	
	
incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => DATA_SIZE, constante => 4)
        port map( entrada => pc_out, saida => pc_plus_4);
	
PC : entity work.registradorGenerico   generic map (DATA_SIZE => DATA_SIZE)
	port map (DIN => pc_in, DOUT => pc_out, ENABLE => '1', CLK => CLK);
	
MUX_BEQ_JMP : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_beq_addr, IN_B => jmp_addr, MUX_SELECTOR => BEQ_JMP_SELECTOR, DATA_OUT => beq_jmp_addr );

MUX_JR : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => beq_jmp_addr, IN_B => JR_ADDR, MUX_SELECTOR => JR_SELECTOR, DATA_OUT => pc_in);
	
--ROM : entity work.ROMMIPS   generic map (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
--          port map (ADDR => pc_out, DATA_OUT => DATA_OUT);

ROM : entity work.ROMMIPS_MIF   generic map  (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
          port map (ADDR => pc_out, DATA_OUT => INSTRUCTION);

	

--------------------------------------------------------------------------------

--------- jmp a -----------
jmp_addr(DATA_SIZE-1 downto 28) <= pc_plus_4(DATA_SIZE-1 downto 28);
jmp_addr(27 downto 2) <= IMEDIATO(IMEDIATO_SIZE-1 downto 0);
jmp_addr(1 downto 0) <= "00";
---------------------------
--------------------------------------------------------------------------------

------------PC DATA OUT-----------
PC_CURR <= pc_out;
EX_PC_PLUS_4 <= pc_plus_4;
----------------------------------

end architecture;