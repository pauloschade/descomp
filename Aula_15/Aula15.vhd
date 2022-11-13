library ieee;
use ieee.std_logic_1164.all;

entity Aula15 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 OPCODE_SIZE : natural := 6;
	 FUNC_SIZE : natural := 6;
	 INSTRUCTIONS_SIZE : natural := 13;
	 IMEDIATO_SIZE : natural := 26;
	 CONTROL_SIZE : natural := 12;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
	 KEY_IN : in std_logic;
	 
	 REG1_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 REG2_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 PC_DATA : out std_logic_vector(DATA_SIZE-1 downto 0);
	 SIG_EXTEN : out std_logic_vector(DATA_SIZE-1 downto 0);
	 BEQ_OR_JMP : out std_logic;
	 OPCODE_OUTPUT : out std_logic_vector(OPCODE_SIZE-1 downto 0);
	 DATA_WR : out std_logic_vector(DATA_SIZE-1 downto 0)
	 
  );
end entity;


architecture arquitetura of Aula15 is

	signal CLK : std_logic;
	signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	signal beq : std_logic;
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal control : std_logic_vector(CONTROL_SIZE-1 downto 0);
	signal opcode : std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal func : std_logic_vector(FUNC_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	
	signal mux_beq_jmp_selector : std_logic;

	
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

CPU : entity work.CPU   generic map (DATA_SIZE => DATA_SIZE, OPCODE_SIZE => OPCODE_SIZE, CONTROL_SIZE => CONTROL_SIZE)
			 port map (
				 CLK => CLK,
				 INSTRUCTION => rom_out,
				 CONTROL => control,
				 SIG_EXT_OUT => sig_ext,
				 OPCODE => opcode,
				 FUNC => func,
				 
				 ---TEST
				 data_r1_out  => REG1_OUT,
				 data_r2_out  => REG2_OUT,
				 data_rwr_out => DATA_WR,
				 
				 BEQ_AND_ZERO => beq
				);
ROM : entity work.ROMController generic map (DATA_SIZE => DATA_SIZE, IMEDIATO_SIZE => IMEDIATO_SIZE)
			 port map (
				 CLK => CLK,
				 SIG_EXT => sig_ext,
				 MUX_SELECTOR => beq,
				 IMEDIATO => imediato,
				 MUX_BEQ_JMP_SELECTOR => mux_beq_jmp_selector,
				 PC_CURR => PC_DATA,
				 DATA_OUT => rom_out
				);

DECODER : entity work.decoderInstru  generic map (OPCODE_SIZE => OPCODE_SIZE, CONTROL_SIZE => CONTROL_SIZE)
	port map (OPCODE => opcode, FUNC => func, DATA_OUT => control);

------------------------------------------------------
BEQ_OR_JMP <= control(11);
SIG_EXTEN <= sig_ext;
mux_beq_jmp_selector <= control(11);
imediato <= rom_out(IMEDIATO_SIZE-1 downto 0);
OPCODE_OUTPUT <= opcode;
------------------------------------------------------
end architecture;
