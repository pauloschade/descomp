library ieee;
use ieee.std_logic_1164.all;

entity Aula13 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 OPCODE_SIZE : natural := 4;
	 INSTRUCTIONS_SIZE : natural := 13;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
	 KEY_IN : in std_logic;
	 PC_ADDR : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RS_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RT_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_RD_OUT : out std_logic_vector(ADDRESS_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of Aula13 is

	signal CLK : std_logic;

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

CPU : entity work.CPU   generic map (DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => ADDRESS_SIZE)
			 port map (
				 CLK => CLK,
				 PC_ADDR => PC_ADDR,
				 DATA_RS_OUT => DATA_RS_OUT,
				 DATA_RT_OUT => DATA_RT_OUT,
				 DATA_RD_OUT => DATA_RD_OUT
				);

end architecture;