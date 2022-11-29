library ieee;
use ieee.std_logic_1164.all;
 
entity FullAdder is
    port (IN_A : in std_logic;
    IN_B : in std_logic;
          CarryIn : in std_logic;
    
          Sum : out std_logic;
          CarryOut : out std_logic);
end entity;
 
architecture Behavioral of FullAdder is
    begin
        Sum <= IN_A xor IN_B xor CarryIn;
        CarryOut <= (IN_A and IN_B) or (CarryIn and IN_A) or (CarryIn and IN_B);
end architecture;