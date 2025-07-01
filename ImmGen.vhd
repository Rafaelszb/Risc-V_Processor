library IEEE;
use IEEE.std_logic_1164.all;

entity ImmGen is
    port (
        i_instr : in  std_logic_vector(31 downto 0);
        o_imm   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ImmGen is
begin
    process(i_instr)
        variable imm_out : std_logic_vector(31 downto 0);
        variable imm12   : std_logic_vector(11 downto 0);
        variable imm13   : std_logic_vector(12 downto 0);
        variable imm21   : std_logic_vector(20 downto 0);
        variable sign_bit: std_logic;
        variable opcode  : std_logic_vector(6 downto 0);
    begin
        opcode := i_instr(6 downto 0);
        sign_bit := i_instr(31);

        case opcode is
            when "0000011" | "0010011" =>  -- Tipo I
                imm12 := i_instr(31 downto 20);
                imm_out := (others => sign_bit);
                imm_out(11 downto 0) := imm12;

            when "0100011" =>  -- Tipo S
                imm12 := i_instr(31 downto 25) & i_instr(11 downto 7);
                imm_out := (others => sign_bit);
                imm_out(11 downto 0) := imm12;

            when "1100011" =>  -- Tipo B (branch)
                -- imm[12|10:5|4:1|11|0], zero is least significant bit (always 0)
                imm13 := i_instr(31) & i_instr(7) & i_instr(30 downto 25) & i_instr(11 downto 8) & '0';
                imm_out := (others => sign_bit);
                imm_out(12 downto 0) := imm13;

            when "1101111" =>  -- Tipo J (jump)
                -- imm[20|10:1|11|19:12|0]
                imm21 := i_instr(31) & i_instr(19 downto 12) & i_instr(20) & i_instr(30 downto 21) & '0';
                imm_out := (others => sign_bit);
                imm_out(20 downto 0) := imm21;

            when "0110011" =>  -- Tipo R (sem imediato)
                imm_out := (others => '0');

            when others =>
                imm_out := (others => '0');
        end case;

        o_imm <= imm_out;
    end process;
end architecture;
