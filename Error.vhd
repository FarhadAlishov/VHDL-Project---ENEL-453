library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Error IS
	port(
		distance: 	in std_logic_vector(15 downto 0);
		errorout1: 	out std_logic_vector(15 downto 0)
		);
	end Error;
	
architecture Behaviour OF Error is
begin
process(distance)
begin
		if (distance > "0011001100000000") then
			errorout1 <= "1010101010101010";
		else 
			errorout1 <= distance;
		end if;	
	 end process;
end Behaviour;