library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unit_control is
    Port (
        i_opcode      : in STD_LOGIC_VECTOR(6 downto 0);
		  i_funct3      : in STD_LOGIC_VECTOR(2 downto 0);
        -- Sinais de controle de saída
        o_Jump        : out STD_LOGIC;
        o_RegWrite    : out STD_LOGIC;
        o_ALUSrc      : out STD_LOGIC;
        o_MemtoReg    : out STD_LOGIC;
        o_MemWrite    : out STD_LOGIC;
        o_MemRead     : out STD_LOGIC;
        o_BNE         : out STD_LOGIC;
        o_BEQ         : out STD_LOGIC;
        o_ALUOp       : out STD_LOGIC_VECTOR(1 downto 0)
    );
end unit_control;

architecture behavioral of unit_control is
    -- Sinais intermediários para cada tipo de instrução
    signal is_rtype, is_itype, is_load, is_store, is_branch, is_jump : STD_LOGIC;
begin
    
    -- Decodificação de opcodes 
    -- R-type: opcode = "0110011"
    is_rtype <= not i_opcode(6) and i_opcode(5) and i_opcode(4) and 
                not i_opcode(3) and not i_opcode(2) and i_opcode(1) and i_opcode(0);
                
    -- Load: opcode = "0000011"
    is_load <= not i_opcode(6) and not i_opcode(5) and not i_opcode(4) and 
               not i_opcode(3) and not i_opcode(2) and i_opcode(1) and i_opcode(0);
               
    -- Store: opcode = "0100011"
    is_store <= not i_opcode(6) and i_opcode(5) and not i_opcode(4) and 
                not i_opcode(3) and not i_opcode(2) and i_opcode(1) and i_opcode(0);
                
    -- Branch: opcode = "1100011"
    is_branch <= i_opcode(6) and i_opcode(5) and not i_opcode(4) and 
                 not i_opcode(3) and not i_opcode(2) and i_opcode(1) and i_opcode(0);
                 
    -- I-type (arithmetic): opcode = "0010011"
    is_itype <= not i_opcode(6) and not i_opcode(5) and i_opcode(4) and 
                not i_opcode(3) and not i_opcode(2) and i_opcode(1) and i_opcode(0);

    -- J-type (Jump): opcode =  "1101111"
    is_jump <= i_opcode(6) and i_opcode(5) and not i_opcode(4) 
                and i_opcode(3) and i_opcode(2) and i_opcode(1) and i_opcode(0);

    -- Geração dos sinais de controle usando portas lógicas
    -- RegWrite: ativo para R-type, I-type e load
    o_RegWrite <= (is_rtype or is_itype) or is_load;
    
    -- ALUSrc: ativo para load, store e I-type
    o_ALUSrc <= (is_load or is_store) or is_itype;
    
    -- MemtoReg: ativo apenas para load
    o_MemtoReg <= is_load;
    
    -- MemWrite: ativo para store
    o_MemWrite <= is_store;
    
    -- MemRead: ativo para load
    o_MemRead <= is_load;
    
    -- Jump: ativo para jump
    o_Jump <= is_jump;

	 o_BEQ <= is_branch and not i_funct3(2) and not i_funct3(1) and not i_funct3(0);
	 o_BNE <= is_branch and not i_funct3(2) and not i_funct3(1) and i_funct3(0);
	 
    -- ALUOp:
    -- Bit 1: '1' para R-type ou I-type
    o_ALUOp(1) <= is_rtype or is_itype;
    
    -- Bit 0: '1' para branch
    o_ALUOp(0) <= is_branch;
end behavioral;