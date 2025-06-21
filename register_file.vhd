library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is   
    port
    (
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

architecture behavioral of register_file is
    type registerFile is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal registers : registerFile := (others => (others => '0'));
begin

    -- Escrita síncrona
    process(i_clk)
    begin
        if rising_edge(i_clk) then 
            if (i_WriteEnable = '1') then
                registers(to_integer(unsigned(i_WriteRegSel))) <= i_WriteData;
            end if;
        end if;
    end process;

    -- Leitura assíncrona
    o_A <= registers(to_integer(unsigned(i_ReadA)));
    o_B <= registers(to_integer(unsigned(i_ReadB)));

end behavioral;