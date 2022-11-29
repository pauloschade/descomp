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
	signal sig_ext  : std_logic_vector(DATA_OUT_SIZE-1 downto 0);
	signal zero_ext : std_logic_vector(DATA_OUT_SIZE-1 downto 0);
begin

    sig_ext <= ( DATA_OUT_SIZE-1 downto DATA_IN_SIZE => DATA_IN(DATA_IN_SIZE-1) ) & DATA_IN;
	 zero_ext <= ( DATA_OUT_SIZE-1 downto DATA_IN_SIZE => '0' ) & DATA_IN;
	 
MUX : entity work.generic_MUX_2x1  generic map (DATA_SIZE => DATA_OUT_SIZE)
	port map ( IN_A => sig_ext, IN_B => zero_ext, MUX_SELECTOR => SELECTOR, DATA_OUT => DATA_OUT );

end architecture;