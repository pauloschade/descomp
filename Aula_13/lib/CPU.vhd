library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 REG_ADDR_SIZE : natural := 5;
	 OPCODE_SIZE : natural := 6;
	 funcSIZE : natural := 6;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	 CLK : in std_logic;
    PC_ADDR : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RS_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RT_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RD_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of CPU is
	signal pc_in : std_logic_vector(ADDRESS_SIZE-1 downto 0);
	signal pc_out : std_logic_vector(ADDRESS_SIZE-1 downto 0);
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rs : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	
	signal data_rs : std_logic_vector(DATA_SIZE-1 downto 0);
	signal data_rt : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal ULA_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal func : std_logic_vector(funcSIZE-1 downto 0);
	signal opcode : std_logic_vector(OPCODE_SIZE-1 downto 0);

begin

PC : entity work.registradorGenerico   generic map (DATA_SIZE => ADDRESS_SIZE)
          port map (DIN => pc_in, DOUT => pc_out, ENABLE => '1', CLK => CLK);

incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => ADDRESS_SIZE, constante => 4)
        port map( entrada => pc_out, saida => pc_in);

ROM : entity work.ROMMIPS   generic map (dataWidth => DATA_SIZE, addrWidth => ADDRESS_SIZE)
          port map (ADDR => pc_out, DATA_OUT => rom_out);
			 

REGS : entity work.bancoReg   generic map (DATA_SIZE => DATA_SIZE, REG_ADDR_SIZE => REG_ADDR_SIZE)
          port map 
			(  CLK => CLK,
				ADDR_A => rs, ADDR_B => rt, ADDR_C => rd,
				DATA_WR => ULA_out,
				OUT_A => data_rs, OUT_B => data_rt
			);
ULA : entity work.ULASomaSub  generic map(DATA_SIZE => DATA_SIZE, SELECTOR_SIZE => funcSIZE)
          port map (entradaA => data_rs, entradaB => data_rt, seletor => func, saida => ULA_out);


opcode <= rom_out(31 downto 26);
rs <= rom_out(25 downto 21);
rt <= rom_out(20 downto 16);
rd <= rom_out(15 downto 11);
func <= rom_out(5 downto 0);


--------
PC_ADDR <= pc_out;
DATA_RS_OUT <= data_rs;
DATA_RT_OUT <= data_rt;
DATA_RD_OUT <= ULA_out;


end architecture;