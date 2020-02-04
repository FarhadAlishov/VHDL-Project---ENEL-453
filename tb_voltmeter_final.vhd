library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_voltmeter_final is
end tb_voltmeter_final;

architecture Behavioral of tb_voltmeter_final is
    constant clk_period : time := 10 ns; -- 1/(100 ns) = 10 MHz

Component voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  PWM_OUTPUT						  : out STD_LOGIC;
			  buzzer								  : out STD_LOGIC;
			  switch								  : in  STD_LOGIC;
			  switch2							  : in  STD_LOGIC;
			  switch_wave						  : in  STD_LOGIC_VECTOR (1 downto 0);
			  switch_f_a						  : in  STD_LOGIC;
			  switch_buzzer					  : in  STD_LOGIC;
			  button1							  : in  STD_LOGIC;
			  button2							  : in  STD_LOGIC
          );
           
end Component;
	 
	 signal clk, reset, PWM_OUTPUT, buzzer, switch, switch2, switch_f_a, switch_buzzer, button1, button2	: std_logic;
    signal switch_wave  						: std_logic_vector (1 downto 0);
	 signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 	: std_logic_vector (7 downto 0);
	 signal LEDR                          	: std_logic_vector (9 downto 0);
              

begin
		  
	 volt:	voltmeter
		port map (
			  clk  		=>	clk,
           reset     => reset,
           LEDR      => LEDR,
           HEX0		=>	HEX0,
			  HEX1		=>	HEX1,
			  HEX2		=>	HEX2,
			  HEX3		=>	HEX3,
			  HEX4		=>	HEX4,
			  HEX5 		=>	HEX5,
			  PWM_OUTPUT		=>		PWM_OUTPUT,			 
			  buzzer				=>		buzzer,
			  switch				=>		switch,
			  switch2			=>		switch2,
			  switch_wave		=>		switch_wave,
			  switch_f_a		=>		switch_f_a,
			  switch_buzzer	=>		switch_buzzer,	  
			  button1			=>		button1,
			  button2			=>		button2	  
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
		switch_wave(0) <= '0';
		switch_wave(1) <= '0';
		wait for clk_period*100000;
		switch_wave(0) <= '0';
		switch_wave(1) <= '1';
		wait for clk_period*100000;
		switch_wave(0) <= '1';
		switch_wave(1) <= '0';
		wait for clk_period*200000;
		switch_wave(0) <= '1';
		switch_wave(1) <= '1';
		wait for clk_period*200000;
	end process;
	
	switching_f_a : process
	begin
		switch_f_a <= '0';
		wait for clk_period*10000;
		switch_f_a <= '1';
		wait for clk_period*10000;
	end process;

   buttonprocess : process
	begin
		button1 <= '1';
		button2 <= '0';
		wait for clk_period*1000;
		button1 <= '0';
		button2 <= '1';
		wait for clk_period*1000;
		button1 <= '0';
		button2 <= '0';
		wait for clk_period*1000;
	end process;
	
	switching_f_a_buzzer : process
	begin
		switch_buzzer <= '0';
		wait for clk_period*10000;
		switch_buzzer <= '1';
		wait for clk_period*10000;
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
    
end Behavioral;
