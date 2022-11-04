library ieee;
use ieee.std_logic_1164.all;

entity Projeto1 is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 8;
	 ADDRESS_SIZE : natural := 9;
	 OPCODE_SIZE : natural := 4;
	 INSTRUCTIONS_SIZE : natural := 16;
	 RAM_ADDRESS_SIZE : natural := 6;
	 DECODER_IN_SIZE : natural := 3;
	 
	 DISPLAYS_DATA_SIZE : natural := 4;
	 DISPLAYS_N : natural := 6;
	 
	 KEYS_N : natural := 5;
	 
	 SW_GROUPS_N : natural := 3;
	 SW_N : natural := 10;
	 
	 LED_N : natural := 10;
	 
	 HEX_SIZE : natural := 7;
	 
	 
	 simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY_IN: in std_logic;
	 
	 SW : in std_logic_vector(SW_N-1 downto 0);
	 
	 KEY : in std_logic_vector(KEYS_N-2 downto 0);
	 FPGA_RESET_N : in std_logic;
	 
	 CLR_ONE : out std_logic;
	 ENABLE_ONE : out std_logic;
	 
	 
	 HEX0 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX1 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 HEX2 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX3 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX4 : out std_logic_vector(HEX_SIZE-1 downto 0); 
	 HEX5 : out std_logic_vector(HEX_SIZE-1 downto 0);
	 
	 LEDR : out std_logic_vector(LED_N-1 downto 0);
	 
	 LT : out std_logic;
	 JLT : out std_logic;
	 
	 BLOCK_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 ADDRESSES_OUT : out std_logic_vector(DATA_SIZE-1 downto 0);
	 ROM_ADDR : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 CPU_IN : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;



architecture arquitetura of Projeto1 is
	 signal CLK: std_logic;
	 
	 signal cpu_data_out: std_logic_vector(DATA_SIZE-1 downto 0);
  	 signal ram_data_out: std_logic_vector(DATA_SIZE-1 downto 0);
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
	 
	 signal data_in : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 signal A5 : std_logic;
	 
	 signal displays_data : std_logic_vector(DISPLAYS_DATA_SIZE-1 downto 0);
	 signal displays_addresses : std_logic_vector(DISPLAYS_N-1 downto 0);
	 signal enable_displays : std_logic;
	 
	 signal keys_in : std_logic_vector(KEYS_N-1 downto 0);
	 signal keys_addresses : std_logic_vector(KEYS_N-1 downto 0);
	 signal enable_keys : std_logic;
	 signal keys_data_out : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 signal sw_addresses : std_logic_vector(SW_GROUPS_N-1 downto 0);
	 signal enable_sw : std_logic;
	 signal sw_data_out : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 -- clear key 0
	 signal clr_0 : std_logic;
	 -- clear key 1
	 signal clr_1 : std_logic;
	 
	 signal enable_timer : std_logic;
	 signal clr_timer : std_logic;
	 signal data_out_timer : std_logic_vector(DATA_SIZE-1 downto 0);
	 
	 signal selector_timer : std_logic_vector(1 downto 0);

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= KEY_IN;                       
else generate
CLK <= CLOCK_50;
-- detectorSub0: work.edgeDetector(bordaSubida) port map (clk => CLOCK_50, entrada => (not KEY(2)), saida => CLK);
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
				 dado_out => ram_data_out, 
				 clk => CLK
			 );

CPU : entity work.CPU   generic map (DATA_SIZE => DATA_SIZE, ADDRESS_SIZE => ADDRESS_SIZE, INSTRUCTIONS_SIZE => INSTRUCTIONS_SIZE, OPCODE_SIZE => OPCODE_SIZE)
			 port map (
				 CLK => CLK,
				 DATA_IN => data_in,
				 INSTRUCTIONS => instructions,
				 ROM_ADDRESS => rom_address,
				 DATA_OUT => cpu_data_out,
				 DATA_ADDRESS => data_address,
				 sig_JLT => JLT,
				 sig_LT => LT,
				 WR => wr,
				 RD => rd
			 );

DecoderAddress : entity work.addressDecoder generic map (ADDRESS_SIZE => ADDRESS_SIZE, DATA_SIZE => DATA_SIZE, DECODER_IN_SIZE => DECODER_IN_SIZE)
			 port map (
				 DATA_ADDRESS => data_address,
				 BLOCK_OUT => decoder_block_out,
				 ADDRESS_OUT => decoder_address_out
			 );

-- ////////////////////////////////////////////// LEDS ///////////////////////////////////////////////////////
REG_LEDR : entity work.registradorGenerico generic map (DATA_SIZE => DATA_SIZE)
			port map (DIN => cpu_data_out, DOUT => led_R, ENABLE => enable_led_R, CLK => CLK);
			
REG_LED8 : entity work.flipFlop
			port map (DIN => leds_in, DOUT => led_8, ENABLE => enable_led_8, CLK => CLK);
			
REG_LED9 : entity work.flipFlop
			port map (DIN => leds_in, DOUT => led_9, ENABLE => enable_led_9, CLK => CLK);
			
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////

DISPLAYS : entity work.displaysController generic map (DATA_SIZE => DISPLAYS_DATA_SIZE, DISPLAYS_N => DISPLAYS_N)
			port map(
				DATA_IN => displays_data, 
				ADDRESSES => displays_addresses, 
				ENABLE => enable_displays, 
				CLK => CLK, 
				HEX0 => HEX0,
				HEX1 => HEX1,
				HEX2 => HEX2,
				HEX3 => HEX3,
				HEX4 => HEX4,
				HEX5 => HEX5
			);
			
KEYS : entity work.keysController generic map (DATA_SIZE => DATA_SIZE, KEYS_N => KEYS_N)
			port map(
				DATA_IN => keys_in,
				ADDRESSES  => keys_addresses,
				ENABLE => enable_keys,
				CLR_0 => clr_0,
				CLR_1 => clr_1,
				CLK => CLK,
				DATA_OUT => keys_data_out
			);
			
SWITCHES : entity work.switchesController generic map (DATA_SIZE => DATA_SIZE, SW_GROUPS_N => SW_GROUPS_N)
			port map(
				DATA_IN => SW,
				ADDRESSES  => sw_addresses,
				ENABLE => enable_sw,
				DATA_OUT => sw_data_out
			);

TIMER : entity work.timerController generic map(DATA_SIZE => DATA_SIZE)
			port map(
				CLK => CLK,
				ENABLE => enable_timer,
				CLR => clr_timer,
				SELECTOR => selector_timer,
				DATA_OUT => data_out_timer
			);

			
-------------------- TO HELP --------------------------------
A5 <= data_address(5);
			 
-------------------- TOP LEVEL USAGE ------------------------
ram_address <= data_address(RAM_ADDRESS_SIZE-1 downto 0);

enable_RAM <= decoder_block_out(0); 
enable_led_R <= decoder_block_out(4) and wr and decoder_address_out(0) and not data_address(5);

leds_in <= cpu_data_out(0);
enable_led_8 <= decoder_block_out(4) and wr and decoder_address_out(1) and not(A5);
enable_led_9 <= decoder_block_out(4) and wr and decoder_address_out(2) and not(A5);

displays_data <= cpu_data_out(DISPLAYS_DATA_SIZE-1 downto 0);
displays_addresses <= decoder_address_out(DISPLAYS_N-1 downto 0);
enable_displays <= A5 and decoder_block_out(4) and wr;

-- +++++++++++ KEYS ++++++++++++++++++
keys_in(KEYS_N-2 downto 0) <= KEY;
keys_in(KEYS_N-1) <= FPGA_RESET_N;
keys_addresses <= decoder_address_out(KEYS_N-1 downto 0);
enable_keys <= rd and A5 and decoder_block_out(5);
-- +++++++++++++++++++++++++++++++++++

sw_addresses <= decoder_address_out(SW_GROUPS_N-1 downto 0);
enable_sw <= rd and not(A5) and decoder_block_out(5);

-- +++++++++++ DATA IN CPU ++++++++++++++++++
data_in <= ram_data_out;
data_in <= keys_data_out;
data_in <= sw_data_out;
data_in <= data_out_timer;
-- ++++++++++++++++++++++++++++++++++++++++++]
clr_0 <= wr and
		 data_address(0) and
		 data_address(1) and
		 data_address(2) and
		 data_address(3) and
		 data_address(4) and
		 data_address(5) and
		 data_address(6) and
		 data_address(7) and
		 data_address(8);
		 
clr_1 <= wr and
		 (not(data_address(0))) and
		 data_address(1) and
		 data_address(2) and
		 data_address(3) and
		 data_address(4) and
		 data_address(5) and
		 data_address(6) and
		 data_address(7) and
		 data_address(8);

-- 509
clr_timer <= wr and
		 data_address(0) and
		 (not(data_address(1))) and
		 data_address(2) and
		 data_address(3) and
		 data_address(4) and
		 data_address(5) and
		 data_address(6) and
		 data_address(7) and
		 data_address(8);

-- 508 
enable_timer <= rd and
		 (not(data_address(0))) and 
		 (not(data_address(1))) and
		 data_address(2) and
		 data_address(3) and
		 data_address(4) and
		 data_address(5) and
		 data_address(6) and
		 data_address(7) and
		 data_address(8);
		 
selector_timer <= SW(9) & SW(8);
-------------------------------------------------------------

-------------------- OUTPUT TEST ----------------------------
CPU_IN <= data_in;
BLOCK_OUT <= data_out_timer;
ADDRESSES_OUT <= decoder_address_out;
ROM_ADDR <= rom_address;

CLR_ONE <= clr_timer;
ENABLE_ONE <= enable_timer;

LEDR(DATA_SIZE-1 downto 0) <= led_R;
LEDR(8) <= led_8;
LEDR(9) <= led_9;
-------------------------------------------------------------

end architecture;