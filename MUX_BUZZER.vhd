library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX_BUZZER IS
	PORT (
	in1     		:   in std_logic;
	in2  		   :   in std_logic;
	s    			:   in std_logic;
	mux_out     :   out std_logic
	);
	end MUX_BUZZER;
	
architecture Behavii OF MUX_BUZZER is
begin
    mux_out <= in1 when s = '0'
      else in2 when s = '1';
end Behavii;