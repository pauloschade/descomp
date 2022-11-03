LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
	generic (
         DATA_SIZE : natural := 8;
			DIVISOR : natural := 25000000
	);
   port(
		CLK      :   in std_logic;
      ENABLE   :   in std_logic;
      CLR : in std_logic;
      DATA_OUT :   out std_logic_vector(DATA_SIZE-1 downto 0)
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg : std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => DIVISOR)   -- divide por 50MH.
           port map (CLK => CLK, saida_clk => saidaclk_reg1seg);

registraUmSegundo: entity work.flipFlop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => saidaclk_reg1seg,
         RST => CLR);

-- Faz o tristate de saida:
buf : entity work.buffer_3_state
			port map (DATA_IN => sinalUmSegundo, ENABLE => ENABLE, DATA_OUT => DATA_OUT);

end architecture interface;