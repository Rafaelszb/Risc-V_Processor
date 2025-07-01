library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity data_memory is
port ( i_clk: in std_logic;
		 i_addr   : in std_logic_vector (31 downto 0);
		 i_data : in std_logic_vector (31 downto 0);
		 i_re   : in std_logic;
		 i_we  : in std_logic;
		 o_q : out std_logic_vector (31 downto 0));
end data_memory;

architecture arch_1 of data_memory is

	type RAM is array(0 to 255) of std_logic_vector(31 downto 0);
	
	signal w_Data_Memory : RAM := ((others=> (others=>'0')));
	
begin
	
	process (i_clk) 
	begin
		if(rising_edge(i_clk)) then
			if (i_we = '1') then
				w_Data_Memory((to_integer(unsigned(i_addr(7 downto 0))))) <= i_data;
				
			end if;
			
			if (i_re = '1') then
				o_q <= w_Data_Memory((to_integer(unsigned(i_addr(7 downto 0)))));
				
			end if;
			
		end if;
	end process;
end arch_1;