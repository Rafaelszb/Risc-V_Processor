library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity or_gate is
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end or_gate;

architecture arch of or_gate is
begin
o_Q <= i_A or i_B;

end arch;
