library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX2TO1_Error IS
	PORT (
	in1     		:   in std_logic_vector(15 downto 0);
	in2  		   :   in std_logic_vector(15 downto 0);
	s    			:   in std_logic;
	mux2_out     :   out std_logic_vector(15 downto 0)
	);
	end MUX2TO1_Error;
	
architecture Behavii OF MUX2TO1_Error is
begin
    mux2_out <= in1 when s = '0'
      else in2 when s = '1';
end Behavii;