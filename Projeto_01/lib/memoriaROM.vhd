library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3;
			 opcodeSize: natural := 4
    );
   port (
          address : in std_logic_vector (addrWidth-1 DOWNTO 0);
          data : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;



architecture assincrona of memoriaROM is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";
  constant ANDB  : std_logic_vector(3 downto 0) := "1011";

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin

tmp(0) := LDI & "111" & "000000000"; -- LDI [7] $0

tmp(1) := STA & "111" & "000001000"; -- STA [7] @8

tmp(2) := LDI & "111" & "000000001"; -- LDI [7] $1

tmp(3) := STA & "111" & "000001001"; -- STA [7] @9

tmp(4) := LDI & "111" & "000001001"; -- LDI [7] $9

tmp(5) := STA & "111" & "000010001"; -- STA [7] @17

tmp(6) := STA & "111" & "000000010"; -- STA [7] @2

tmp(7) := STA & "111" & "000000011"; -- STA [7] @3

tmp(8) := STA & "111" & "000000100"; -- STA [7] @4

tmp(9) := STA & "111" & "000000101"; -- STA [7] @5

tmp(10) := STA & "111" & "000000110"; -- STA [7] @6

tmp(11) := STA & "111" & "000000111"; -- STA [7] @7

tmp(12) := LDI & "111" & "010000000"; -- LDI [7] $128

tmp(13) := STA & "111" & "000001100"; -- STA [7] @12

tmp(14) := STA & "000" & "111111111"; -- STA @511

tmp(15) := STA & "000" & "111111110"; -- STA @510

tmp(16) := JMP & "000" & "001001011"; -- JMP @75

tmp(17) := LDA & "111" & "101100100"; -- LDA [7] @356

tmp(18) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(19) := JEQ & "000" & "001001011"; -- JEQ @75

tmp(20) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(21) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(22) := JEQ & "000" & "001100010"; -- JEQ @98

tmp(23) := LDA & "111" & "101100000"; -- LDA [7] @352

tmp(24) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(25) := JEQ & "000" & "000010001"; -- JEQ @17

tmp(26) := JMP & "000" & "010111001"; -- JMP @185

tmp(27) := LDA & "110" & "000001000"; -- LDA [6] @8

tmp(28) := STA & "110" & "100000001"; -- STA [6] @257

tmp(29) := JSR & "000" & "000011111"; -- JSR @31

tmp(30) := JMP & "000" & "000010001"; -- JMP @17

tmp(31) := STA & "000" & "111111111"; -- STA @511

tmp(32) := CEQ & "000" & "000010001"; -- CEQ [0] @17

tmp(33) := JEQ & "000" & "000100101"; -- JEQ @37

tmp(34) := SOMA & "000" & "000001001"; -- SOMA [0] @9

tmp(35) := STA & "000" & "100100000"; -- STA [0] @288

tmp(36) := RET & "000" & "000000000"; -- RET

tmp(37) := LDA & "000" & "000001000"; -- LDA [0] @8

tmp(38) := STA & "000" & "100100000"; -- STA [0] @288

tmp(39) := CEQ & "001" & "000010001"; -- CEQ [1] @17

tmp(40) := JEQ & "000" & "000101100"; -- JEQ @44

tmp(41) := SOMA & "001" & "000001001"; -- SOMA [1] @9

tmp(42) := STA & "001" & "100100001"; -- STA [1] @289

tmp(43) := RET & "000" & "000000000"; -- RET

tmp(44) := LDA & "001" & "000001000"; -- LDA [1] @8

tmp(45) := STA & "001" & "100100001"; -- STA [1] @289

tmp(46) := CEQ & "010" & "000010001"; -- CEQ [2] @17

tmp(47) := JEQ & "000" & "000110011"; -- JEQ @51

tmp(48) := SOMA & "010" & "000001001"; -- SOMA [2] @9

tmp(49) := STA & "010" & "100100010"; -- STA [2] @290

tmp(50) := RET & "000" & "000000000"; -- RET

tmp(51) := LDA & "010" & "000001000"; -- LDA [2] @8

tmp(52) := STA & "010" & "100100010"; -- STA [2] @290

tmp(53) := CEQ & "011" & "000010001"; -- CEQ [3] @17

tmp(54) := JEQ & "000" & "000111010"; -- JEQ @58

tmp(55) := SOMA & "011" & "000001001"; -- SOMA [3] @9

tmp(56) := STA & "011" & "100100011"; -- STA [3] @291

tmp(57) := RET & "000" & "000000000"; -- RET

tmp(58) := LDA & "011" & "000001000"; -- LDA [3] @8

tmp(59) := STA & "011" & "100100011"; -- STA [3] @291

tmp(60) := CEQ & "100" & "000010001"; -- CEQ [4] @17

tmp(61) := JEQ & "000" & "001000001"; -- JEQ @65

tmp(62) := SOMA & "100" & "000001001"; -- SOMA [4] @9

tmp(63) := STA & "100" & "100100100"; -- STA [4] @292

tmp(64) := RET & "000" & "000000000"; -- RET

tmp(65) := LDA & "100" & "000001000"; -- LDA [4] @8

tmp(66) := STA & "100" & "100100100"; -- STA [4] @292

tmp(67) := CEQ & "101" & "000010001"; -- CEQ [5] @17

tmp(68) := JEQ & "000" & "001001000"; -- JEQ @72

tmp(69) := SOMA & "101" & "000001001"; -- SOMA [5] @9

tmp(70) := STA & "101" & "100100101"; -- STA [5] @293

tmp(71) := RET & "000" & "000000000"; -- RET

tmp(72) := LDI & "110" & "000001001"; -- LDI [6] @9

tmp(73) := STA & "110" & "100000010"; -- STA [6] @258

tmp(74) := RET & "000" & "000000000"; -- RET

tmp(75) := LDI & "000" & "000000000"; -- LDI [0] $0

tmp(76) := LDI & "001" & "000000000"; -- LDI [1] $0

tmp(77) := LDI & "010" & "000000000"; -- LDI [2] $0

tmp(78) := LDI & "011" & "000000000"; -- LDI [3] $0

tmp(79) := LDI & "100" & "000000000"; -- LDI [4] $0

tmp(80) := LDI & "101" & "000000000"; -- LDI [5] $0

tmp(81) := JSR & "000" & "001010011"; -- JSR @83

tmp(82) := JMP & "000" & "000010001"; -- JMP @17

tmp(83) := STA & "000" & "100100000"; -- STA [0] @288

tmp(84) := STA & "001" & "100100001"; -- STA [1] @289

tmp(85) := STA & "010" & "100100010"; -- STA [2] @290

tmp(86) := STA & "011" & "100100011"; -- STA [3] @291

tmp(87) := STA & "100" & "100100100"; -- STA [4] @292

tmp(88) := STA & "101" & "100100101"; -- STA [5] @293

tmp(89) := RET & "000" & "000000000"; -- RET

tmp(90) := LDI & "111" & "000000000"; -- LDI [7] $0

tmp(91) := STA & "111" & "100100000"; -- STA [7] @288

tmp(92) := STA & "111" & "100100001"; -- STA [7] @289

tmp(93) := STA & "111" & "100100010"; -- STA [7] @290

tmp(94) := STA & "111" & "100100011"; -- STA [7] @291

tmp(95) := STA & "111" & "100100100"; -- STA [7] @292

tmp(96) := STA & "111" & "100100101"; -- STA [7] @293

tmp(97) := RET & "000" & "000000000"; -- RET

tmp(98) := LDA & "110" & "000001100"; -- LDA [6] @12

tmp(99) := STA & "110" & "000010000"; -- STA [6] @16

tmp(100) := JSR & "000" & "001011010"; -- JSR @90

tmp(101) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(102) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(103) := JSR & "000" & "010101010"; -- JSR @170

tmp(104) := STA & "110" & "100100000"; -- STA [6] @288

tmp(105) := STA & "110" & "000000010"; -- STA [6] @2

tmp(106) := STA & "000" & "111111110"; -- STA @510

tmp(107) := LDI & "111" & "000000010"; -- LDI [7] $2

tmp(108) := STA & "111" & "100000000"; -- STA [7] @256

tmp(109) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(110) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(111) := JEQ & "000" & "001101101"; -- JEQ @109

tmp(112) := STA & "000" & "111111110"; -- STA @510

tmp(113) := LDI & "111" & "000000100"; -- LDI [7] $4

tmp(114) := STA & "111" & "100000000"; -- STA [7] @256

tmp(115) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(116) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(117) := JSR & "000" & "010101010"; -- JSR @170

tmp(118) := STA & "110" & "100100001"; -- STA [6] @289

tmp(119) := STA & "110" & "000000011"; -- STA [6] @3

tmp(120) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(121) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(122) := JEQ & "000" & "001111000"; -- JEQ @120

tmp(123) := STA & "000" & "111111110"; -- STA @510

tmp(124) := LDI & "111" & "000001000"; -- LDI [7] $8

tmp(125) := STA & "111" & "100000000"; -- STA [7] @256

tmp(126) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(127) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(128) := JSR & "000" & "010101010"; -- JSR @170

tmp(129) := STA & "110" & "100100010"; -- STA [6] @290

tmp(130) := STA & "110" & "000000100"; -- STA [6] @4

tmp(131) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(132) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(133) := JEQ & "000" & "010000011"; -- JEQ @131

tmp(134) := STA & "000" & "111111110"; -- STA @510

tmp(135) := LDI & "111" & "000010000"; -- LDI [7] $16

tmp(136) := STA & "111" & "100000000"; -- STA [7] @256

tmp(137) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(138) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(139) := JSR & "000" & "010101010"; -- JSR @170

tmp(140) := STA & "110" & "100100011"; -- STA [6] @291

tmp(141) := STA & "110" & "000000101"; -- STA [6] @5

tmp(142) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(143) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(144) := JEQ & "000" & "010001110"; -- JEQ @142

tmp(145) := STA & "000" & "111111110"; -- STA @510

tmp(146) := LDI & "111" & "000100000"; -- LDI [7] $32

tmp(147) := STA & "111" & "100000000"; -- STA [7] @256

tmp(148) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(149) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(150) := JSR & "000" & "010101010"; -- JSR @170

tmp(151) := STA & "110" & "100100100"; -- STA [6] @292

tmp(152) := STA & "110" & "000000110"; -- STA [6] @6

tmp(153) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(154) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(155) := JEQ & "000" & "010011001"; -- JEQ @153

tmp(156) := STA & "000" & "111111110"; -- STA @510

tmp(157) := LDI & "111" & "000000000"; -- LDI [7] $0

tmp(158) := STA & "111" & "100000000"; -- STA [7] @256

tmp(159) := LDA & "110" & "101000000"; -- LDA [6] @320

tmp(160) := LDA & "111" & "000010001"; -- LDA [7] @17

tmp(161) := JSR & "000" & "010101010"; -- JSR @170

tmp(162) := STA & "110" & "100100101"; -- STA [6] @293

tmp(163) := STA & "110" & "000000111"; -- STA [6] @7

tmp(164) := LDA & "111" & "101100001"; -- LDA [7] @353

tmp(165) := CEQ & "111" & "000001000"; -- CEQ [7] @8

tmp(166) := JEQ & "000" & "010100100"; -- JEQ @164

tmp(167) := STA & "000" & "111111110"; -- STA @510

tmp(168) := JSR & "000" & "001010011"; -- JSR @83

tmp(169) := JMP & "000" & "000010001"; -- JMP @17

tmp(170) := STA & "110" & "000001101"; -- STA [6] @13

tmp(171) := STA & "111" & "000001110"; -- STA [7] @14

tmp(172) := SUB & "111" & "000001101"; -- SUB [7] @13

tmp(173) := ANDB & "111" & "000001100"; -- ANDB [7] @12

tmp(174) := CEQ & "111" & "000010000"; -- CEQ [7] @16

tmp(175) := JEQ & "000" & "010110010"; -- JEQ @178

tmp(176) := LDA & "111" & "000001000"; -- LDA [7] @8

tmp(177) := RET & "000" & "000000000"; -- RET

tmp(178) := LDA & "110" & "000001110"; -- LDA [6] @14

tmp(179) := LDA & "111" & "000001001"; -- LDA [7] @9

tmp(180) := RET & "000" & "000000000"; -- RET

tmp(181) := STA & "000" & "111111111"; -- STA @511

tmp(182) := LDA & "110" & "000001001"; -- LDA [6] @9

tmp(183) := STA & "110" & "100000001"; -- STA [6] @257

tmp(184) := JMP & "000" & "000010001"; -- JMP @17

tmp(185) := LDA & "110" & "000001100"; -- LDA [6] @12

tmp(186) := STA & "110" & "000010000"; -- STA [6] @16

tmp(187) := STA & "101" & "000001111"; -- STA [5] @15

tmp(188) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(189) := LDA & "110" & "000000111"; -- LDA [6] @7

tmp(190) := JSR & "000" & "010101010"; -- JSR @170

tmp(191) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(192) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(193) := STA & "100" & "000001111"; -- STA [4] @15

tmp(194) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(195) := LDA & "110" & "000000110"; -- LDA [6] @6

tmp(196) := JSR & "000" & "010101010"; -- JSR @170

tmp(197) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(198) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(199) := STA & "011" & "000001111"; -- STA [3] @15

tmp(200) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(201) := LDA & "110" & "000000101"; -- LDA [6] @5

tmp(202) := JSR & "000" & "010101010"; -- JSR @170

tmp(203) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(204) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(205) := STA & "010" & "000001111"; -- STA [2] @15

tmp(206) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(207) := LDA & "110" & "000000100"; -- LDA [6] @4

tmp(208) := JSR & "000" & "010101010"; -- JSR @170

tmp(209) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(210) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(211) := STA & "001" & "000001111"; -- STA [1] @15

tmp(212) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(213) := LDA & "110" & "000000011"; -- LDA [6] @3

tmp(214) := JSR & "000" & "010101010"; -- JSR @170

tmp(215) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(216) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(217) := STA & "000" & "000001111"; -- STA [0] @15

tmp(218) := LDA & "111" & "000001111"; -- LDA [7] @15

tmp(219) := LDA & "110" & "000000010"; -- LDA [6] @2

tmp(220) := JSR & "000" & "010101010"; -- JSR @170

tmp(221) := CEQ & "111" & "000001001"; -- CEQ [7] @9

tmp(222) := JEQ & "000" & "000011011"; -- JEQ @27

tmp(223) := JMP & "000" & "010110101"; -- JMP @181
  
--tmp(0) := LDI & "111" & "000000000"; -- LDI [7] $0
--
--tmp(1) := STA & "000" & "000001000"; -- STA [0] @8
--
--tmp(2) := LDI & "111" & "000000001"; -- LDI [7] $1
--
--tmp(3) := STA & "111" & "000001001"; -- STA [7] @9
--
--tmp(4) := LDI & "111" & "000001001"; -- LDI [7] $9
--
--tmp(5) := STA & "111" & "000001110"; -- STA [7] @14
--
--tmp(6) := STA & "000" & "111111111"; -- STA @511
--
--tmp(7) := STA & "000" & "111111110"; -- STA @510
--
--tmp(8) := LDA & "111" & "101100100"; -- LDA [7] @356
--
--tmp(9) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(10) := JEQ & "000" & "000111111"; -- JEQ @63
--
--tmp(11) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(12) := CEQ & "111" & "000001001"; -- CEQ [7] @9
--
--tmp(13) := JEQ & "000" & "001001100"; -- JEQ @76
--
--tmp(14) := LDA & "111" & "101100000"; -- LDA [7] @352
--
--tmp(15) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(16) := JEQ & "000" & "000001000"; -- JEQ @8
--
--tmp(17) := JSR & "000" & "000010011"; -- JSR @19
--
--tmp(18) := JMP & "000" & "000001000"; -- JMP @8
--
--tmp(19) := STA & "000" & "111111111"; -- STA @511
--
--tmp(20) := CEQ & "000" & "000001110"; -- CEQ [0] @14
--
--tmp(21) := JEQ & "000" & "000011001"; -- JEQ @25
--
--tmp(22) := SOMA & "000" & "000001001"; -- SOMA [0] @9
--
--tmp(23) := STA & "000" & "100100000"; -- STA [0] @288
--
--tmp(24) := RET & "000" & "000000000"; -- RET
--
--tmp(25) := LDA & "000" & "000001000"; -- LDA [0] @8
--
--tmp(26) := STA & "000" & "100100000"; -- STA [0] @288
--
--tmp(27) := CEQ & "001" & "000001110"; -- CEQ [1] @14
--
--tmp(28) := JEQ & "000" & "000100000"; -- JEQ @32
--
--tmp(29) := SOMA & "001" & "000001001"; -- SOMA [1] @9
--
--tmp(30) := STA & "001" & "100100001"; -- STA [1] @289
--
--tmp(31) := RET & "000" & "000000000"; -- RET
--
--tmp(32) := LDA & "001" & "000001000"; -- LDA [1] @8
--
--tmp(33) := STA & "001" & "100100001"; -- STA [1] @289
--
--tmp(34) := CEQ & "010" & "000001110"; -- CEQ [2] @14
--
--tmp(35) := JEQ & "000" & "000100111"; -- JEQ @39
--
--tmp(36) := SOMA & "010" & "000001001"; -- SOMA [2] @9
--
--tmp(37) := STA & "010" & "100100010"; -- STA [2] @290
--
--tmp(38) := RET & "000" & "000000000"; -- RET
--
--tmp(39) := LDA & "010" & "000001000"; -- LDA [2] @8
--
--tmp(40) := STA & "010" & "100100010"; -- STA [2] @290
--
--tmp(41) := CEQ & "011" & "000001110"; -- CEQ [3] @14
--
--tmp(42) := JEQ & "000" & "000101110"; -- JEQ @46
--
--tmp(43) := SOMA & "011" & "000001001"; -- SOMA [3] @9
--
--tmp(44) := STA & "011" & "100100011"; -- STA [3] @291
--
--tmp(45) := RET & "000" & "000000000"; -- RET
--
--tmp(46) := LDA & "011" & "000001000"; -- LDA [3] @8
--
--tmp(47) := STA & "011" & "100100011"; -- STA [3] @291
--
--tmp(48) := CEQ & "100" & "000001110"; -- CEQ [4] @14
--
--tmp(49) := JEQ & "000" & "000110101"; -- JEQ @53
--
--tmp(50) := SOMA & "100" & "000001001"; -- SOMA [4] @9
--
--tmp(51) := STA & "100" & "100100100"; -- STA [4] @292
--
--tmp(52) := RET & "000" & "000000000"; -- RET
--
--tmp(53) := LDA & "100" & "000001000"; -- LDA [4] @8
--
--tmp(54) := STA & "100" & "100100100"; -- STA [4] @292
--
--tmp(55) := CEQ & "101" & "000001110"; -- CEQ [5] @14
--
--tmp(56) := JEQ & "000" & "000111100"; -- JEQ @60
--
--tmp(57) := SOMA & "101" & "000001001"; -- SOMA [5] @9
--
--tmp(58) := STA & "101" & "100100101"; -- STA [5] @293
--
--tmp(59) := RET & "000" & "000000000"; -- RET
--
--tmp(60) := LDI & "110" & "000000001"; -- LDI [6] $1
--
--tmp(61) := STA & "110" & "100000010"; -- STA [6] @258
--
--tmp(62) := RET & "000" & "000000000"; -- RET
--
--tmp(63) := LDI & "000" & "000000000"; -- LDI [0] $0
--
--tmp(64) := LDI & "001" & "000000000"; -- LDI [1] $0
--
--tmp(65) := LDI & "010" & "000000000"; -- LDI [2] $0
--
--tmp(66) := LDI & "011" & "000000000"; -- LDI [3] $0
--
--tmp(67) := LDI & "100" & "000000000"; -- LDI [4] $0
--
--tmp(68) := LDI & "101" & "000000000"; -- LDI [5] $0
--
--tmp(69) := STA & "000" & "100100000"; -- STA [0] @288
--
--tmp(70) := STA & "001" & "100100001"; -- STA [1] @289
--
--tmp(71) := STA & "010" & "100100010"; -- STA [2] @290
--
--tmp(72) := STA & "011" & "100100011"; -- STA [3] @291
--
--tmp(73) := STA & "100" & "100100100"; -- STA [4] @292
--
--tmp(74) := STA & "101" & "100100101"; -- STA [5] @293
--
--tmp(75) := JMP & "000" & "000001000"; -- JMP @8
--
--tmp(76) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(77) := STA & "110" & "100100000"; -- STA [6] @288
--
--tmp(78) := STA & "110" & "000000010"; -- STA [6] @2
--
--tmp(79) := STA & "000" & "111111110"; -- STA @510
--
--tmp(80) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(81) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(82) := JEQ & "000" & "001010000"; -- JEQ @80
--
--tmp(83) := STA & "000" & "111111110"; -- STA @510
--
--tmp(84) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(85) := STA & "110" & "100100001"; -- STA [6] @289
--
--tmp(86) := STA & "110" & "000000011"; -- STA [6] @3
--
--tmp(87) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(88) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(89) := JEQ & "000" & "001010111"; -- JEQ @87
--
--tmp(90) := STA & "000" & "111111110"; -- STA @510
--
--tmp(91) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(92) := STA & "110" & "100100010"; -- STA [6] @290
--
--tmp(93) := STA & "110" & "000000100"; -- STA [6] @4
--
--tmp(94) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(95) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(96) := JEQ & "000" & "001011110"; -- JEQ @94
--
--tmp(97) := STA & "000" & "111111110"; -- STA @510
--
--tmp(98) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(99) := STA & "110" & "100100011"; -- STA [6] @291
--
--tmp(100) := STA & "110" & "000000101"; -- STA [6] @5
--
--tmp(101) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(102) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(103) := JEQ & "000" & "001100101"; -- JEQ @101
--
--tmp(104) := STA & "000" & "111111110"; -- STA @510
--
--tmp(105) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(106) := STA & "110" & "100100100"; -- STA [6] @292
--
--tmp(107) := STA & "110" & "000000110"; -- STA [6] @6
--
--tmp(108) := LDA & "111" & "101100001"; -- LDA [7] @353
--
--tmp(109) := CEQ & "111" & "000001000"; -- CEQ [7] @8
--
--tmp(110) := JEQ & "000" & "001101100"; -- JEQ @108
--
--tmp(111) := STA & "000" & "111111110"; -- STA @510
--
--tmp(112) := LDA & "110" & "101000000"; -- LDA [6] @320
--
--tmp(113) := STA & "110" & "100100101"; -- STA [6] @293
--
--tmp(114) := STA & "110" & "000000111"; -- STA [6] @7
--
--tmp(115) := STA & "000" & "111111110"; -- STA @510
--
--tmp(116) := JMP & "000" & "000111111"; -- JMP @63


		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    data <= memROM (to_integer(unsigned(address)));
end architecture;