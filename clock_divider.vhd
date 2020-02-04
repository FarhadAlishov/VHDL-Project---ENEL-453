-- This is example code that uses the downcounter module to create the signals 
-- to drive the 7-segment displays for a countdown timer. This code is 
-- provided to you to show an example of how to use the downcounter module, 
-- if it is of use to your project.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           enable   : in  STD_LOGIC;
           sec_dig1 : out STD_LOGIC_VECTOR(3 downto 0); -- seconds digit
           sec_dig2 : out STD_LOGIC_VECTOR(3 downto 0); -- tens of seconds digit
           min_dig1 : out STD_LOGIC_VECTOR(3 downto 0); -- minutes digit
           min_dig2 : out STD_LOGIC_VECTOR(3 downto 0)  -- tens of minutes digit
           );
end clock_divider;

architecture Behavioral of clock_divider is
-- Signals:
signal onehertz, tensseconds, onesminutes, singlesec : STD_LOGIC;
signal singleSeconds, singleMinutes : STD_LOGIC_VECTOR(3 downto 0);
signal tenSeconds, tensMinutes : STD_LOGIC_VECTOR(2 downto 0);

-- Components declarations
component downcounter is
   Generic ( period  : natural := 1000); -- number to count
      PORT (  clk    : in  STD_LOGIC;
              reset  : in  STD_LOGIC;
              enable : in  STD_LOGIC;
              zero   : out STD_LOGIC;
              value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0)
           );
end component;

BEGIN
   
   oneHzClock: downcounter
   generic map(period => 50000)--50000000) -- divide by 50_000_000 to divide 50 MHz down to 1 Hz 
                               -- for simulation, use 50_000, to increase the simulation speed
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => enable, -- if system is enabled, this this counting
               zero   => onehertz, -- this is a 1-clock cycle pulse every second
               value  => open  -- Leave open since we won't display this value
            );
   
   singleSecondsClock: downcounter
   generic map(period => 10)   -- Counts numbers between 0 and 9 -> that's 10 values!
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => onehertz, -- enabled by onehertz once per second, so counts seconds
               zero   => singlesec, -- 1-clock cycle pulse every 10 seconds (to drive 10s of second counting)
               value  => singleSeconds -- binary value of seconds we decode to drive the 7-segment display        
            );                         -- note we are counting down
   
   tensSecondsClock: downcounter
   generic map(period => 6)   -- Counts numbers between 0 and 5 -> that's 6 values!
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => singlesec,   -- enabled to count once every 10 seconds
               zero   => tensseconds, -- 1-clock cycle pulse every 60 seconds (to drive minutes counting)
               value  => tenSeconds -- binary value of tens of seconds which we decode to drive the 7-segment display        
            );                      -- we are counting down
   
   singleMinutesClock: downcounter
   generic map(period => 10)   -- Counts numbers between 0 and 9 -> that's 10 values!
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => tensseconds,
               zero   => onesminutes,
               value  => singleMinutes -- binary value of minutes we decode to drive the 7-segment display        
            );
   
   tensMinutesClock: downcounter
   generic map(period => 6)   -- Counts numbers between 0 and 5 -> that's 6 values!
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => onesminutes,
               zero   => open, -- we dont' need a clock signal from this, so leave open
               value  => tensMinutes -- binary value of tens of minutes we decode to drive the 7-segment display        
            );
   
   -- Connect internal signals to outputs
   sec_dig1 <= singleSeconds;
   sec_dig2 <= '0' & tenSeconds; -- concatenate '0' to make 4 bits total for std_logic_vector
   min_dig1 <= singleMinutes;
   min_dig2 <= '0' & tensMinutes;-- concatenate '0' to make 4 bits total for std_logic_vector
   
END Behavioral;