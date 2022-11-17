library ieee;
use ieee.std_logic_1164.all;
 
entity FullAdder is
    port (A : in std_logic;
          B : in std_logic;
          CarryIn : in std_logic;
    
          Sum : out std_logic;
          CarryOut : out std_logic);
end entity;
 
architecture Behavioral of FullAdder is
    begin
        Sum <= A xor B xor CarryIn;
        CarryOut <= (A and B) or (CarryIn and A) or (CarryIn and B);
end architecture;