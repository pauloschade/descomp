library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity ROMController is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 IMEDIATO_SIZE : natural := 26;
	 SHIFT_AMMOUNT : natural := 2
  );
  port   (
	 CLK : in std_logic;
	 SIG_EXT : in std_logic_vector(DATA_SIZE-1 downto 0);
	 MUX_SELECTOR : in std_logic;
	 IMEDIATO : in std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	 MUX_BEQ_JMP_SELECTOR : in std_logic;
	 MUX_JR_SELECTOR : in std_logic;
	 JR_ADDR : in std_logic_vector(DATA_SIZE-1 downto 0);
	 PC_CURR : out std_logic_vector(DATA_SIZE-1 downto 0);
	 PC_PLUS_4_JAL : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of ROMController is

	---------------------- TYPE I ---------------------------------
	signal sig_ext_shifted : std_logic_vector(DATA_SIZE-1 downto 0);
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
	port map (IN_A => pc_plus_4, IN_B => pc_plus_sig_ext, MUX_SELECTOR => MUX_SELECTOR, DATA_OUT => pc_beq_addr );
	
SOMADOR :  entity work.somadorGenerico  generic map (DATA_SIZE => DATA_SIZE)
	port map( IN_A => pc_plus_4, IN_B => sig_ext_shifted, DATA_OUT => pc_plus_sig_ext);
	
incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => DATA_SIZE, constante => 4)
        port map( entrada => pc_out, saida => pc_plus_4);
	
PC : entity work.registradorGenerico   generic map (DATA_SIZE => DATA_SIZE)
	port map (DIN => pc_in, DOUT => pc_out, ENABLE => '1', CLK => CLK);
	
MUX_BEQ_JMP : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_beq_addr, IN_B => jmp_addr, MUX_SELECTOR => MUX_BEQ_JMP_SELECTOR, DATA_OUT => beq_jmp_addr );

MUX_JR : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => beq_jmp_addr, IN_B => JR_ADDR, MUX_SELECTOR => MUX_JR_SELECTOR, DATA_OUT => pc_in);
	
--ROM : entity work.ROMMIPS   generic map (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
--          port map (ADDR => pc_out, DATA_OUT => DATA_OUT);

ROM : entity work.ROMMIPS_MIF   generic map  (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
          port map (ADDR => pc_out, DATA_OUT => DATA_OUT);

	

--------------------------------------------------------------------------------

--------- jmp a -----------
jmp_addr(DATA_SIZE-1 downto 28) <= pc_plus_4(DATA_SIZE-1 downto 28);
jmp_addr(27 downto 2) <= imediato_shifted(IMEDIATO_SIZE-1 downto 0);
jmp_addr(1 downto 0) <= "00";
---------------------------
--------- shift -----------
imediato_shifted <= std_logic_vector(shift_left(unsigned(IMEDIATO), SHIFT_AMMOUNT));
sig_ext_shifted <= std_logic_vector(shift_left(unsigned(SIG_EXT), SHIFT_AMMOUNT));
---------------------------
--------------------------------------------------------------------------------

------------PC DATA OUT-----------
PC_CURR <= pc_out;
PC_PLUS_4_JAL <= pc_plus_4;
----------------------------------

end architecture;