library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity wave_gen is
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
end wave_gen;

architecture Behavioral of wave_gen is
	constant up: 		integer := 1;
	constant down: 	integer := 0;
	constant saw:		integer := 2;
	constant width: 	integer := 9;
	type Statetype is (S0,S1,S2);
	signal CurrentState, NextState:				Statetype;
	signal pwm_out_i:									std_logic;
	signal count_direction: 						integer;
	signal duty_cycle, counter, maxcounter:	std_logic_vector(width-1 downto 0);
	signal max_count:									std_logic_vector(width-1 downto 0) := (others => '1');
	signal amp_max:									std_logic_vector(width-1 downto 0) := (others => '1');
	signal maxAmplitude:								std_logic_vector(width-1 downto 0) := (others => '1');
	signal minAmplitude:								std_logic_vector(width-1 downto 0) := (others => '0');
	signal zero_count:								std_logic_vector(width-1 downto 0) := (others => '0');
	signal temp:										std_logic;

	
Component PWM_DAC is
   Generic ( width : integer := 9 );
   Port    ( reset      : in STD_LOGIC;
             clk        : in STD_LOGIC;
             duty_cycle : in STD_LOGIC_VECTOR (width-1 downto 0);
             pwm_out    : out STD_LOGIC
           );
end Component;	
	
begin
	
	pwm: PWM_DAC
	generic map (width => 9)
	port map (
		reset			=>	reset,
		clk			=>	clk,
		duty_cycle	=>	duty_cycle,
		pwm_out		=> pwm_out_i
		);
		
		
		
	count:	process(clk, reset, clk_1kHz_pulse)
		begin
			if (reset = '1') then
				counter <= (others => '0');
				
			elsif	(rising_edge(clk)) then
				if (clk_1kHz_pulse = '1' and temp = '0') then
				
					if (count_direction = up) then
						counter <= counter + '1';
						
					elsif (count_direction = down) then
						counter <= counter - '1';
						
					elsif (count_direction = saw) then
						counter <= zero_count;
						
					end if;
				end if;
				temp <= clk_1kHz_pulse;
			end if;
		end process;
				
--	modul:	process(clk, buttontop, buttonbottom)
--		begin
--			if (freqoramp = '0') then
--				if (rising_edge(clk)) then
--					if (buttontop = '1') then
--						if (amp_max >= maxAmplitude - "0100000") then
--							 amp_max <= maxAmplitude;
--						else
--							 amp_max <= amp_max + "0100000";
--						end if;
--					elsif (buttonbottom = '1') then
--						if (amp_max - "0100000" <= minAmplitude) then
--							 amp_max <= minAmplitude;
--						else
--							 amp_max <= amp_max - "0100000";
--						end if;
--					end if;
--				end if;
--		elsif (freqoramp = '1') then
--				if (rising_edge(clk)) then
--					if (buttontop = '1') then
--						if (max_count >= maxAmplitude - "0100000") then
--							 max_count <= maxAmplitude;
--						else
--							 max_count <= max_count + "0100000";
--						end if;
--					elsif (buttonbottom = '1') then
--						if (max_count - "0100000" <= minAmplitude) then
--							 max_count <= minAmplitude;
--						else
--							 max_count <= max_count - "0100000";
--						end if;
--				end if;
--				end if;
--		end if;
--		end process;	


   comb:		process(CurrentState, counter)
		begin
			if (wave_switch = "00") then					-- SAW TOOTH
			case CurrentState is
				when S0 =>
					NextState 			<= S1;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
				when S1 =>
					duty_cycle 			<= counter;
					count_direction 	<= up;
					if (counter = maxAmplitude) then
						NextState 		<= S2;
					else
						NextState 		<= S1;
					end if;
				when S2 =>
					duty_cycle 			<= zero_count;
					count_direction 	<= saw;
					if (counter = zero_count) then
						NextState 		<= S1;
					else
						NextState 		<= S2;
					end if;
				when others =>
					NextState 			<= S0;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
			end case;	
			elsif (wave_switch = "01") then				-- TRIANGLE
			case CurrentState is
				when S0 =>
					NextState 			<= S1;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
				when S1 =>
					duty_cycle 			<= counter;
					count_direction 	<= up;
					if (counter = maxAmplitude) then
						NextState 		<= S2;
					else
						NextState 		<= S1;
					end if;
				when S2 =>
					duty_cycle 			<= counter;
					count_direction 	<= down;
					if (counter = zero_count) then
						NextState 		<= S1;
					else
						NextState 		<= S2;
					end if;
				when others =>
					NextState 			<= S0;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
			end case;		
			elsif (wave_switch = "10") then				-- RECTANGLE
			case CurrentState is
				when S0 =>
					NextState 			<= S1;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
				when S1 =>
					duty_cycle 			<= rect_input;
					count_direction 	<= up;
					if (counter = maxAmplitude) then
						NextState 		<= S2;
					else
						NextState 		<= S1;
					end if;
				when S2 =>
					duty_cycle 			<= zero_count;
					count_direction 	<= down;
					if (counter = zero_count) then
						NextState 		<= S1;
					else
						NextState 		<= S2;
					end if;
				when others =>
					NextState 			<= S0;
					duty_cycle 			<= (others => '0');
					count_direction 	<= up;
			end case;

--			if (counter < maxAmplitude) then
--				duty_cycle <= rect_input;
--			else
--				duty_cycle <= (others=>'0');
--				end if;
			end if;
		end process;
		
		
		
		
	seq:		process(clk, reset)
		begin
			if (reset = '1') then
				CurrentState 	<= S0;
			elsif rising_edge(clk) then
				CurrentState 	<= NextState;
			end if;
		end process;
		
		
		
		PWM_OUT <= pwm_out_i;
		
		
		
end Behavioral;