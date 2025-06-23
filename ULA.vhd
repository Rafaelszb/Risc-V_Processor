library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
port(
    i_A: in std_logic_vector(31 downto 0);
    i_B: in std_logic_vector(31 downto 0);
	 i_SEL: in std_logic_vector(2 downto 0);
	 i_CLK: in std_logic;
	 o_Zero: out std_logic;
    o_Q: out std_logic_vector(31 downto 0)
);
end ULA;

architecture arch of ULA is
signal w_Add, w_Sub, w_And, w_Or, w_Xor, w_Mux, w_plus_one, w_Not : std_logic_vector(31 downto 0);

component add_gate 
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;


component sub_gate 
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;


component and_gate
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;


component xor_gate
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;

component or_gate
port(
     i_A: in std_logic_vector(31 downto 0);
     i_B: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;

component port_not
port(
     i_A: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;

component plus_one
port(
     i_A: in std_logic_vector(31 downto 0);
     o_Q: out std_logic_vector(31 downto 0)
);
end component;


component mux8_32bit
	port(
			i_SEL: in std_logic_vector(2 downto 0);
			i_Add: in std_logic_vector(31 downto 0);
			i_Sub: in std_logic_vector(31 downto 0);
			i_plus_one: in std_logic_vector(31 downto 0);
			i_A: in std_logic_vector(31 downto 0);
			i_And: in std_logic_vector(31 downto 0);
			i_Or: in std_logic_vector(31 downto 0);
			i_Xor: in std_logic_vector(31 downto 0);
			i_Not: in std_logic_vector(31 downto 0);
			o_Q: out std_logic_vector(31 downto 0)
);
end component;

component register_ula
	port(
			i_CLK : in std_logic;
			i_DATA : in std_logic_vector(31 downto 0);
			o_DATA : out std_logic_vector(31 downto 0)
	);
end component;

begin

u_soma: add_gate
	port map ( 
	i_A => i_A,
	i_B => i_B,
	o_Q => w_Add
);

u_subtracao: sub_gate
	port map ( 
	i_A => i_A,
	i_B => i_B,
	o_Q => w_Sub
);
u_incrementador: plus_one
	port map ( 
		i_A => i_A,
		o_Q => w_plus_one
);

u_port_and: and_gate
port map ( 
	i_A => i_A,
	i_B => i_B,
	o_Q => w_And
);

u_port_or: or_gate
port map ( 
	i_A => i_A,
	i_B => i_B,
	o_Q => w_Or
);

u_port_xor: xor_gate
port map ( 
	i_A => i_A,
	i_B => i_B,
	o_Q => w_Xor
);

u_port_not: port_not
port map ( 
	i_A => i_A,
	o_Q => w_Not
);

u_mux8_32bit: mux8_32bit
port map ( 
	i_SEL => i_SEL,
	i_Add => w_Add,
	i_Sub => w_Sub,
	i_plus_one => w_plus_one,
	i_a => i_A,
	i_And => w_And,
	i_Or => w_Or,
	i_Xor => w_Xor,
	i_Not => w_Not,
	o_Q => w_mux
);

u_registrador: register_ula
port map ( 
	i_CLK => i_CLK,
	i_DATA => w_mux,
	o_DATA => o_Q
);

process(w_Sub)
begin
    if signed(w_Sub) = 0 then
        o_Zero <= '1';
    else
        o_Zero <= '0';
    end if;
end process;

end arch;