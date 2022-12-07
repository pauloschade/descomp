library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic 
	 ( 
		DATA_SIZE : natural := 4;
		SELECTOR_SIZE : natural := 6
	 );
    port (
      IN_A, IN_B:  in STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
      SELECTOR_A, SELECTOR_B:  in STD_LOGIC_VECTOR((SELECTOR_SIZE-1) downto 0);
		  FLAG_Z:    out STD_LOGIC;
      DATA_OUT:    out STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0)
    );
end entity;

architecture comportamento of ULASomaSub is

	 signal inv_b : std_logic;
	 signal inv_a : std_logic;

    begin

ULA_MIPS_BIT : entity work.ULA_MIPS  generic map (DATA_SIZE => DATA_SIZE)
		-- port map (IN_A => IN_A, IN_B => IN_B, INV_B => inv_b ,SELECTOR => SELECTOR(1 downto 0), DATA_OUT => DATA_OUT, ZERO_FLAG => FLAG_Z);

		port map (IN_A => IN_A, IN_B => IN_B, INV_A => inv_a, INV_B => inv_b ,SELECTOR_A => SELECTOR_A(1 downto 0), SELECTOR_B => SELECTOR_B(1 downto 0), DATA_OUT => DATA_OUT, ZERO_FLAG => FLAG_Z);
		

-------------------------------------------------------------
-- ADD = "... 0010"
-- SUB = "... 0110"
inv_b <= SELECTOR(2);
-------------------------------------------------------------
end architecture;