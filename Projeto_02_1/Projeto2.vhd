library ieee;
use ieee.std_logic_1164.all;

entity Projeto2 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 ADDRESS_SIZE : natural := 32;
	 OPCODE_SIZE : natural := 6;
	 FUNC_SIZE : natural := 6;
	 INSTRUCTIONS_SIZE : natural := 13;
	 IMEDIATO_SIZE : natural := 26;
	 CONTROL_SIZE : natural := 13;
	 ULA_SELECTOR_SIZE : natural := 4;
	 HEX_SIZE : natural := 7;
	 LED_N : natural := 10;
	 SW_N : natural := 10;
	 
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
	 KEY_IN : in std_logic;
	 ------------------ FPGA -----------------------------
	 HEX0 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX1 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 HEX2 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX3 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX4 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX5 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 
	 SW : in std_logic_vector(SW_N-1 downto 0);
	 
	 KEY : in std_logic_vector(3 downto 0);
	 
	 LEDR : out std_logic_vector(LED_N-1 downto 0)
	 ------------------- TEST -----------------------------
--	 REG1_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 REG2_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 PC_DATA  : out std_logic_vector(DATA_SIZE-1 downto 0)
--	 ULA_DATA_OUTER : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 SIG_EXTEN : out std_logic_vector(DATA_SIZE-1 downto 0);
--	 BEQ_OR_JMP : out std_logic;
--	 OPCODE_OUTPUT : out std_logic_vector(OPCODE_SIZE-1 downto 0);
--	 ULA_OPERATION : out std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
--	 CONTROL_DATA_IN : out std_logic_vector(CONTROL_SIZE-1 downto 0);
--	 DATA_WR : out std_logic_vector(DATA_SIZE-1 downto 0)
	 
  );
end entity;


architecture arquitetura of Projeto2 is

	signal CLK : std_logic;
	signal sig_ext : std_logic_vector(DATA_SIZE-1 downto 0);
	signal bne_or_beq : std_logic;
	
	signal rom_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal control : std_logic_vector(CONTROL_SIZE-1 downto 0);
	signal opcode : std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal func : std_logic_vector(FUNC_SIZE-1 downto 0);
	
	signal imediato : std_logic_vector(IMEDIATO_SIZE-1 downto 0);
	
	signal mux_beq_jmp_selector : std_logic;
	signal mux_jr_selector : std_logic;
	
	signal ula_op : std_logic_vector(ULA_SELECTOR_SIZE-1 downto 0);
	
	signal ula_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal signal_teste : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal pc : std_logic_vector(DATA_SIZE-1 downto 0);
	signal pc_plus_4_jal : std_logic_vector(DATA_SIZE-1 downto 0);
	
	signal reg1_out : std_logic_vector(DATA_SIZE-1 downto 0);
	
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY_IN;                       
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => CLK);
--CLK <= KEY_IN;
end generate;



MUX_TEST : entity work.generic_MUX_2x1 generic map(DATA_SIZE => DATA_SIZE)
				port map(IN_A => pc, IN_B => ula_out, MUX_SELECTOR => SW(SW_N-1) ,DATA_OUT => signal_teste);
				
HEX_LED : entity work.displaysController generic map (DATA_SIZE => DATA_SIZE)
				port map(DATA_IN => signal_teste, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, LED_0_3 => LEDR(3 downto 0), LED_4_7 => LEDR(7 downto 4));

				
------------------------------------------------------			

------------------------------------------------------
end architecture;