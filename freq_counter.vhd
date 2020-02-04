library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity freq_counter is
    PORT ( clk    			: in  STD_LOGIC;
			  reset				: in  STD_LOGIC;
			  	 enable				: in  STD_LOGIC;
--           button1  			: in  STD_LOGIC; 
--           button2				: in  STD_LOGIC;
--			  f_i  				: in  STD_LOGIC; 
--           f_d					: in  STD_LOGIC;
           f_c			   	: out natural
         );
end freq_counter;

architecture Behavioral of freq_counter is
	 signal fa : natural := 5000;
	 signal max_freq : std_logic_vector(12 downto 0) := "0001111101000";

  
BEGIN
   
--	process(f_i, f_d, reset)
--		begin
--			if (reset = '1') then
--				max_freq <= "0001111101000";
--			elsif (reset = '0') then
--				if(f_i = '1') then
--					max_freq <= std_logic_vector(to_unsigned(to_integer(unsigned(max_freq)) + 100, 13));
--				elsif(f_d = '1') then
--					max_freq <= std_logic_vector(to_unsigned(to_integer(unsigned(max_freq)) - 100, 13));
--				else
--					max_freq <= max_freq;
--				end if;
--			else
--				max_freq <= max_freq;
--			end if;
--		end process;
--   f_c <= to_integer(unsigned(max_freq));
	
	  f_c <= fa;
   
END Behavioral;
