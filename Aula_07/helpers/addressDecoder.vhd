library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity addressDecoder is
  generic (
	 ADDRESS_SIZE : natural := 9;
	 DATA_SIZE : natural := 8;
	 DECODER_IN_SIZE : natural := 3
	 
  );
  port   (
	 DATA_ADDRESS: in std_logic_vector(ADDRESS_SIZE-1 downto 0);
	 BLOCK_OUT: out std_logic_vector(DATA_SIZE-1 downto 0);
	 ADDRESS_OUT: out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;


architecture arquitetura of addressDecoder is

	signal block_in : std_logic_vector(DECODER_IN_SIZE-1 downto 0);
	signal address_in : std_logic_vector(DECODER_IN_SIZE-1 downto 0);
	
begin

DecoderBlock : entity work.decoder3x8 port map (entrada => block_in, saida => BLOCK_OUT);
AdressBlock : entity work.decoder3x8 port map (entrada => address_in, saida => ADDRESS_OUT);

--------------------- DECODER USAGE -------------------------
block_in <= DATA_ADDRESS(ADDRESS_SIZE-1 downto ADDRESS_SIZE-DECODER_IN_SIZE);
address_in <= DATA_ADDRESS(DECODER_IN_SIZE-1 downto 0);
-------------------------------------------------------------

end architecture;