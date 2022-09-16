library ieee;
use ieee.std_logic_1164.all;

entity Aula5 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
        simulacao : boolean := TRUE; -- para gravar na placa, altere de TRUE para FALSE
		  instruSize: natural := 13;
		  opcodeSize: natural := 4;
		  controlSize: natural := 12;
		  controlDesvioSize: natural := 5;
		  muxDesvio_SelectorSize: natural := 2
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic;
	 PC_OUT: out std_logic_vector(larguraEnderecos-1 downto 0);
    PALAVRA_CONTROLE  : out std_logic_vector(controlSize-1 downto 0)
  );
end entity;


architecture arquitetura of Aula5 is
  
  signal ULA_B_IN : std_logic_vector (larguraDados-1 downto 0);
  signal ULA_A_IN : std_logic_vector (larguraDados-1 downto 0);
  
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  
  
  --RAM
  signal Habilita_W_RAM : std_logic;
  signal Habilita_R_RAM : std_logic;
  signal Habilita_RAM : std_logic;
  
  signal RAM_OUT : std_logic_vector (larguraDados-1 downto 0);
  signal Endereco_Imediato : std_logic_vector (larguraEnderecos-1 downto 0);
  
  --REG
  signal Endereco : std_logic_vector (larguraEnderecos-1 downto 0);
  signal proxPC : std_logic_vector (larguraEnderecos-1 downto 0);
  
  --Instructions/control
  signal Instructions : std_logic_vector (instruSize-1 downto 0);
  signal Opcode : std_logic_vector (opcodeSize-1 downto 0);
  signal Sinais_Controle : std_logic_vector (controlSize-1 downto 0);
  
  signal Valor_Imediato : std_logic_vector (larguraDados-1 downto 0);
  
  signal CLK : std_logic;
  
  -- Decoder
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Operacao_ULA : std_logic_vector(1 downto 0);
  
  -- REG FLAG
  signal flag_ULA : std_logic;
  signal flag_out : std_logic;
  signal Habilita_F : std_logic;
  
  -- MUX PC
  signal sel_mux_PC : std_logic;
  signal END_PC : std_logic_vector (larguraEnderecos-1 downto 0);
  
  -- Desvio
  signal JMP : std_logic;
  signal JEQ : std_logic;
  signal control_Desvio : std_logic_vector (controlDesvioSize-1 downto 0);
  signal selMux_Desvio : std_logic_vector(muxDesvio_SelectorSize-1 downto 0);
  
  -- Retorno
  signal Habilita_Retorno : std_logic;
  signal Endereco_Retorno : std_logic_vector(larguraEnderecos-1 downto 0);
  

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY;
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY), saida => CLK);
end generate;

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => RAM_OUT,
                 entradaB_MUX =>  Valor_Imediato,
                 seletor_MUX => SelMUX,
                 saida_MUX => ULA_B_IN);

-- O port map completo do Acumulador.
REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK);
			 
-- REGFLAG : entity.work.flipFlop
REGFLAG : entity work.flipFlop port map (DIN => flag_ULA, DOUT => flag_out, ENABLE => Habilita_F, CLK => CLK);

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => END_PC, DOUT => Endereco, ENABLE => '1', CLK => CLK);

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Endereco, saida => proxPC);
		  
MUXPC : entity work.muxGenerico4x1  generic map (larguraDados => LarguraEnderecos)
        port map(entrada_0 => proxPC,
                 entrada_1 =>  Endereco_Imediato,
					  entrada_2 => Endereco_Retorno,
                 seletor_MUX => selMux_Desvio,
                 saida_MUX => END_PC);
-- Desvio
Desvio : entity work.logicaDesvio generic map(controlSize => controlDesvioSize, selectorSize => muxDesvio_SelectorSize)
			 port map (control => control_Desvio, selector => selMux_Desvio);
			 
RegDesvio : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => proxPC, DOUT => Endereco_Retorno, ENABLE => Habilita_Retorno, CLK => CLK);
--

-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, entradaB => ULA_B_IN, seletor => Operacao_ULA, saida => Saida_ULA, flag => flag_ULA);


ROM1 : entity work.memoriaROM   generic map (dataWidth => instruSize, addrWidth => larguraEnderecos, opcodeSize => opcodeSize)
          port map (Endereco => Endereco, Dado => Instructions);
			 
DI1 : entity work.decoderInstru	generic map(opcodeSize => opcodeSize, controlSize => controlSize)
			port map (opcode => Opcode, saida => Sinais_Controle);


RAM1 : entity work.memoriaRAM   generic map (dataWidth => larguraDados, addrWidth => larguraEnderecos)
          port map (addr => Endereco_Imediato, we => Habilita_W_RAM, re => Habilita_R_RAM, habilita => Habilita_RAM,
			 dado_in => REG1_ULA_A, 
			 dado_out => RAM_OUT, clk => CLK);


-- RAM
Habilita_RAM <= Instructions(8);

-- Controle
Habilita_W_RAM <= Sinais_Controle(0);
Habilita_R_RAM <= Sinais_Controle(1);
Habilita_F <= Sinais_Controle(2);
Operacao_ULA <= Sinais_Controle(4 downto 3);
Habilita_A <= Sinais_Controle(5);
selMUX <= Sinais_Controle(6);

--instruction
Opcode <= Instructions(instruSize-1 downto instruSize-opcodeSize);
Valor_Imediato <= Instructions(larguraDados-1 downto 0);
Endereco_Imediato <= Instructions(larguraEnderecos-1 downto 0);

-- Logica Desvio
control_Desvio(4) <= Sinais_Controle(10);
control_Desvio(3) <= Sinais_Controle(9);
control_Desvio(2) <= Sinais_Controle(8);
control_Desvio(1) <= Sinais_Controle(7);
control_Desvio(0) <= flag_out;

-- Retorno
Habilita_Retorno <= Sinais_Controle(controlSize-1);


-- A ligacao dos LEDs:
-- LEDR (9) <= SelMUX;
-- LEDR (8) <= Habilita_A;
PALAVRA_CONTROLE <= Sinais_Controle;

PC_OUT <= Endereco;

end architecture;