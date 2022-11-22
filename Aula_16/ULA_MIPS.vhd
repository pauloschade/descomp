library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
 
entity ULA_MIPS is
    generic (DATA_SIZE: NATURAL := 32);
    port (IN_A: in std_logic_vector((DATA_SIZE-1) downto 0);
          IN_B: in std_logic_vector((DATA_SIZE-1) downto 0);
          INV_B: in std_logic;
          
          SELECTOR: in std_logic_vector (1 downto 0);

          DATA_OUT : out std_logic_vector((DATA_SIZE-1) downto 0);
			 
			 OVERFLOW : out std_logic;
			 
          ZERO_FLAG : out std_logic
          );
end entity;
 
architecture Behavioral of ULA_MIPS is

    constant zero: std_logic_vector((DATA_SIZE-1) downto 0) := (others => '0');
    
    signal carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7, carry8, carry9, carry10,
    carry11, carry12, carry13, carry14, carry15, carry16, carry17, carry18, carry19, carry20, carry21,
    carry22, carry23, carry24, carry25, carry26, carry27, carry28, carry29, carry30 : std_logic;

    signal slt : std_logic;

    begin
        ULA1 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(0),
                IN_B=> IN_B(0),
                CARRYIN => INV_B,
                SLT => slt, 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(0),
                CARRYOUT => carry0
            );

        ULA2 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(1),
                IN_B=> IN_B(1),
                CARRYIN => carry0,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(1),
                CARRYOUT => carry1
            );

        ULA3 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(2),
                IN_B=> IN_B(2),
                CARRYIN => carry1,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(2),
                CARRYOUT => carry2
            );

        ULA4 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(3),
                IN_B=> IN_B(3),
                CARRYIN => carry2,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(3),
                CARRYOUT => carry3
            );

        ULA5 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(4),
                IN_B=> IN_B(4),
                CARRYIN => carry3,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(4),
                CARRYOUT => carry4
            );

        ULA6 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(5),
                IN_B=> IN_B(5),
                CARRYIN => carry4,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(5),
                CARRYOUT => carry5
            );

        ULA7 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(6),
                IN_B=> IN_B(6),
                CARRYIN => carry5,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(6),
                CARRYOUT => carry6
            );

        ULA8 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(7),
                IN_B=> IN_B(7),
                CARRYIN => carry6,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(7),
                CARRYOUT => carry7
            );

        ULA9 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(8),
                IN_B=> IN_B(8),
                CARRYIN => carry7,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(8),
                CARRYOUT => carry8
            );

        ULA10 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(9),
                IN_B=> IN_B(9),
                CARRYIN => carry8,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(9),
                CARRYOUT => carry9
            );

        ULA11 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(10),
                IN_B=> IN_B(10),
                CARRYIN => carry9,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(10),
                CARRYOUT => carry10
            );

        ULA12 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(11),
                IN_B=> IN_B(11),
                CARRYIN => carry10,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(11),
                CARRYOUT => carry11
            );

        ULA13 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(12),
                IN_B=> IN_B(12),
                CARRYIN => carry11,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(12),
                CARRYOUT => carry12
            );

        ULA14 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(13),
                IN_B=> IN_B(13),
                CARRYIN => carry12,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(13),
                CARRYOUT => carry13
            );

        ULA15 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(14),
                IN_B=> IN_B(14),
                CARRYIN => carry13,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(14),
                CARRYOUT => carry14
            );

        ULA16 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(15),
                IN_B=> IN_B(15),
                CARRYIN => carry14,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(15),
                CARRYOUT => carry15
            );

        ULA17 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(16),
                IN_B=> IN_B(16),
                CARRYIN => carry15,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(16),
                CARRYOUT => carry16
            );

        ULA18 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(17),
                IN_B=> IN_B(17),
                CARRYIN => carry16,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(17),
                CARRYOUT => carry17
            );

        ULA19 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(18),
                IN_B=> IN_B(18),
                CARRYIN => carry17,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(18),
                CARRYOUT => carry18
            );

        ULA20 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(19),
                IN_B=> IN_B(19),
                CARRYIN => carry18,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(19),
                CARRYOUT => carry19
            );

        ULA21 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(20),
                IN_B=> IN_B(20),
                CARRYIN => carry19,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(20),
                CARRYOUT => carry20
            );

        ULA22 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(21),
                IN_B=> IN_B(21),
                CARRYIN => carry20,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(21),
                CARRYOUT => carry21
            );

        ULA23 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(22),
                IN_B=> IN_B(22),
                CARRYIN => carry21,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(22),
                CARRYOUT => carry22
            );

        ULA24 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(23),
                IN_B=> IN_B(23),
                CARRYIN => carry22,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(23),
                CARRYOUT => carry23
            );

        ULA25 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(24),
                IN_B=> IN_B(24),
                CARRYIN => carry23,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(24),
                CARRYOUT => carry24
            );

        ULA26 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(25),
                IN_B=> IN_B(25),
                CARRYIN => carry24,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(25),
                CARRYOUT => carry25
            );

        ULA27 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(26),
                IN_B=> IN_B(26),
                CARRYIN => carry25,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(26),
                CARRYOUT => carry26
            );

        ULA28 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(27),
                IN_B=> IN_B(27),
                CARRYIN => carry26,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(27),
                CARRYOUT => carry27
            );

        ULA29 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(28),
                IN_B=> IN_B(28),
                CARRYIN => carry27,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(28),
                CARRYOUT => carry28
            );

        ULA30 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(29),
                IN_B=> IN_B(29),
                CARRYIN => carry28,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(29),
                CARRYOUT => carry29
            );

        ULA31 : entity work.ULA1TO31
            port map(
                IN_A=> IN_A(30),
                IN_B=> IN_B(30),
                CARRYIN => carry29,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                RESULT => DATA_OUT(30),
                CARRYOUT => carry30
            );

        ULA32 : entity work.ULA32
            port map(
                IN_A=> IN_A(31),
                IN_B=> IN_B(31),
                CARRYIN => carry30,
                SLT => '0', 
                INV_B=> INV_B,
                SELECTOR => SELECTOR,
                DATA_OUT => DATA_OUT(31),
					 OVERFLOW => OVERFLOW,
                RESULT => slt
            );

        ZERO_FLAG <= '1' when unsigned(DATA_OUT) = unsigned(zero) ELSE '0';


end architecture;