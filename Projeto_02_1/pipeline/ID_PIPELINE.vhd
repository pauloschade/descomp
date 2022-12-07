library ieee;
use ieee.std_logic_1164.all;

-- TEM TODOS OS REGISTRADORES, POSSO LER E ESCREVER NELES
-- DECODIFICAÇÃO DOS PONTOS DE CONTROLE
-- EXTENSÃO DO SINAL

-- PASSA O PC + 4 DE UM REG PRA OUTRO, ELE NEM CHEGA A ENTRAR NO ID EM SI
-- SAI DELE OS CONTROLES QUE VAO PARA WB, EX, MEM

-- SÓ PRA ETAPA DE EX VAI OS DADOS LIDOS DO REG 1, REG 2, O SINAL ESTENDIDO E OS ENDEREÇOS DE RT E DE RD 

-- DADO LIDO NO REG 2 TAMBEM VAI PRA ETAPA DE MEMORY ACCESS

entity ID_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32; -- 32 bits padrao
	 REG_ADDR_SIZE : natural := 5; -- 5 bits do endereço do registrador
	 CONTROL_SIZE : natural := 13; -- 13 bits de controle
	 OPCODE_SIZE : natural := 6; -- 6 bits do opcode
	 ULA_SELECTOR_SIZE : natural := 4; -- 4 bits do seletor da ula
	 IMEDIATO_SIZE : natural := 16; -- 16 bits do imediato
	 FUNC_SIZE : natural := 6 -- 6 bits do func
	 
  );
  port   (
	 CLK : in std_logic;
	 -- IN
	 
	 --	Buscada na etapa IF
	 INSTRUCTION : in std_logic_vector(DATA_SIZE-1 downto 0);
	 -- Veio da etapa WB
	 ENABLE_REG_WR : in std_logic;
	 ADDR_REG : in std_logic_vector(REG_ADDR_SIZE-1 downto 0); 
	 DATA_WR : in std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 -- Saída da ULA
	 -- OUT CONTROL 
	 CONTROL : out std_logic_vector(CONTROL_SIZE-1 downto 0);
	 ULA_OP  : out std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	 
	 -- 26 bits de jump pro imediato
	 -- OUT JMP
	 IMEDIATO_JMP : out std_logic_vector(25 downto 0);
	 
	 --OUT REGS
	 SIG_EXT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 SIG_LUI : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 DATA_R1 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_R2 : out std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 -- endereços dos registradores
	 ADDR_RT : out std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	 ADDR_RD : out std_logic_vector(REG_ADDR_SIZE-1 downto 0)
  );
end entity;

architecture arquitetura of ID_PIPELINE is

	signal control_all : std_logic_vector(CONTROL_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	signal ori_andi : std_logic;
	
	--------------------- REGS ---------------------------
	signal rd : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rs : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	signal rt : std_logic_vector(REG_ADDR_SIZE-1 downto 0);
	------------------------------------------------------
	signal opcode : std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal func : std_logic_vector(FUNC_SIZE-1 downto 0);
	

begin

-- DECODIFICAÇÃO DOS PONTOS DE CONTROLE
DECODER : entity work.decoderMaster  generic map (OPCODE_SIZE => OPCODE_SIZE, FUNC_SIZE => FUNC_SIZE, ULA_SELECTOR_SIZE => ULA_SELECTOR_SIZE, CONTROL_SIZE => CONTROL_SIZE)
	port map (OPCODE => opcode, FUNC => func, CONTROL_DATA => control_all, ULA_OP => ULA_OP);
	
-- BANCO DE REGISTRADORES	
REGS : entity work.bancoReg generic map (DATA_SIZE => DATA_SIZE, REG_ADDR_SIZE => REG_ADDR_SIZE)
          port map 
			(  CLK => CLK,
				ADDR_A => rs, ADDR_B => rt, ADDR_C => ADDR_REG,
				DATA_WR => DATA_WR,
				OUT_A => DATA_R1, OUT_B => DATA_R2,
				ENABLE_WR => ENABLE_REG_WR
			);

-- EXTENSÃO DO SINAL
ESTENDE : entity work.estendeSinalGenerico  generic map (DATA_IN_SIZE => IMEDIATO_SIZE, DATA_OUT_SIZE => DATA_SIZE)
	port map ( DATA_IN => imediato, SELECTOR => ori_andi, DATA_OUT => SIG_EXT );
	

-------- CONTROL -----------------------
CONTROL <= control_all;
----------------------------------------
----------- REGS -----------------------
-- ADDR
ADDR_RT <= rt;
ADDR_RD <= rd;

-- DATA
SIG_LUI <= imediato & ( DATA_SIZE-IMEDIATO_SIZE-1 downto 0 => '0' );
----------------------------------------

-------------------------------------------------------------------------------
------------------------------------ TO HELP ----------------------------------
-------------------------------------------------------------------------------	

-- CODIFICACAO DOS PONTOS DE CONTROLE NA INSTRUCAO
---------- INSTRCUTION ---------------
imediato <= INSTRUCTION(15 downto 0);
opcode <= INSTRUCTION(31 downto 26);
rs <= INSTRUCTION(25 downto 21);
rt <= INSTRUCTION(20 downto 16);
rd <= INSTRUCTION(15 downto 11);
func <= INSTRUCTION(5 downto 0);
--------------------------------------
IMEDIATO_JMP <= INSTRUCTION(25 downto 0);
------------- OTHER ------------------
ori_andi <= control_all(8);
--------------------------------------

end architecture;