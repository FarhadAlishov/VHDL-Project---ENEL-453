library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity amp_counter is
    PORT ( clk    			: in  STD_LOGIC;
			  reset				: in  STD_LOGIC;
			  	 enable				: in  STD_LOGIC;
           button1  			: in  STD_LOGIC; 
           button2				: in  STD_LOGIC;
--			  a_i  				: in  STD_LOGIC; 
--           a_d					: in  STD_LOGIC;
           a_c			   	: out STD_LOGIC_VECTOR(8 downto 0)
         );
end amp_counter;

architecture Behavioral of amp_counter is
  signal fa : natural := 5000;
	 signal max_amp : std_logic_vector(8 downto 0) := (others => '1');
  
BEGIN
   
--	process(a_i, a_d, reset)
--		begin
--			if (reset = '1') then
--				max_amp <= (others => '1');
--			elsif (reset = '0') then
--				if(a_i = '1') then
--					max_amp <= std_logic_vector(to_unsigned(to_integer(unsigned(max_amp)) + 8, 9));
--				elsif(a_d = '1') then
--					max_amp <= std_logic_vector(to_unsigned(to_integer(unsigned(max_amp)) - 8, 9));
--				else
--					max_amp <= max_amp;
--				end if;
--			else
--				max_amp <= max_amp;
--			end if;
--		end process;
--   a_c <= max_amp;

	--  a_c <= fa;

   
END Behavioral;
