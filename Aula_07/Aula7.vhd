library ieee;
use ieee.std_logic_1164.all;

entity Aula7 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 8;
	 ADDRESS_SIZE : natural := 9;
	 OPCODE_SIZE : natural := 4;
	 INSTRUCTIONS_SIZE : natural := 13;
	 RAM_ADDRESS_SIZE : natural := 6;
	 DECODER_IN_SIZE : natural := 3;
	 simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic;
	 LEDR: out std_logic_vector(DATA_SIZE-1 downto 0);
	 LED8: out std_logic;
	 LED9 : out std_logic
  );
end entity;


architecture arquitetura of Aula7 is
	 signal CLK: std_logic;
	 
	 signal cpu_data_out: std_logic_vector(DATA_SIZE-1 downto 0);
  	 signal ram_out_data: std_logic_vector(DATA_SIZE-1 downto 0);
	 signal ram_address: std_logic_vector(RAM_ADDRESS_SIZE-1 downto 0);
	 
	 signal data_address: std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 
	 signal instructions: std_logic_vector(INSTRUCTIONS_SIZE-1 downto 0);
	 signal rom_address: std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 
	 signal wr: std_logic;
	 signal rd: std_logic;
	 signal enable_ram: std_logic;
	 
	 signal decoder_block_out: std_logic_vector(DATA_SIZE-1 downto 0);
	 signal decoder_address_out: std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 signal led_R: std_logic_vector(DATA_SIZE-1 downto 0);
	 signal leds_in : std_logic;
	 signal led_8 : std_logic;
	 signal led_9 : std_logic;
	 signal enable_led_R : std_logic;
	 signal enable_led_8 : std_logic;
	 signal enable_led_9 : std_logic;

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY;
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY), saida => CLK);
end generate;


ROM : entity work.memoriaROM   generic map (dataWidth => INSTRUCTIONS_SIZE, addrWidth => ADDRESS_SIZE, opcodeSize => OPCODE_SIZE)
          port map (address => rom_address, data => Instructions);


RAM : entity work.memoriaRAM   generic map (dataWidth => DATA_SIZE, addrWidth => RAM_ADDRESS_SIZE)
          port map (
				 addr => ram_address, 
				 we => wr,
				 re => rd, 
				 habilita => enable_RAM,
				 dado_in => cpu_data_out, 
				 dado_out => ram_out_data, 
				 clk => CLK
			 );

CPU : entity work.CPU   generic map (DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => ADDRESS_SIZE, INSTRUCTIONS_SIZE => INSTRUCTIONS_SIZE, OPCODE_SIZE => OPCODE_SIZE)
			 port map (
				 CLK => CLK,
				 DATA_IN => ram_out_data,
				 INSTRUCTIONS => instructions,
				 ROM_ADDRESS => rom_address,
				 DATA_OUT => cpu_data_out,
				 DATA_ADDRESS => data_address,
				 WR => wr,
				 RD => rd
			 );

DecoderAddress : entity work.addressDecoder generic map (ADDRESS_SIZE => ADDRESS_SIZE, DATA_SIZE => DATA_SIZE, DECODER_IN_SIZE => DECODER_IN_SIZE)
			 port map (
				 DATA_ADDRESS => data_address,
				 BLOCK_OUT => decoder_block_out,
				 ADDRESS_OUT => decoder_address_out
			 );

REG_LEDR : entity work.registradorGenerico generic map (DATA_SIZE => DATA_SIZE)
			port map (DIN => cpu_data_out, DOUT => led_R, ENABLE => enable_led_R, CLK => CLK);
			
REG_LED8 : entity work.flipFlop
			port map (DIN => leds_in, DOUT => led_8, ENABLE => enable_led_8, CLK => CLK);
			
REG_LED9 : entity work.flipFlop
			port map (DIN => leds_in, DOUT => led_9, ENABLE => enable_led_9, CLK => CLK);
			 
-------------------- TOP LEVEL USAGE ------------------------
ram_address <= data_address(RAM_ADDRESS_SIZE-1 downto 0);

enable_RAM <= decoder_block_out(0); 
enable_led_R <= decoder_block_out(4) and wr and decoder_address_out(0);

leds_in <= cpu_data_out(0);
enable_led_8 <= decoder_block_out(4) and wr and decoder_address_out(1);
enable_led_9 <= decoder_block_out(4) and wr and decoder_address_out(2);
-------------------------------------------------------------

-------------------- OUTPUT TEST ----------------------------
LEDR <= led_r;
LED8 <= led_8;
LED9 <= led_9;
-------------------------------------------------------------

end architecture;