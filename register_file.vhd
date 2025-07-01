library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is   
    port (
        o_A           : out std_logic_vector(31 downto 0);
        o_B           : out std_logic_vector(31 downto 0);
        i_ReadA        : in std_logic_vector(4 downto 0);
        i_ReadB        : in std_logic_vector(4 downto 0);
        i_WriteRegSel  : in std_logic_vector(4 downto 0);
        i_WriteData    : in std_logic_vector(31 downto 0);
        i_WriteEnable  : in std_logic; 
        i_clk          : in std_logic
    );
end register_file;

architecture arch_1 of register_file is

    type reg_file_type is array (0 to 31) of std_logic_vector(31 downto 0);

    signal array_reg : reg_file_type := (
        x"00000000", x"11111111", x"22222222", x"33333333",
        x"44444444", x"55555555", x"66666666", x"77777777",
        x"88888888", x"99999999", x"AAAAAAAA", x"BBBBBBBB",
        x"CCCCCCCC", x"DDDDDDDD", x"EEEEEEEE", x"FFFFFFFF",
        x"00000000", x"11111111", x"22222222", x"33333333",
        x"44444444", x"55555555", x"66666666", x"77777777",
        x"88888888", x"99999999", x"AAAAAAAA", x"BBBBBBBB",
        x"10008000", x"7FFFF1EC", x"EEEEEEEE", x"FFFFFFFF"
    );

begin
    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if i_WriteEnable = '1' then
                array_reg(to_integer(unsigned(i_WriteRegSel))) <= i_WriteData;
            end if;
        end if;
    end process;

    o_A <= array_reg(to_integer(unsigned(i_ReadA)));
    o_B <= array_reg(to_integer(unsigned(i_ReadB)));

end arch_1;
