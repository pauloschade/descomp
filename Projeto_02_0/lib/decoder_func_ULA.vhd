

library ieee;
use ieee.std_logic_1164.all;

entity decoder_func_ULA is
   generic (
			FUNC_SIZE : natural := 6;
			DATA_SIZE : natural := 4
  );
  port ( 
			FUNC : in std_logic_vector(FUNC_SIZE-1 downto 0);
         DATA_OUT : out std_logic_vector(DATA_SIZE-1 downto 0)
  );
end entity;

architecture comportamento of decoder_func_ULA is

  constant ADD_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0010";
  constant SUB_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0110";
  
  constant OR_ULA : std_logic_vector(DATA_SIZE-1 downto 0)    := "0010";
  constant AND_ULA : std_logic_vector(DATA_SIZE-1 downto 0)   := "0000";
  
  
  constant ADD   : std_logic_vector(FUNC_SIZE-1 downto 0) := "100011";
  constant SUB   : std_logic_vector(FUNC_SIZE-1 downto 0) := "101011";
  constant AND_R : std_logic_vector(FUNC_SIZE-1 downto 0) := "000100";
  constant OR_R  : std_logic_vector(FUNC_SIZE-1 downto 0) := "000100";
  
  begin
  
  DATA_OUT <= ADD_ULA when (FUNC = ADD) else 
				  SUB_ULA when (FUNC = SUB) else
				  AND_ULA when (FUNC = AND_R) else
				  OR_ULA when  (FUNC = OR_R) else
				  "0000";
  
end architecture;