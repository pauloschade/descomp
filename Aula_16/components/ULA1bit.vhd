library ieee;
use ieee.std_logic_1164.all;
 
entity ULA1bit is
    port (A : in std_logic;
          B : in std_logic;
          CARRYIN : in std_logic;
          SLT : in std_logic;
          INV_B : in std_logic;

          SELECTOR: in std_logic_vector (1 downto 0);

          RESULT : out std_logic;
          CARRYOUT : out std_logic);
end entity;
 
architecture Behavioral of ULA1bit is

    signal sum_out, sig_or, sig_and, sig_Overflow, sig_CarryOut, inv_out : std_logic;
    
    begin

        -- Seleciona se inverte
        MUX2x1 :  entity work.muxGenerico2x1 generic map (larguraDados => 1)
        port map( 
            entradaA_MUX => B,
            entradaB_MUX =>  not B,
            seletor_MUX => INV_B,
            saida_MUX => inv_out);
 
        -- Multiplex OP
        MUX4x1 :  entity work.muxGenericoNx1  generic map (larguraDados => 1)
        port map( 
            entradaA_MUX => sig_and,
            entradaA_MUX => sig_or,
            entradaC_MUX => sum_out,
            entradaD_MUX => SLT,
            seletor_MUX => SELECTOR,
            saida_MUX => RESULT
            );

        FULLADDER: entity work.FullAdder generic map (larguraDados => 1)
        port map(
            CarryIn => CARRYIN,
            A => A,
            B => inv_out,
            soma => sum_out,
            CarryOut => CARRYOUT
        );

        sig_OVERFLOW <= CARRYIN xor CARRYOUT;
        SELECTOR <= (A and B) or (CarryIn and A) or (CarryIn and B);
        RESULT <= saida_MUX
        --sig_and <= (inv_out and A);
        --sig_or <= (inv_out or A);
end architecture;