library IEEE;
use IEEE.std_logic_1164.all;

entity port_not is
    port(
    i_A: in std_logic_vector(31 downto 0);
    o_Q: out std_logic_vector(31 downto 0)
    );
end port_not ;
architecture arch of port_not is
begin

o_Q <= not i_A;
end arch;
