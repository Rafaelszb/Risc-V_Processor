library ieee;
use ieee.std_logic_1164.all;

entity shift_left is
    port (
        i_R : in  std_logic_vector(31 downto 0);
        o_Q : out std_logic_vector(31 downto 0)
    );
end shift_left;

architecture arch of shift_left is
begin
    o_Q <= i_R(30 downto 0) & '0';
end arch;
