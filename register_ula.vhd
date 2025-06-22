library IEEE;
use IEEE.std_logic_1164.all;

entity register_ula is
port (
      i_CLK : in std_logic;
      i_DATA : in std_logic_vector(31 downto 0);
      o_DATA : out std_logic_vector(31 downto 0)
);

end register_ula;

architecture arch of register_ula is
signal w_DATA : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

begin
process(i_CLK)

begin

if (rising_edge(i_CLK)) then
    w_DATA <= i_DATA;
    end if;
    end process;

o_DATA <= w_DATA;
end arch;