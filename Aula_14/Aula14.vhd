library ieee;
use ieee.std_logic_1164.all;

entity Aula14 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 OPCODE_SIZE : natural := 4;
	 INSTRUCTIONS_SIZE : natural := 13;
	 CONTROL_SIZE : natural := 11;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
	 KEY_IN : in std_logic;
	 
	 PC_ADDRR : out std_logic_vector(DATA_SIZE-1 downto 0);
	 REG1_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 REG2_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 PC_DATA : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_WR : out std_logic_vector(DATA_SIZE-1 downto 0)
	 
  );
end entity;


architecture arquitetura of Aula14 is

	signal CLK : std_logic;
	signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	signal beq : std_logic;
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY_IN;                       
else generate
--detectorSub0: work.edgeDetector(bordaSubida)
--        port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => CLK);
CLK <= KEY_IN;
end generate;

CPU : entity work.CPU   generic map (DATA_SIZE => DATA_SIZE)
			 port map (
				 CLK => CLK,
				 INSTRUCTION => rom_out,
				 SIG_EXT_OUT => sig_ext,
				 
				 ---TEST
				 data_r1_out  => REG1_OUT,
				 data_r2_out  => REG2_OUT,
				 data_rwr_out => DATA_WR,
				 
				 BEQ_AND_ZERO => beq
				);
ROM : entity work.ROMController generic map (DATA_SIZE => DATA_SIZE)
			 port map (
				 CLK => CLK,
				 SIG_EXT => sig_ext,
				 MUX_SELECTOR => beq,
				 PC_CURR => PC_DATA,
				 DATA_OUT => rom_out
				);

end architecture;