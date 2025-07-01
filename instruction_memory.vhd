library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
    port (
        clk  : in  std_logic;
        addr : in  std_logic_vector(31 downto 0);
        q    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of instruction_memory is

    subtype word_t is std_logic_vector(31 downto 0);
    type memory_t is array(0 to 31) of word_t;

    -- Inicialização simples da ROM
    function init_rom return memory_t is
        variable tmp : memory_t := (others => (others => '0'));
    begin
        -- Exemplo: cada posição contém seu próprio endereço
        for i in 0 to 31 loop
            tmp(i) := std_logic_vector(to_unsigned(i, 32));
        end loop;
        return tmp;
    end function;

    signal rom : memory_t := init_rom;
    signal addr_int : integer range 0 to 31;

begin

process(clk)
begin
    if rising_edge(clk) then
        addr_int <= to_integer(unsigned(addr(4 downto 0)));
        q <= rom(addr_int);  -- Agora ele é usado
    end if;
end process;


end architecture;
