library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipFlop is
    port (DIN : in std_logic;
       DOUT : out std_logic;
       ENABLE : in std_logic;
		 RST : in std_logic :='0';
       CLK : in std_logic
        );
end entity;

architecture comportamento of flipFlop is
begin
    -- In Altera devices, register signals have a set priority.
    -- The HDL design should reflect this priority.
    process(RST, CLK)
    begin
	 
		if (RST = '1') then
			DOUT <= '0';
		else
			if (rising_edge(CLK)) then
			 if (ENABLE = '1') then
						DOUT <= DIN;
			 end if;
        end if;
		 end if;
    end process;
end architecture;