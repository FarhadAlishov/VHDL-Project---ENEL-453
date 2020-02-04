--------------------------------------------------------------------------------
--   Version History
--
--   Original code by:
--   Version 1.0 3/26/2012 Scott Larson
--   From: https://eewiki.net/pages/viewpage.action?pageId=4980758#DebounceLogicCircuit(withVHDLexample)-ExampleVHDLCode
--   Accessed October 14, 2017
--   
--   Modified for ENEL 453
--   Version 1.1 10/14/2017 Denis Onen
--   Changes: - added reset signal
--            - modified and added comments
--
--   Usage:
--   This circuit debounces an input from a mechanical switch. The bounce time must be known in advance,
--   or an estimate must be made. The relationship determining the size of the counter is:
--   bouncing_period = (2^N + 2) / clock_frequency, where
--   bouncing_period is how long the switch will bounce in seconds
--   clock_frequency is the system's clock frequency in Hz
--   (2^N + 2) is the how long to count (using an N-bit counter) to go past the bouncing period
--   Alternatively,
--   number_counts = bouncing_period * clock_frequency
--   
--   Example:
--   If the mechanical switch will bounce for 10 ms, and the system's clock frequency is 100 MHz, 
--   then we need to count:
--   (0.01 s) * 100 MHz) = 1,000,000 clock cycles, and a 20-bit counter will satisfy the requirement
--   because 2^20 = 1,048,576 exceeds 1,000,000.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY debounce1 IS

  PORT(
    s3,pb1,pb2     : IN  STD_LOGIC;  --input clock
    clk						   : IN  STD_LOGIC;  --input signal to be debounced
    reset   					: IN  STD_LOGIC;  --reset
    si3,pbi1,pbi2  : OUT STD_LOGIC   --debounced signal
    );
END debounce1;

ARCHITECTURE logic OF debounce1 IS
	CONSTANT counter_bits: integer := 27;
  SIGNAL t,t1,t2,t3,t4,t5 : STD_LOGIC;                    --sync reset 
  
BEGIN
  
  PROCESS(clk,reset)
  BEGIN
    IF(reset = '1') THEN -- asynchronous, active-high reset
		si3 	<= '0';
		pbi1 	<= '0';
		pbi2 	<= '0';
		t 	<= '0';
		t1 	<= '0';
		t2 	<= '0';
		t3 	<= '0';
		t4 	<= '0';
		t5 	<= '0';
	 ELSIF(rising_edge(clk)) THEN
	  -- t 	<= s;
		t3		<= s3;
		t4 	<= pb1;
		t5 	<= pb2;
		
		si3 	<= t3;
		pbi1 	<= t4;
		pbi2 	<= t5;
    END IF;
  END PROCESS;
END logic;
