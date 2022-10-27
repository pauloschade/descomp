library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradorGenerico is
    generic (
        DATA_SIZE : natural := 8
    );
    port (DIN : in std_logic_vector(DATA_SIZE-1 downto 0);
       DOUT : out std_logic_vector(DATA_SIZE-1 downto 0);
       ENABLE : in std_logic;
       CLK : in std_logic
        );
end entity;

architecture comportamento of registradorGenerico is
begin
    -- In Altera devices, register signals have a set priority.
    -- The HDL design should reflect this priority.
    process(CLK)
    begin
			if (rising_edge(CLK)) then
				 if (ENABLE = '1') then
							DOUT <= DIN;
				 end if;
        end if;
    end process;
end architecture;