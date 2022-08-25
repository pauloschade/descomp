library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Atv1 is
   generic (
          dataWidth: natural := 8;
          addrWidth: natural := 10
    );
   port (
          -- O fato da interface ser do tipo std_logic auxilía na simulação.
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of Atv1 is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        -- Inicializa todas as posições da memória com zero:
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
        -- Inicializa os endereços desejados. Os demais endereços conterão o valor zero:
        tmp(0) := x"50"; -- P
        tmp(1) := x"41"; -- A
        tmp(2) := x"55"; -- U
        tmp(3) := x"4C"; -- L
        tmp(4) := x"4F"; -- O
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    -- A conversão de tipos para obter o índice do vetor que será acessado:
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;