library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counterr is
	 Generic (width : natural := 9);     
    PORT ( clk    			: in  STD_LOGIC;
			  enable				: in  STD_LOGIC;
           up_en  			: in  STD_LOGIC; 
           down_en			: in  STD_LOGIC;
           output_wave   	: out STD_LOGIC_VECTOR(width-1 downto 0)
         );
end counterr;

architecture Behavioral of counterr is
  signal counter_value : STD_LOGIC_VECTOR(width-1 downto 0);
  
BEGIN
   
   count: process(clk) begin
	counter_value <= (others => '0');
	
	if (enable = '1') then
		--if (rising_edge(clk)) then
			if (up_en = '1') then
				counter_value <= counter_value + "1000000";	--'1'
			elsif (down_en = '1') then
				counter_value <= counter_value - "1000000";	--'1'
			end if;
		--end if;
	end if;
   end process;
   output_wave <= counter_value;
END Behavioral;
