library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity plus_one is
    port(
    i_A: in std_logic_vector(31 downto 0);
    o_Q: out std_logic_vector(31 downto 0)
);
end plus_one;

architecture arch of plus_one is
begin

o_Q <= std_logic_vector(signed(i_A) + 1);
end arch;