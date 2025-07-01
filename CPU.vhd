library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity CPU is
	generic (
		DATA_WIDTH_MEM : natural := 32;
		ADDR_WIDTH_MEM : natural := 32;
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 32
	);



port(   i_CLK: in std_logic);
end CPU;

architecture arch of CPU is


signal w_o_RegDst, w_o_Jump, w_o_OrigALU, w_o_MemToReg, w_o_WriteReg, w_o_WriteMem, w_SEL, w_o_MemRead, w_o_BNE, w_o_BEQ, w_ULA_Zero: std_logic;

signal w_o_pc_Q, w_o_somadorPC, w_o_instruction, w_o_mux_32bits_DataMemory, w_o_readData1, 
		 w_o_readData2, w_o_sign_extended, w_o_mux_32bits_ULA, w_ULA_Result, w_DataMemory_Result,
		  w_o_addPath, w_o_mux_32bits_addPath, w_ADD_DRESS, w_o_PC_MUX : std_logic_vector(31 downto 0);
		  
signal w_ALUOp : std_logic_vector(1 downto 0);

signal w_ALUControl : std_logic_vector(2 downto 0);

component ULA is
port(
    i_A: in std_logic_vector(31 downto 0);
    i_B: in std_logic_vector(31 downto 0);
	 i_SEL: in std_logic_vector(2 downto 0);
	 i_CLK: in std_logic;
	 o_Zero: out std_logic;
    o_Q: out std_logic_vector(31 downto 0)
);
end component; 

component ULA_Control is
port(
     i_ALUOp      : in  STD_LOGIC_VECTOR(1 downto 0);
     i_funct3     : in  STD_LOGIC_VECTOR(2 downto 0);
     i_funct7     : in  STD_LOGIC_VECTOR(6 downto 0);
     o_ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
);
end component;

component somador_PC is
port(
     i_PC : in std_logic_vector (31 downto 0);
	  o_somadorPC : out std_logic_vector (31 downto 0)
);
end component;

 component ImmGen is 
 port(
      i_instr : in  std_logic_vector(31 downto 0);
      o_imm   : out std_logic_vector(31 downto 0)
 );
 end component;
 
 component unit_control is
 port(
      i_opcode      : in STD_LOGIC_VECTOR(6 downto 0);
		i_funct3      : in STD_LOGIC_VECTOR(2 downto 0);
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
 end component;
 
 component register_file is 
 port(
      o_A           : out std_logic_vector(31 downto 0);
      o_B           : out std_logic_vector(31 downto 0);
      i_ReadA        : in std_logic_vector(4 downto 0);
      i_ReadB        : in std_logic_vector(4 downto 0);
      i_WriteRegSel  : in std_logic_vector(4 downto 0);
      i_WriteData    : in std_logic_vector(31 downto 0);
      i_WriteEnable  : in std_logic; 
      i_clk          : in std_logic
 );
 end component;
 
 component register_pc is
 port(
      i_CLK : in std_logic;
      i_DATA : in std_logic_vector(31 downto 0);
      o_DATA : out std_logic_vector(31 downto 0)
 );
 end component;
 
 component instruction_memory is
 port(
 		clk		: in std_logic;
		addr	: in std_logic_vector(31 downto 0);
		q		: out std_logic_vector(31 downto 0)
 );
 end component;
 
 component data_memory is
 port(
 		i_clk		: in std_logic;
		i_addr	: in std_logic_vector(31 downto 0);
		i_data	: in std_logic_vector(31 downto 0);
		i_we		: in std_logic;
		i_re    : in std_logic;
		o_q		: out std_logic_vector(31 downto 0)
 );
end component;

component add_gate is
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;

component mux2_32bit is
port(
     i_A   : in  std_logic_vector(31 downto 0);
     i_B   : in  std_logic_vector(31 downto 0);
     i_SEL : in  std_logic;
     o_Q   : out std_logic_vector(31 downto 0)
);
end component;

component SEL_MUX is
port(
     i_Equal : in  std_logic;
     i_Jump  : in  std_logic;
     i_BEQ   : in  std_logic;
     i_BNE   : in  std_logic;
     o_SEL   : out std_logic
);
end component;
begin

    -- PC logic
    PC_reg: register_pc port map(
        i_CLK => i_CLK,
        i_DATA => w_o_PC_MUX(31 downto 0),
        o_DATA => w_o_pc_Q(31 downto 0)
    );

    PC_increment: somador_PC port map(
        i_PC => w_o_pc_Q,
        o_somadorPC => w_o_somadorPC
    );

    -- Instruction memory
    InstrMem: instruction_memory port map(
        clk => i_CLK,
        addr => w_o_pc_Q,
        q => w_o_instruction
    );

    -- Immediate generator
    ImmGen_unit: ImmGen port map(
        i_instr => w_o_instruction,
        o_imm => w_o_sign_extended
    );

    -- Control unit
    Control: unit_control port map(
        i_opcode => w_o_instruction(6 downto 0),
        i_funct3 => w_o_instruction(14 downto 12),
        o_Jump => w_o_Jump,
        o_RegWrite => w_o_WriteReg,
        o_ALUSrc => w_o_OrigALU,
        o_MemtoReg => w_o_MemToReg,
        o_MemWrite => w_o_WriteMem,
        o_MemRead => w_o_MemRead,
        o_BNE => w_o_BNE,
        o_BEQ => w_o_BEQ,
        o_ALUOp => w_ALUOp
    );

    -- Register file
    RegFile: register_file port map(
        o_A => w_o_readData1,
        o_B => w_o_readData2,
        i_ReadA => w_o_instruction(19 downto 15),
        i_ReadB => w_o_instruction(24 downto 20),
        i_WriteRegSel => w_o_instruction(11 downto 7),
        i_WriteData => w_o_mux_32bits_DataMemory,
        i_WriteEnable => w_o_WriteReg,
        i_clk => i_CLK
    );

    -- ALU control
    ALU_Control: ULA_Control port map(
        i_ALUOp => w_ALUOp,
        i_funct3 => w_o_instruction(14 downto 12),
        i_funct7 => w_o_instruction(31 downto 25),
        o_ALUControl => w_ALUControl
    );

    -- MUX para entrada da ALU
    ALU_src_mux: mux2_32bit port map(
        i_A => w_o_readData2,
        i_B => w_o_sign_extended,
        i_SEL => w_o_OrigALU,
        o_Q => w_o_mux_32bits_ULA
    );

    -- ALU
    ALU_inst: ULA port map(
        i_A => w_o_readData1,
        i_B => w_o_mux_32bits_ULA,
        i_SEL => w_ALUControl,
        i_CLK => i_CLK,
        o_Zero => w_ULA_Zero,
        o_Q => w_ULA_Result
    );

    -- Data memory
    DataMem: data_memory port map(
        i_clk => i_CLK,
        i_addr => w_ULA_Result,
        i_data => w_o_readData2,
        i_we => w_o_WriteMem,
		  i_re => w_o_MemRead,
        o_q => w_DataMemory_Result
    );

    -- MUX MemToReg
    MemToReg_mux: mux2_32bit port map(
        i_A => w_ULA_Result,
        i_B => w_DataMemory_Result,
        i_SEL => w_o_MemToReg,
        o_Q => w_o_mux_32bits_DataMemory
    );
	 
	 u_SEL_MUX : SEL_MUX port map(
	 i_Equal => w_ULA_Zero,
	 i_Jump  => w_o_Jump,
	 i_BEQ   => w_o_BEQ,
	 i_BNE   => w_o_BNE,
	 o_SEL   => w_SEL
	 );
	 
	 u_Add : add_gate port map(
	  i_A => w_o_pc_Q,
     i_B => w_o_sign_extended,
     o_Q => w_ADD_DRESS
	 
	 );
	 
    PC_mux: mux2_32bit port map(
        i_A => w_o_somadorPC,
        i_B => w_ADD_DRESS,
        i_SEL => w_SEL,
        o_Q => w_o_PC_MUX
    );	 

end arch;
 