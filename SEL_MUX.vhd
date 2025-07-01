library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SEL_MUX is 
    port(
        i_Equal : in  std_logic;
        i_Jump  : in  std_logic;
        i_BEQ   : in  std_logic;
        i_BNE   : in  std_logic;
        o_SEL   : out std_logic
    );
end SEL_MUX;

architecture arch of SEL_MUX is
begin
    process(i_BEQ, i_Equal, i_BNE, i_Jump)
    begin
        o_SEL <= ((i_BEQ and i_Equal) or (i_BNE and not i_Equal)) or i_Jump;
    end process;
end arch;
