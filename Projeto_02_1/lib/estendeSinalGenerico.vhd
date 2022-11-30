library ieee;
use ieee.std_logic_1164.all;

entity estendeSinalGenerico is
    generic
    (
        DATA_IN_SIZE : natural  :=    16;
        DATA_OUT_SIZE   : natural  :=    32
    );
    port
    (
        -- Input ports
        DATA_IN : in  std_logic_vector(DATA_IN_SIZE-1 downto 0);
		  SELECTOR : in std_logic;
        -- Output ports
        DATA_OUT: out std_logic_vector(DATA_OUT_SIZE-1 downto 0)
    );
end entity;

architecture comportamento of estendeSinalGenerico is
	signal sig_ext  : std_logic;
begin

MUX : entity work.MUX2x1
	port map ( IN_A => DATA_IN(DATA_IN_SIZE-1), IN_B => '0', SELECTOR => SELECTOR, DATA_OUT => sig_ext );

	 DATA_OUT <= ( DATA_OUT_SIZE-1 downto DATA_IN_SIZE => sig_ext ) & DATA_IN;

end architecture;