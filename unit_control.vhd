library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_control is
    Port (
        opcode      : in  STD_LOGIC_VECTOR(6 downto 0);
        -- Sinais de controle de saída
        RegWrite    : out STD_LOGIC;
        ALUSrc      : out STD_LOGIC;
        MemtoReg    : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        MemRead     : out STD_LOGIC;
        Branch      : out STD_LOGIC;
        ALUOp       : out STD_LOGIC_VECTOR(1 downto 0)
    );
end unit_control;

architecture behavioral of unit_control is
    -- Sinais intermediários para cada tipo de instrução
    signal is_rtype, is_itype, is_load, is_store, is_branch : STD_LOGIC;
begin
    
    -- Decodificação de opcodes usando apenas portas lógicas
    -- R-type: opcode = "0110011"
    is_rtype <= not opcode(6) and opcode(5) and opcode(4) and 
                not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
                
    -- Load: opcode = "0000011"
    is_load <= not opcode(6) and not opcode(5) and not opcode(4) and 
               not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
               
    -- Store: opcode = "0100011"
    is_store <= not opcode(6) and opcode(5) and not opcode(4) and 
                not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
                
    -- Branch: opcode = "1100011"
    is_branch <= opcode(6) and opcode(5) and not opcode(4) and 
                 not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
                 
    -- I-type (arithmetic): opcode = "0010011"
    is_itype <= not opcode(6) and not opcode(5) and opcode(4) and 
                not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
   
    -- Geração dos sinais de controle usando portas lógicas
    -- RegWrite: ativo para R-type, I-type e load
    RegWrite <= (is_rtype or is_itype) or is_load;
    
    -- ALUSrc: ativo para load, store e I-type
    ALUSrc <= (is_load or is_store) or is_itype;
    
    -- MemtoReg: ativo apenas para load
    MemtoReg <= is_load;
    
    -- MemWrite: ativo para store
    MemWrite <= is_store;
    
    -- MemRead: ativo para load
    MemRead <= is_load;
    
    -- Branch: ativo para branch
    Branch <= is_branch;
    
    -- ALUOp:
    -- Bit 1: '1' para R-type e I-type
    ALUOp(1) <= is_rtype or is_itype;
    
    -- Bit 0: '1' para branch
    ALUOp(0) <= is_branch;
end behavioral;