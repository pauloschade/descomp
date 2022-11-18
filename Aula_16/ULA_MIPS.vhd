library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
 
entity ULAMIPS is
    generic (larguraDados: NATURAL := 32);
    port (A : in std_logic_vector((larguraDados-1) downto 0);
          B : in std_logic_vector((larguraDados-1) downto 0);
          INV_B : in std_logic;
          
          SELECTOR: in std_logic_vector (1 downto 0);

          SAIDA : out std_logic_vector((larguraDados-1) downto 0);
          ZERO_FLAG : out std_logic;);
end entity;
 
architecture Behavioral of ULAMIPS is

    constant zero: std_logic_vector((larguraDados-1) downto 0) := (others => '0');
    
    signal carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7, carry8, carry9, carry10,
    carry11, carry12, carry13, carry14, carry15, carry16, carry17, carry18, carry19, carry20, carry21,
    carry22, carry23, carry24, carry25, carry26, carry27, carry28, carry29, carry30 : std_logic;

    signal slt;

    begin
        ULA1 : entity work.ULA1TO31
            port map(
                A => A(0),
                B => B(0),
                CARRYIN => INV_B,
                SLT => slt, 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(0),
                CARRYOUT => carry0
            );

        ULA2 : entity work.ULA1TO31
            port map(
                A => A(1),
                B => B(1),
                CARRYIN => carry0,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(1),
                CARRYOUT => carry1
            );

        ULA3 : entity work.ULA1TO31
            port map(
                A => A(2),
                B => B(2),
                CARRYIN => carry1,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(2),
                CARRYOUT => carry2
            );

        ULA4 : entity work.ULA1TO31
            port map(
                A => A(3),
                B => B(3),
                CARRYIN => carry2,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(3),
                CARRYOUT => carry3
            );

        ULA5 : entity work.ULA1TO31
            port map(
                A => A(4),
                B => B(4),
                CARRYIN => carry3,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(4),
                CARRYOUT => carry4
            );

        ULA6 : entity work.ULA1TO31
            port map(
                A => A(5),
                B => B(5),
                CARRYIN => carry4,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(5),
                CARRYOUT => carry5
            );

        ULA7 : entity work.ULA1TO31
            port map(
                A => A(6),
                B => B(6),
                CARRYIN => carry5,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(6),
                CARRYOUT => carry6
            );

        ULA8 : entity work.ULA1TO31
            port map(
                A => A(7),
                B => B(7),
                CARRYIN => carry6,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(7),
                CARRYOUT => carry7
            );

        ULA9 : entity work.ULA1TO31
            port map(
                A => A(8),
                B => B(8),
                CARRYIN => carry7,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(8),
                CARRYOUT => carry8
            );

        ULA10 : entity work.ULA1TO31
            port map(
                A => A(9),
                B => B(9),
                CARRYIN => carry8,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(9),
                CARRYOUT => carry9
            );

        ULA11 : entity work.ULA1TO31
            port map(
                A => A(10),
                B => B(10),
                CARRYIN => carry9,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(10),
                CARRYOUT => carry10
            );

        ULA12 : entity work.ULA1TO31
            port map(
                A => A(11),
                B => B(11),
                CARRYIN => carry10,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(11),
                CARRYOUT => carry11
            );

        ULA13 : entity work.ULA1TO31
            port map(
                A => A(12),
                B => B(12),
                CARRYIN => carry11,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(12),
                CARRYOUT => carry12
            );

        ULA14 : entity work.ULA1TO31
            port map(
                A => A(13),
                B => B(13),
                CARRYIN => carry12,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(13),
                CARRYOUT => carry13
            );

        ULA15 : entity work.ULA1TO31
            port map(
                A => A(14),
                B => B(14),
                CARRYIN => carry13,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(14),
                CARRYOUT => carry14
            );

        ULA16 : entity work.ULA1TO31
            port map(
                A => A(15),
                B => B(15),
                CARRYIN => carry14,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(15),
                CARRYOUT => carry15
            );

        ULA17 : entity work.ULA1TO31
            port map(
                A => A(16),
                B => B(16),
                CARRYIN => carry15,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(16),
                CARRYOUT => carry16
            );

        ULA18 : entity work.ULA1TO31
            port map(
                A => A(17),
                B => B(17),
                CARRYIN => carry16,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(17),
                CARRYOUT => carry17
            );

        ULA19 : entity work.ULA1TO31
            port map(
                A => A(18),
                B => B(18),
                CARRYIN => carry17,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(18),
                CARRYOUT => carry18
            );

        ULA20 : entity work.ULA1TO31
            port map(
                A => A(19),
                B => B(19),
                CARRYIN => carry18,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(19),
                CARRYOUT => carry19
            );

        ULA21 : entity work.ULA1TO31
            port map(
                A => A(20),
                B => B(20),
                CARRYIN => carry19,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(20),
                CARRYOUT => carry20
            );

        ULA22 : entity work.ULA1TO31
            port map(
                A => A(21),
                B => B(21),
                CARRYIN => carry20,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(21),
                CARRYOUT => carry21
            );

        ULA23 : entity work.ULA1TO31
            port map(
                A => A(22),
                B => B(22),
                CARRYIN => carry21,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(22),
                CARRYOUT => carry22
            );

        ULA24 : entity work.ULA1TO31
            port map(
                A => A(23),
                B => B(23),
                CARRYIN => carry22,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(23),
                CARRYOUT => carry23
            );

        ULA25 : entity work.ULA1TO31
            port map(
                A => A(24),
                B => B(24),
                CARRYIN => carry23,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(24),
                CARRYOUT => carry24
            );

        ULA26 : entity work.ULA1TO31
            port map(
                A => A(25),
                B => B(25),
                CARRYIN => carry24,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(25),
                CARRYOUT => carry25
            );

        ULA27 : entity work.ULA1TO31
            port map(
                A => A(26),
                B => B(26),
                CARRYIN => carry25,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(26),
                CARRYOUT => carry26
            );

        ULA28 : entity work.ULA1TO31
            port map(
                A => A(27),
                B => B(27),
                CARRYIN => carry26,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(27),
                CARRYOUT => carry27
            );

        ULA29 : entity work.ULA1TO31
            port map(
                A => A(28),
                B => B(28),
                CARRYIN => carry27,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(28),
                CARRYOUT => carry28
            );

        ULA30 : entity work.ULA1TO31
            port map(
                A => A(29),
                B => B(29),
                CARRYIN => carry28,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(29),
                CARRYOUT => carry29
            );

        ULA31 : entity work.ULA1TO31
            port map(
                A => A(30),
                B => B(30),
                CARRYIN => carry29,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                RESULT => RESULT(30),
                CARRYOUT => carry30
            );

        ULA32 : entity work.ULA32
            port map(
                A => A(31),
                B => B(31),
                CARRYIN => carry30,
                SLT => '0', 
                INV_B => INV_B,
                SELECTOR => SELECTOR,
                SAIDA => RESULT(31),
                RESULT => slt
            );

        ZERO_FLAG <= '1' when unsigned(SAIDA) = unsigned(zero) ELSE '0';


end architecture;