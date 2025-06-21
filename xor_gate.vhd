library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity xor_gate is
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end xor_gate;

architecture arch of xor_gate is
begin
o_Q <= i_A xor i_B;

end arch;