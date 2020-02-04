library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity clk_transformer is
    PORT ( clk    	: in  STD_LOGIC; -- clock to be divided
           reset  	: in  STD_LOGIC; -- active-high reset
           max_count : in  integer; -- active-high enable
           clk_x   	: out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
     --      value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
end clk_transformer;

architecture Behavioral of clk_transformer is
  constant counter_bits		: integer := 27;
  signal counter				: std_logic_vector ((counter_bits-1) downto 0);
  
BEGIN
   
process(clk, reset) begin
       if (reset = '1') then 
          counter <= (others => '0');
       elsif (rising_edge(clk)) then 
          if (counter < max_count) then
            counter <= counter + 1;
          else 
            counter <= (others => '0');
          end if;
       end if;
   end process;
   
process(counter, reset) begin
      if (counter > 0 and counter < 6) then
			clk_x <= '1';
		else
			clk_x <= '0';
		end if;
	end process;
   
END Behavioral;
