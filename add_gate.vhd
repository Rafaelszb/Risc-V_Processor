library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_gate is
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end add_gate;

architecture arch of add_gate is
begin
o_Q <= std_logic_vector(signed(i_A) + signed(i_B));

end arch;