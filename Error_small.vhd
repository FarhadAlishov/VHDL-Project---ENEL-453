library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Error_small IS
	port(
		distance: 	in std_logic_vector(15 downto 0);
		errorout2: 	out std_logic_vector(15 downto 0)
		);
	end Error_small;
	
architecture Behaviour OF Error_small is
begin
process(distance)
begin
		if (distance > "0000001010000000") then
			errorout2 <= "1010101010101010";
		else 
			errorout2 <= distance;
		end if;	
	 end process;
end Behaviour;