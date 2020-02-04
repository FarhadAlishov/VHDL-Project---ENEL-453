library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity freq_buzz_gen is
   Port    ( 
				 clk							: in std_logic;
				 reset						: in std_logic;
				 freq_clk					: in std_logic;
				 freq_buzz				: out std_logic
           );
end freq_buzz_gen;

architecture Behavioral of freq_buzz_gen is
	constant up: 		std_logic := '1';
	constant down: 	std_logic := '0';
	constant width: 	integer := 4;
	type Statetype is (S0,S1,S2);
	signal CurrentState, NextState:				Statetype;
	signal freq_buzz_wave_i, count_direction:	std_logic;
	signal duty_cycle, counter:					std_logic_vector(width-1 downto 0);
	signal max_count:									std_logic_vector(width-1 downto 0) := (others => '1');
	signal zero_count:								std_logic_vector(width-1 downto 0) := (others => '0');
	
	
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
	generic map (width => 4)
	port map (
		reset			=>	reset,
		clk			=>	clk,
		duty_cycle	=>	duty_cycle,
		pwm_out		=> freq_buzz_wave_i
		);
		
		
		
	count:	process(clk, reset, freq_clk, count_direction)
		begin
			if (reset = '1') then
				counter <= zero_count;
				
			elsif	(rising_edge(clk)) then
				if (freq_clk = '1') then
				
					if (count_direction = up) then
						counter <= counter + '1';
						
					elsif (count_direction = down) then
						counter <= counter - '1';
					
					end if;
				end if;
			end if;
		end process;
		
--		
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
			case CurrentState is
				when S0 =>
					NextState 			<= S1;
					duty_cycle 			<= zero_count;
					count_direction 	<= up;
				when S1 =>
					duty_cycle 			<= max_count;
					count_direction 	<= up;
					if (counter = max_count) then
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
					duty_cycle 			<= zero_count;
					count_direction 	<= up;
			end case;	
		end process;
		
		
	seq:		process(clk, reset)
		begin
			if (reset = '1') then
				CurrentState 	<= S0;
			elsif rising_edge(clk) then
				CurrentState 	<= NextState;
			end if;
		end process;
		
		
		
		freq_buzz <= freq_buzz_wave_i;
		
		
		
end Behavioral;