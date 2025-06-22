library IEEE;
use IEEE.std_logic_1164.all;

entity mux8_32bit is
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
end mux8_32bit;

architecture arch of mux8_32bit is
SIGNAL m1, m2, m3, m4, m5, m6 : std_logic_vector(31 downto 0);

component mux2_32bit
	port ( i_SEL : in std_logic;
	i_A : in std_logic_vector(31 downto 0);
	i_B : in std_logic_vector(31 downto 0);
	o_Q : out std_logic_vector(31 downto 0)
);
end component;

begin
-- Primeira camada do Mux
u0: mux2_32bit
	port map ( i_SEL => i_SEL(0),
	i_A => i_Add,
	i_B => i_Sub,
	o_Q => m1
);

u1: mux2_32bit
	port map ( i_SEL => i_SEL(0),
	i_A => i_plus_one,
	i_B => i_A,
	o_Q => m2
);

u2: mux2_32bit
	port map ( i_SEL => i_SEL(0),
	i_A => i_And,
	i_B => i_Or,
	o_Q => m3
);

u3: mux2_32bit
	port map ( i_SEL => i_SEL(0),
	i_A => i_Xor,
	i_B => i_Not,
	o_Q => m4
);

-- Segunda camada do Mux
u4: mux2_32bit
	port map ( i_SEL => i_SEL(1),
	i_A => m1,
	i_B => m2,
	o_Q => m5
);

u5: mux2_32bit
	port map ( i_SEL => i_SEL(1),
	i_A => m3,
	i_B => m4,
	o_Q => m6
);
-- Terceira camada do Mux
u6: mux2_32bit
	port map ( i_SEL => i_SEL(2),
	i_A => m5,
	i_B => m6,
	o_Q => o_Q
);
end arch;