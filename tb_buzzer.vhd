library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity tb_buzzer is
end tb_buzzer;

architecture Behavioral of tb_buzzer is
    constant clk_period : time := 10 ns; -- 1/(100 ns) = 10 MHz

Component MUX_BUZZER IS
	PORT (
	in1     		:   in std_logic;
	in2  		   :   in std_logic;
	s    			:   in std_logic;
	mux_out     :   out std_logic
	);
end Component;
	 
	 signal in1, in2, s, mux_out				: std_logic;

begin
		  
	 buzz:	MUX_BUZZER
		port map (
			  in1  		=>	in1,
           in2     => in2,
           s      => s,
			  mux_out => mux_out
        );

	counter1 : process
   begin
       in1 <= '0';
       wait for clk_period*70;
       in1 <= '1';
		 wait for clk_period*70;
   end process; 
	
	counter2: process
   begin
       in2 <= '0';
       wait for clk_period*30;
       in2 <= '1';
		 wait for clk_period*30;
   end process; 
	
	
	switching : process
   begin
       s <= '0';
       wait for clk_period*160;
       s <= '1';
		 wait for clk_period*160;
	end process;
	    
		 
end Behavioral;
