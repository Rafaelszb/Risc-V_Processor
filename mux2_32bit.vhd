library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_32bit is
    port(
        i_A   : in  std_logic_vector(31 downto 0);
        i_B   : in  std_logic_vector(31 downto 0);
        i_SEL : in  std_logic;
        o_Q   : out std_logic_vector(31 downto 0)
    );
end mux2_32bit;

architecture arch_generate of mux2_32bit is
begin
    gen_mux: for i in 0 to 31 generate
        o_Q(i) <= (i_A(i) and not i_SEL) or (i_B(i) and i_SEL);
    end generate;
end arch_generate;