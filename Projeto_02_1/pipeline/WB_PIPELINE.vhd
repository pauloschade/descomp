library ieee;
use ieee.std_logic_1164.all;


-- QUAL DADO VAI ESCREVER NAS MEMORIAS DOS REGS
-- DETERMINA SE ESTA HABILITADO OU NAO

-- 0: DADO QUE SAIU DA ULA NA ENTRADA ZERO
-- 1: DADO QUE LEU DA MEMORIA RAM 
-- 2: PC+4 DO JAL 
-- 3: LUI 


entity WB_PIPELINE is
  -- Total de bits das entradas e saidas
  generic (
  	 DATA_SIZE : natural := 32;
	 REG_ADDR_SIZE : natural := 5;
	 CONTROL_SIZE : natural := 11;
	 OPCODE_SIZE : natural := 6;
	 ULA_SELECTOR_SIZE : natural := 4;
	 IMEDIATO_SIZE : natural := 16;
	 FUNC_SIZE : natural := 6
	 
  );
  port   (
	 CLK : in std_logic;
	 
	 ----------- INPUTS -------------
	 ULA_RESULT : in std_logic_vector(DATA_SIZE-1 downto 0); -- RESULTADO DA ULA
	 DATA_RD		: in std_logic_vector(DATA_SIZE-1 downto 0);
	 JAL_ADDR	: in std_logic_vector(DATA_SIZE-1 downto 0);
	 LUI_ADDR	: in std_logic_vector(DATA_SIZE-1 downto 0);  -- TODO LUI
	
	 SELECTOR_ULA_MEM : in std_logic_vector(1 downto 0);
	
	 ---------- OUTPUTS -------------
	 DATA_WR				: out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture arquitetura of WB_PIPELINE is

signal branch_sig : std_logic;

--signal rt_or_imediato : std_logic_vector(DATA_SIZE-1 downto 0);

begin

-- MUX ULA/MEM
-- 0: DADO QUE SAIU DA ULA NA ENTRADA ZERO
-- 1: DADO QUE LEU DA MEMORIA RAM 
-- 2: PC+4 DO JAL 
-- 3: LUI 
MUX_ULA_OR_RAM : entity work.muxGenerico4x1  generic map (DATA_SIZE => DATA_SIZE)
	port map (IN_A => ULA_RESULT, IN_B => DATA_RD, IN_C => JAL_ADDR, IN_D => LUI_ADDR, SELECTOR => SELECTOR_ULA_MEM, DATA_OUT => DATA_WR );
		
-- PEGA ESSE DADO AQUI PARA ESCREVER NO BANCO DE REGISTRADORES

end architecture;