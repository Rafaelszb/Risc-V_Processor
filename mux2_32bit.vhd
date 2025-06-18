library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_32bit is
    port(
        i_a   : in  std_logic_vector(31 downto 0);
        i_b   : in  std_logic_vector(31 downto 0);
        i_sel : in  std_logic;
        o_q   : out std_logic_vector(31 downto 0)
    );
end mux2_32bit;

architecture arch_generate of mux2_32bit is
begin
    gen_mux: for i in 0 to 31 generate
        o_q(i) <= (i_a(i) and not i_sel) or (i_b(i) and i_sel);
    end generate;
end arch_generate;