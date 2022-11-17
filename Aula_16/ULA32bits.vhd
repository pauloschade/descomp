library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULAMIPS is
  generic   (
        DATA_SIZE : natural := 32;
  );

  port   (
    -- Input ports
    dataIN  :  in  std_logic_vector(DATA_WIDTH-1 downto 0);
    enable  : in  std_logic;
    clk     : in  std_logic;
    <name>  : in  <type> := <default_value>;

    -- Inout ports
    <name>  : inout <type>;

    -- Output ports
    dataOUT :  out  std_logic_vector(DATA_WIDTH-1 downto 0);
    <name>  : out <type> := <default_value>
  );
end entity;


architecture arch_name of entity_name is

  -- Declarations (optional):
  -- signal <name> : std_logic;
  -- signal <name> : std_logic_vector(<msb_index> downto <lsb_index>);
  -- constant FUNCT_WIDTH : natural := 6;
  -- subtype funct_t  is  std_logic_vector(FUNCT_WIDTH-1 downto 0);
  -- constant functADD   : funct_t := "100000";
  -- constant functSUB   : funct_t := "100010";
  -- alias memWRsignal: std_logic is controlWord(0);
  -- alias ulaOPvalue:  std_logic_vector(1 downto 0) is controlWord(5 downto 4);

begin

  -- Para instanciar, a atribuição de sinais (e generics) segue a ordem: (nomeSinalArquivoDefinicaoComponente => nomeSinalNesteArquivo)
  -- regA:  entity work.nome_do_componente generic map (DATA_WIDTH => DATA_WIDTH)
  --        port map (dataIN => dataIN, dataOUT =>  RegAmuxA, enable =>  habRegA, clk =>  clk, rst => rst);

end architecture;



-- mux
nomeComponente :  entity work.muxGenerico generic map (larguraDados => VALOR_LOCAL)
port map( entradaA_MUX => sinalLocal,
         entradaB_MUX =>  sinalLocal,
         seletor_MUX => sinalLocal,
         saida_MUX => sinalLocal);

-- multiplex
nomeComponente :  entity work.muxGenericoNx1  generic map (larguraEntrada => VALOR_LOCAL, larguraSelecao => VALOR_LOCAL)
        port map( entrada_MUX => sinalLocal,
                  seletor_MUX => sinalLocal,
                  saida_MUX => sinalLocal);


-- somador                  
nomeComponente :  entity work.somadorGenerico  generic map (larguraDados => VALOR_LOCAL)
        port map( entradaA => sinalLocal, entradaB =>  sinalLocal, saida => sinalLocal);