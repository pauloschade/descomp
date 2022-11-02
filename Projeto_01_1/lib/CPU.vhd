library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic (
	 DATA_SIZE : natural := 8;
	 ADDRESS_SIZE : natural := 9;
	 INSTRUCTIONS_SIZE : natural := 13;
	 OPCODE_SIZE : natural := 4;
	 CONTROL_SIZE : natural := 15;
	 CONTROL_DESVIO_SIZE : natural := 7;
	 REGS_N : natural := 3;
	 MUX_DESVIO_SELECTOR_SIZE : natural := 2
	 
  );
  port   (
	 CLK: in std_logic;
	 DATA_IN: in std_logic_vector(DATA_SIZE-1 downto 0);
	 INSTRUCTIONS: in std_logic_vector(INSTRUCTIONS_SIZE-1 downto 0);
	 ROM_ADDRESS: out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 DATA_OUT: out std_logic_vector(DATA_SIZE-1 downto 0);
	 DATA_ADDRESS: out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 sig_JLT : out std_logic;
	 sig_LT : out std_logic;
	 WR: out std_logic;
	 RD: out std_logic
  );
end entity;


architecture arquitetura of CPU is
  
  signal ULA_B_in : std_logic_vector (DATA_SIZE-1 downto 0);
  signal ULA_A_in : std_logic_vector (DATA_SIZE-1 downto 0);
  
  signal reg1_ULA_A : std_logic_vector (DATA_SIZE-1 downto 0);
  signal ULA_out : std_logic_vector (DATA_SIZE-1 downto 0);
  
  
  --RAM
  -- signal enable_RAM : std_logic;
  signal imediato_address : std_logic_vector (ADDRESS_SIZE-1 downto 0);
  
  --REG
  signal address : std_logic_vector (ADDRESS_SIZE-1 downto 0);
  signal proxPC : std_logic_vector (ADDRESS_SIZE-1 downto 0);
  
  --INSTRUCTIONS/control
  signal Opcode : std_logic_vector (OPCODE_SIZE-1 downto 0);
  signal Sinais_Controle : std_logic_vector (CONTROL_SIZE-1 downto 0);
  signal imediato_value : std_logic_vector (DATA_SIZE-1 downto 0);
  
  signal address_PC : std_logic_vector (ADDRESS_SIZE-1 downto 0);
  
  -- Decoder
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Operacao_ULA : std_logic_vector(1 downto 0);
  
  -- REG FLAG
  signal flag_eq_ULA : std_logic;
  signal flag_eq_out : std_logic;
  signal enable_feq : std_logic;
  
  signal flag_lt_ULA : std_logic;
  signal flag_lt_out : std_logic;
  signal enable_flt : std_logic;
  
  -- MUX PC
  signal sel_mux_PC : std_logic;
  signal mux_PC_out : std_logic_vector (ADDRESS_SIZE-1 downto 0);
  
  -- Desvio
  signal JMP : std_logic;
  signal JEQ : std_logic;
  signal control_Desvio : std_logic_vector (CONTROL_DESVIO_SIZE-1 downto 0);
  signal selMux_Desvio : std_logic_vector(MUX_DESVIO_SELECTOR_SIZE-1 downto 0);
  
  -- Retorno
  signal enable_RET : std_logic;
  signal RET_address : std_logic_vector(ADDRESS_SIZE-1 downto 0);
  
  -- REG MEM
  signal REG_address : std_logic_vector((REGS_N-1) downto 0);
  

begin

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (DATA_SIZE => DATA_SIZE)
        port map( entradaA_MUX => DATA_IN,
                 entradaB_MUX =>  imediato_value,
                 seletor_MUX => SelMUX,
                 saida_MUX => ULA_B_in);

-- O port map completo do Acumulador.
REGMEM : entity work.bancoRegistradoresArqRegMem   generic map (DATA_SIZE => DATA_SIZE, REGS_N => REGS_N)
          port map (DATA_IN => ULA_out, ADDR => REG_address, DATA_OUT => reg1_ULA_A, ENABLE => Habilita_A, CLK => CLK);
			 
-- REGFLAG : entity.work.flipFlop
REG_FLAG_EQ : entity work.flipFlop port map (DIN => flag_eq_ULA, DOUT => flag_eq_out, ENABLE => enable_feq, CLK => CLK);

REG_FLAG_LT : entity work.flipFlop port map (DIN => flag_lt_ULA, DOUT => flag_lt_out, ENABLE => enable_flt, CLK => CLK);

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (DATA_SIZE => ADDRESS_SIZE)
          port map (DIN => address_PC, DOUT => address, ENABLE => '1', CLK => CLK);

incrementaPC :  entity work.somaConstante  generic map (DATA_SIZE => ADDRESS_SIZE, constante => 1)
        port map( entrada => address, saida => proxPC);
		  
MUXPC : entity work.muxGenerico4x1  generic map (DATA_SIZE => ADDRESS_SIZE)
        port map(entrada_0 => proxPC,
                 entrada_1 =>  imediato_address,
					  entrada_2 => RET_address,
                 seletor_MUX => selMux_Desvio,
                 saida_MUX => address_PC);
-- Desvio
Desvio : entity work.logicaDesvio generic map(CONTROL_SIZE => CONTROL_DESVIO_SIZE, SELECTOR_SIZE => MUX_DESVIO_SELECTOR_SIZE)
			 port map (control => control_Desvio, selector => selMux_Desvio);
			 
RegDesvio : entity work.registradorGenerico   generic map (DATA_SIZE => ADDRESS_SIZE)
          port map (DIN => proxPC, DOUT => RET_address, ENABLE => enable_RET, CLK => CLK);
--

-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(DATA_SIZE => DATA_SIZE)
          port map 
			 (
				 entradaA => reg1_ULA_A, 
				 entradaB => ULA_B_in, 
				 seletor => Operacao_ULA, 
				 saida => ULA_out, 
				 flag_eq => flag_eq_ULA,
				 flag_lt => flag_lt_ULA
			 );
			 
			 
DI1 : entity work.decoderInstru	generic map(OPCODE_SIZE => OPCODE_SIZE, CONTROL_SIZE => CONTROL_SIZE)
			port map (opcode => Opcode, saida => Sinais_Controle);


-------------------- INTERNAL CPU USAGE --------------------
-- -- Operations
enable_feq <= Sinais_Controle(2) and not(Sinais_Controle(3));
enable_flt <= Sinais_Controle(3) and not(Sinais_Controle(2));
Operacao_ULA <= Sinais_Controle(5 downto 4);
Habilita_A <= Sinais_Controle(6);
selMUX <= Sinais_Controle(7);

-- -- instruction
Opcode <= INSTRUCTIONS(INSTRUCTIONS_SIZE-1 downto INSTRUCTIONS_SIZE-OPCODE_SIZE);
imediato_value <= INSTRUCTIONS(DATA_SIZE-1 downto 0);
imediato_address <= INSTRUCTIONS(ADDRESS_SIZE-1 downto 0);
REG_address <= INSTRUCTIONS(INSTRUCTIONS_SIZE-OPCODE_SIZE-1 downto INSTRUCTIONS_SIZE-OPCODE_SIZE-REGS_N);

-- -- Logica Desvio
control_Desvio(6) <= Sinais_Controle(12);
control_Desvio(5) <= Sinais_Controle(11);
control_Desvio(4) <= Sinais_Controle(10);
control_Desvio(3) <= Sinais_Controle(9); -- JLT
control_Desvio(2) <= Sinais_Controle(8); -- JEQ
control_Desvio(1) <= flag_lt_out; -- FLAG LT
control_Desvio(0) <= flag_eq_out; -- FLAG EQ

-- -- Retorno
enable_RET <= Sinais_Controle(13);
-------------------------------------------------------------




------------------------ CPU OUTPUTS ------------------------

-- -- Address selected by MUX
ROM_ADDRESS <= address;

-- -- Value stored on Register A
DATA_OUT <= reg1_ULA_A;

-- -- Address to get/write data on RAM received at imediato
DATA_ADDRESS <= imediato_address;

-- Enable write/read from RAM
WR <= Sinais_Controle(0);
RD <= Sinais_Controle(1);

sig_JLT <= Sinais_Controle(9);
sig_LT <= flag_lt_out;
--------------------------------------------------------------

end architecture;