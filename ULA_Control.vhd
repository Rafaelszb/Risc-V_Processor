library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ULA_Control is
    Port (
        i_ALUOp      : in  STD_LOGIC_VECTOR(1 downto 0);
        i_funct3     : in  STD_LOGIC_VECTOR(2 downto 0);
        i_funct7     : in  STD_LOGIC_VECTOR(6 downto 0);
        o_ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ULA_Control;

architecture logic of ULA_Control is
    signal is_ADD, is_SUB, is_AND, is_OR, is_XOR, is_BEQ, is_LOAD_STORE : STD_LOGIC;
begin
    -- Detecção das operações:

    -- SUB: ALUOp = "10" e funct3 = "000" e funct7(5) = '1'
    is_SUB <= (i_ALUOp(1)) and (not i_ALUOp(0)) and 
              (not i_funct3(2)) and (not i_funct3(1)) and (not i_funct3(0)) and 
              (i_funct7(5));

    -- AND: ALUOp = "10" e funct3 = "111"
    is_AND <= (i_ALUOp(1)) and (not i_ALUOp(0)) and 
              (i_funct3(2)) and (i_funct3(1)) and (i_funct3(0));

    -- OR: ALUOp = "10" e funct3 = "110"
    is_OR  <= (i_ALUOp(1)) and (not i_ALUOp(0)) and 
              (i_funct3(2)) and (i_funct3(1)) and (not i_funct3(0));

    -- XOR: ALUOp = "10" e funct3 = "100"
    is_XOR <= (i_ALUOp(1)) and (not i_ALUOp(0)) and 
              (i_funct3(2)) and (not i_funct3(1)) and (not i_funct3(0));

    -- BEQ: ALUOp = "01" e funct3 = "000"
    is_BEQ <= (not i_ALUOp(1)) and (i_ALUOp(0)) and 
              (not i_funct3(2)) and (not i_funct3(1)) and (not i_funct3(0));

    -- Lógica de saída (o_ALUControl):
    o_ALUControl(2) <= is_AND or is_OR or is_XOR;
    o_ALUControl(1) <= is_OR or is_XOR;
    o_ALUControl(0) <= (is_SUB or is_BEQ) and not (is_AND or is_OR or is_XOR);

    -- Observação: Se nenhum sinal estiver ativo, o padrão é "000" (ADD/LOAD/STORE)
end logic;