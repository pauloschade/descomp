library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity IF_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32; -- TAMANHO DA INSTRUCAO
	 IMEDIATO_SIZE : natural := 26 -- TAMANHO DO IMEDIATO
  );
  port   (
	 CLK : in std_logic;
	 --------------- INPUT -------------------------------------
	 --	ID
	 IMEDIATO : in std_logic_vector(IMEDIATO_SIZE-1 downto 0); -- 26 bits
	 BEQ_JMP_SELECTOR : in std_logic; -- 1 bit
	 JR_ADDR : in std_logic_vector(DATA_SIZE-1 downto 0); -- 32 bits

	 JR_SELECTOR : in std_logic; -- 1 bit, DEFINE SE REALIZARÁ O JUMP OU O JR
	 SIG_EXT_PLUS_PC : in std_logic_vector(DATA_SIZE-1 downto 0); -- 32 bits + PC + 4
	 SELECTOR_BRANCH : in std_logic; -- 1 bit, MUX ESCOLHE SE USA PC+4 OU PC+IMEDIATO
	 -- SINAL QUE SAI DO FINAL E VEM PARA IF

	 --------------- OUTPUT ------------------------------------
	 --	TEST
	 PC_CURR : out std_logic_vector(DATA_SIZE-1 downto 0); -- para o o mux de teste
	 --	EXEC
	 EX_PC_PLUS_4 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 --	ID
	 INSTRUCTION : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of IF_PIPELINE is

	-- SINAIS ETERNOS DA ETAPA

	---------------------- TYPE I ---------------------------------
	signal pc_beq_addr : std_logic_vector(DATA_SIZE-1 downto 0); -- PC DESTINO DO BEQ
	signal pc_in : std_logic_vector(DATA_SIZE-1 downto 0); -- ENTRADA DO PC
	signal pc_out : std_logic_vector(DATA_SIZE-1 downto 0); -- SAIDA DO PC
	signal pc_plus_4 : std_logic_vector(DATA_SIZE-1 downto 0); -- PC + 4
	signal pc_plus_sig_ext : std_logic_vector(DATA_SIZE-1 downto 0); -- PC + 4 + IMEDIATO ESTENDIDO
	
	---------------------- TYPE J ---------------------------------
	signal imediato_shifted : std_logic_vector(IMEDIATO_SIZE-1 downto 0); -- IMEDIATO SHIFTADO PARA OS BITS QUE INTERESSAM
	signal jmp_addr : std_logic_vector(DATA_SIZE-1 downto 0); -- DESTINO DO JUMP
	signal beq_jmp_addr  : std_logic_vector(DATA_SIZE-1 downto 0); -- DESTINO DO BEQ OU JUMP

begin

-- MUX DE 2 PORTAS
-- USA O PONTO DE CONTROLE DO BEQ E ATUA COMO SELETOR PRA VER SE O PC 
-- VAI PARA O PC+4 OU PARA O PC+IMEDIATO EXTENDIDO
MUX_BEQ : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_plus_4, IN_B => SIG_EXT_PLUS_PC, MUX_SELECTOR => SELECTOR_BRANCH, DATA_OUT => pc_beq_addr );
	
-- INCREMENTA 4 AO PC
incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => DATA_SIZE, constante => 4)
        port map( entrada => pc_out, saida => pc_plus_4);
	
-- REGISTRADOR GENÉRICO PC
PC : entity work.registradorGenerico   generic map (DATA_SIZE => DATA_SIZE)
	port map (DIN => pc_in, DOUT => pc_out, ENABLE => '1', CLK => CLK);
	
-- MUX DE 2 PORTAS
-- ESCOLHE SE VAI FAZER JUMP
MUX_BEQ_JMP : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => pc_beq_addr, IN_B => jmp_addr, MUX_SELECTOR => BEQ_JMP_SELECTOR, DATA_OUT => beq_jmp_addr );

-- MUX DE 2 PORTAS
-- USA JR DE SELETOR SE FAZ O JUMP COM DADO LIDO NO REG
-- OU COM O QUE VEM DO MUX DO BEQ/JUMP
MUX_JR : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => beq_jmp_addr, IN_B => JR_ADDR, MUX_SELECTOR => JR_SELECTOR, DATA_OUT => pc_in);
	
-- PARA O .MIF
ROM : entity work.ROMMIPS_MIF   generic map  (dataWidth => DATA_SIZE, addrWidth => DATA_SIZE)
          port map (ADDR => pc_out, DATA_OUT => INSTRUCTION);

	

--------------------------------------------------------------------------------

--------- jmp  -----------
jmp_addr(DATA_SIZE-1 downto 28) <= pc_plus_4(DATA_SIZE-1 downto 28); -- 4 bits mais significativos
jmp_addr(27 downto 2) <= IMEDIATO(IMEDIATO_SIZE-1 downto 0); -- 26 bits menos significativos
jmp_addr(1 downto 0) <= "00"; -- 2 bits menos significativos
---------------------------
-- jump concatena tudo isso  

--------------------------------------------------------------------------------

------------PC DATA OUT-----------
PC_CURR <= pc_out;
EX_PC_PLUS_4 <= pc_plus_4;
----------------------------------

end architecture;