library ieee;
use ieee.std_logic_1164.all;
 
entity ULA32 is
    port (IN_A : in std_logic;
          IN_B : in std_logic;
          CARRYIN : in std_logic;
          SLT : in std_logic;
          INV_B : in std_logic;

          SELECTOR: in std_logic_vector (1 downto 0);

          RESULT : out std_logic;
			 OVERFLOW : out std_logic;
          DATA_OUT: out std_logic
			 );
end entity;
 
architecture Behavioral of ULA32 is

    signal sum_out, inv_out : std_logic;
    signal sig_overflow, CarryOut, MUX_out: std_logic;
    
    begin

        -- Invert
        MUX2x1 :  entity work.MUX2x1
        port map( 
            entradaA_MUX => IN_B,
            entradaB_MUX =>  not IN_B,
            seletor_MUX => INV_B,
            saida_MUX => inv_out);
 
        -- Multiplex OP
        MUX4x1 :  entity work.MUX4x1
        port map( 
            IN_A => inv_out and IN_A,
            IN_B => inv_out or IN_A,
            IN_C => sum_out,
            IN_D => SLT,
            seletor_MUX => SELECTOR,
            saida_MUX => MUX_out
            );

        -- Somador
        FULLADDER: entity work.FullAdder
        port map(
            IN_A => IN_A,
            IN_B => inv_out,
            CarryIn => CARRYIN,
            Sum => sum_out,
            CarryOut => CARRYOUT
        );

        DATA_OUT<= MUX_out;
        sig_overflow <= (CARRYIN xor CARRYOUT);
        RESULT <= (sig_overflow xor sum_out);
		  
		  OVERFLOW <= sig_overflow;

end architecture;