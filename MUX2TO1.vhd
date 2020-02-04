library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX2TO1 IS
	PORT (
	in1     		:   in std_logic_vector(12 downto 0);
	in2  		   :   in std_logic_vector(12 downto 0);
	s    			:   in std_logic;
	mux_out     :   out std_logic_vector(12 downto 0)
	);
	end MUX2TO1;
	
architecture Behavii OF MUX2TO1 is
begin
    mux_out <= in1 when s = '0'
      else in2 when s = '1';
end Behavii;