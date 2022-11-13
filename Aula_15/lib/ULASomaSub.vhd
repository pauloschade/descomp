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
      SELECTOR:  in STD_LOGIC_VECTOR((SELECTOR_SIZE-1) downto 0);
		FLAG_Z:    out STD_LOGIC;
      DATA_OUT:    out STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0)
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((DATA_SIZE-1) downto 0);

    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(IN_A) + unsigned(IN_B));
      subtracao <= STD_LOGIC_VECTOR(unsigned(IN_A) - unsigned(IN_B));
		
      DATA_OUT <= soma when (SELECTOR = "0001") else 
					subtracao when (SELECTOR ="0010") else 
					IN_A;
		FLAG_Z <= '1' when unsigned(DATA_OUT) = 0 else '0';
		
end architecture;