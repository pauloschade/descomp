library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity ROMController is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 SHIFT_AMMOUNT : natural := 2
  );
  port   (
	 CLK : in std_logic;
	 SIG_EXT : in std_logic_vector(DATA_SIZE-1 downto 0);
	 MUX_SELECTOR : in std_logic;
	 PC_CURR : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of ROMController is
	signal sig_ext_shifted : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_in : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_out : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_plus_4 : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_plus_sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);

begin

PC : entity work.registradorGenerico   generic map (DATA_SIZE => DATA_SIZE)
	port map (DIN => pc_in, DOUT => pc_out, ENABLE => '1', CLK => CLK);
	
incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => DATA_SIZE, constante => 4)
        port map( entrada => pc_out, saida => pc_plus_4);

SOMADOR :  entity work.somadorGenerico  generic map (DATA_SIZE => DATA_SIZE)
	port map( IN_A => pc_plus_4, IN_B => sig_ext_shifted, DATA_OUT => pc_plus_sig_ext);

MUX : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_plus_4, IN_B => pc_plus_sig_ext, MUX_SELECTOR => MUX_SELECTOR, DATA_OUT => pc_in );
	
ROM : entity work.ROMMIPS   generic map (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
          port map (ADDR => pc_out, DATA_OUT => DATA_OUT);
	

--------------------------------------------------------------------------------
sig_ext_shifted <= std_logic_vector(shift_left(unsigned(SIG_EXT), SHIFT_AMMOUNT));
--------------------------------------------------------------------------------

PC_CURR <= pc_out;

end architecture;