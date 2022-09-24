library ieee;
use ieee.std_logic_1164.all;

entity Aula4 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
        simulacao : boolean := TRUE; -- para gravar na placa, altere de TRUE para FALSE
		  instruSize: natural := 13;
		  opcodeSize: natural := 4;
		  controlSize: natural := 6
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic;
	 PC_OUT: out std_logic_vector(larguraEnderecos-1 downto 0);
    LEDR  : out std_logic_vector(larguraDados-1 downto 0)
  );
end entity;


architecture arquitetura of Aula4 is
  
  signal ULA_B_IN : std_logic_vector (larguraDados-1 downto 0);
  signal ULA_A_IN : std_logic_vector (larguraDados-1 downto 0);
  
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  
  
  --RAM
  signal Habilita_W_RAM : std_logic;
  signal Habilita_R_RAM : std_logic;
  signal Habilita_RAM : std_logic;
  
  signal RAM_OUT : std_logic_vector (larguraDados-1 downto 0);
  signal Endereco_RAM : std_logic_vector (larguraEnderecos-1 downto 0);
  
  --REG
  signal Endereco : std_logic_vector (larguraEnderecos-1 downto 0);
  signal proxPC : std_logic_vector (larguraEnderecos-1 downto 0);
  
  --Instructions/control
  signal Instructions : std_logic_vector (instruSize-1 downto 0);
  signal Opcode : std_logic_vector (instruSize-1 downto instruSize-opcodeSize);
  signal Sinais_Controle : std_logic_vector (controlSize-1 downto 0);
  
  signal InstructionValue : std_logic_vector (larguraDados-1 downto 0);
  
  signal CLK : std_logic;
  
  -- Decoder
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Operacao_ULA : std_logic_vector(1 downto 0);

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
                 entradaB_MUX =>  instructionValue,
                 seletor_MUX => SelMUX,
                 saida_MUX => ULA_B_IN);

-- O port map completo do Acumulador.
REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK);

-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => proxPC, DOUT => Endereco, ENABLE => '1', CLK => CLK);

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Endereco, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, entradaB => ULA_B_IN, saida => Saida_ULA, seletor => Operacao_ULA);


ROM1 : entity work.memoriaROM   generic map (dataWidth => instruSize, addrWidth => larguraEnderecos)
          port map (Endereco => Endereco, Dado => Instructions);
			 
DI1 : entity work.decoderInstru port map (opcode => Opcode, saida => Sinais_Controle);


RAM1 : entity work.memoriaRAM   generic map (dataWidth => larguraDados, addrWidth => larguraEnderecos)
          port map (addr => Endereco_RAM, we => Habilita_W_RAM, re => Habilita_R_RAM, habilita => Habilita_RAM,
			 dado_in => REG1_ULA_A, 
			 dado_out => RAM_OUT, clk => CLK);





Habilita_RAM <= Instructions(8);
			 
Habilita_W_RAM <= Sinais_Controle(0);
Habilita_R_RAM <= Sinais_Controle(1);
Operacao_ULA <= Sinais_Controle(3 downto 2);
Habilita_A <= Sinais_Controle(4);
selMUX <= Sinais_Controle(5);

--instruction
Opcode <= Instructions(instruSize-1 downto instruSize-opcodeSize);
instructionValue <= Instructions(larguraDados-1 downto 0);
Endereco_RAM <= Instructions(larguraEnderecos-1 downto 0);


-- A ligacao dos LEDs:
-- LEDR (9) <= SelMUX;
-- LEDR (8) <= Habilita_A;
LEDR <= REG1_ULA_A;

PC_OUT <= Endereco;

end architecture;