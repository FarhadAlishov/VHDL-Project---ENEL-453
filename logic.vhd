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
USE ieee.numeric_std.all;


ENTITY logic IS
  PORT(
    clk						   : IN  STD_LOGIC;  
    reset   					: IN  STD_LOGIC;  --reset
    si3,pbi1,pbi2  : IN 	STD_LOGIC;
	 sqr_amp   					: OUT  STD_LOGIC_VECTOR(8 downto 0);
	 max_count   				: OUT  INTEGER
    );
END logic;

ARCHITECTURE arch OF logic IS
	
	type array_1d is array (0 to 15) of integer;
	constant freq_lut: array_1d := (
  
  (50000),
  (45000),
  (40000),
  (35000),
  (30000),
  (25000),
  (20000),
  (15000),
  (10000),
  (8000),
  (6000),
  (5000),
  (2500),
  (500),
  (100),
  (50)
  
  );
  
 
  
  type array_d is array (0 to 15) of integer;
	constant amp_lut: array_1d := (
  
  (8),
  (10),
  (20),
  (30),
  (50),
  (70),
  (90),
  (100),
  (150),
  (200),
  (250),
  (300),
  (350),
  (400),
  (450),
  (500)
  
  );
  
  signal counter: integer := 0;
  signal t1: std_logic;
  signal t2: std_logic;
  begin
  
  Process (clk, reset, pbi1, pbi2)
  BEGIN
    IF(reset = '1') THEN -- asynchronous, active-high reset
      counter 	<= 0;
		t1 	<= '0';
		t2 	<= '0';
	 ELSIF(rising_edge(clk)) THEN
		if (pbi1 = '1' and t1 = '0') then
			if (counter = 15) then
				counter <= counter;
			else
				counter <= counter + 1;
			end if;
		elsif (pbi2 = '1' and t2 = '0') then
			if (counter = 0) then
				counter <= counter;
			else
				counter <= counter - 1;
			end if;
		end if;
		
		t1 	<= pbi1;
		t2 	<= pbi2;

    END IF;
  END PROCESS;
  
  Process ( si3, counter)
  BEGIN
		--if (si1 = '1' and si2 = '0') then
			if (si3 = '1') then
				max_count <= freq_lut(7);
				sqr_amp	<= std_logic_vector(to_unsigned(amp_lut(counter), sqr_amp'length));
			else
				max_count <= freq_lut(counter);
				sqr_amp	<= std_logic_vector(to_unsigned(amp_lut(15), sqr_amp'length));
			end if;
--		else
--			max_count	<= freq_lut(counter);
--			sqr_amp		<= std_logic_vector(to_unsigned(amp_lut(0), sqr_amp'length));
--		end if;
	
	END PROCESS;
END arch;
