library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity tb_wavegen is
end tb_wavegen;

architecture Behavioral of tb_wavegen is
    constant clk_period : time := 10 ns; -- 1/(100 ns) = 10 MHz

Component wave_gen is
   Port    ( 
				 clk							: in std_logic;
				 clk_1kHz_pulse			: in std_logic;
				 buttontop					: in std_logic;
				 buttonbottom				: in std_logic;
				 freqoramp					: in std_logic;
				 reset						: in std_logic;
             wave_switch				: in STD_LOGIC_VECTOR(1 downto 0);
				 PWM_OUT						: out std_logic;
--				 freq_input					: in STD_LOGIC_VECTOR(8 downto 0);
				 rect_input					: in STD_LOGIC_VECTOR(8 downto 0)
           );           
end Component;
	 
	 signal clk, reset, PWM_OUT, clk_1kHz_pulse, buttontop, buttonbottom, freqoramp	: std_logic;
    signal wave_switch  						: std_logic_vector (1 downto 0);
	 signal rect_input						 	: std_logic_vector (8 downto 0);
              

begin
		  
	 wave:	wave_gen
		port map (
			  clk  		=>	clk,
           reset     => reset,
           clk_1kHz_pulse      => clk_1kHz_pulse,
           buttontop		=>	buttontop,
			  buttonbottom		=>	buttonbottom,
			  freqoramp		=>	freqoramp,
			  wave_switch		=>	wave_switch,
			  PWM_OUT		=>	PWM_OUT,
			  rect_input 		=>	rect_input  
        );

	clk_process : process
   begin
       clk <= '0';
       wait for clk_period/2;
       clk <= '1';
		 wait for clk_period/2;
   end process; 

   switching_waves : process
	begin
		wave_switch(0) <= '0';
		wave_switch(1) <= '0';
		wait for clk_period*100000;
		wave_switch(0) <= '0';
		wave_switch(1) <= '1';
		wait for clk_period*100000;
		wave_switch(0) <= '1';
		wave_switch(1) <= '0';
		wait for clk_period*200000;
		wave_switch(0) <= '1';
		wave_switch(1) <= '1';
		wait for clk_period*200000;
	end process;
	
	switching_f_a : process
	begin
		freqoramp <= '0';
		wait for clk_period*10000;
		freqoramp <= '1';
		wait for clk_period*10000;
	end process;

	pulsing : process
	begin
		clk_1kHz_pulse <= '0';
		wait for clk_period*100;
		clk_1kHz_pulse <= '1';
		wait for clk_period*100;
	end process;
	
   buttonprocess : process
	begin
		buttontop <= '1';
		buttonbottom <= '0';
		wait for clk_period*1000;
		buttontop <= '0';
		buttonbottom <= '1';
		wait for clk_period*1000;
		buttontop <= '0';
		buttonbottom <= '0';
		wait for clk_period*1000;
	end process;
	
	reset_process: process
	 begin
		  reset<='0';
		  wait for clk_period*5;
		  reset<='1';
		  wait for clk_period*5;
		  reset<='0';
		  wait;
	end process;
	
	inputs : process
	begin
		rect_input <= std_logic_vector(to_unsigned(8, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(10, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(20, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(30, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(50, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(70, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(90, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(100, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(150, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(200, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(250, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(300, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(350, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(400, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(450, rect_input'length));
		wait for clk_period*100;
		rect_input <= std_logic_vector(to_unsigned(500, rect_input'length));
		wait for clk_period*100;
		
	end process;
	    
end Behavioral;
