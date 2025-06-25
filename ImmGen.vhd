library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ImmGen is
port(
    i_instruction : in std_logic_vector(15 downto 0);
    o_ImmGen : out std_logic_vector(31 downto 0)
);
end entity ImmGen;

architecture arch of ImmGen is
begin
    process(i_instruction)
    begin
    o_ImmGen <= (others => '0');

    if i_instruction(15) = '0' then
       o_ImmGen(31 downto 16) <= (others => '0');
       o_ImmGen(15 downto 0) <= i_instruction;

    else
       o_ImmGen(31 downto 16) <= (others => '1');
    o_ImmGen(15 downto 0) <= i_instruction;
    end if;
end process;
end arch;
