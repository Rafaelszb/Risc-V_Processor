library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity and_gate is
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end and_gate;

architecture arch of and_gate is
begin
o_Q <= i_A and i_B;

end arch;
