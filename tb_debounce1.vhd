----------------------------------------------------------------------------------
--   Original code by:
--   Version 1.0 10/15/2017 Denis Onen
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce1 is
end tb_debounce1;

architecture Behavioral of tb_debounce1 is

COMPONENT debounce
  GENERIC(
    counter_size  :  INTEGER := 20); --counter size (20 bits gives 10.5ms with 100MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    reset   : IN  STD_LOGIC;  --reset
    result  : OUT STD_LOGIC   --debounced signal
    ); 
END COMPONENT;

-- input signals
signal clk, button, reset : STD_LOGIC;  
-- output signals
signal result : STD_LOGIC;

-- test and status information
type StateType is (Resetting, Bouncing, Stable, Completed, Fail);
signal Test_State : StateType; -- this creates a convenient and readable signal to view on the
                               -- simulation, to know where in the testbench you are in the waveform
signal error : STD_LOGIC := '0'; -- used to flag errors

-- IMPORTANT: this value of counter_size must match the counter_size of the COMPONENT
signal counter_size : INTEGER := 20; 

signal counter_max_value  :  INTEGER := 2**counter_size; -- the ** operator is exponentiation
signal some_delay  :  INTEGER := 3;

   -- Clock period definitions
constant clk_period : time := 10 ns; -- this is a 100 MHz clock
begin
  
  uut : debounce PORT MAP (
    clk    => clk,
    button => button,
    reset  => reset,
    result => result
    );

       -- Clock process definitions
       clk_process : process
       begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
       end process; 
    
       -- Reset process
       reset_proc : process
       begin        
          -- hold reset state for 100 ns.
            reset <= '0';
          wait for 100 ns;    
            reset <= '1';
          wait for 100 ns;
            reset <= '0';            
          wait;
       end process;
       
       -- Stimulus process
       stim_proc : process
       begin        
          -- initial state.
          Test_State <= Resetting;
            button <= '0';  
          wait for 300 ns;
          
          -- test low-to-high transition with bouncing
          Test_State <= Bouncing;
            button <= '1';
          wait for 100 ns;
            button <= '0';
          wait for 100 ns;
            button <= '1';
          wait for 100 ns;
            button <= '0';
          wait for 100 ns;
            Test_State <= Stable;          
            button <= '1';
          wait for (counter_max_value + some_delay)*clk_period; -- allow button signal to stablize 
          
          -- test 1
          if result /= '1' then
            assert false report "First test failed"; -- this puts a message in the TCL window
                                                     -- "Error" in the TCL window is an artifact
                                                     -- when this message is displayed
            error <= '1'; -- flag error
            Test_State <= Fail;
          else
             assert false report "First test passed";
          end if;   
          wait for 100*clk_period;
          
          
          -- test high-to-low transition with bouncing    
          Test_State <= Bouncing;
             button <= '0';
           wait for 100 ns;
             button <= '1';
           wait for 100 ns;
             button <= '0';
           wait for 100 ns;
             button <= '1';
          wait for 100 ns;
             Test_State <= Stable;          
             button <= '0';      
          wait for (counter_max_value + some_delay)*clk_period; -- allow button signal to stablize  
          
             -- test 2
          if result /= '0' then
             assert false report "Second test failed"; -- this puts a message in the TCL window
             error <= '1'; -- flag error
             Test_State <= Fail;
          else
             assert false report "Second test passed";
          end if;   
             wait for 100*clk_period;
             
             Test_State <= Completed;  
             wait for 100 ns;
          
          -- end the simulation 
            -- usage of "severity failure" creates a message in the TCL window starting with "Failure" 
            -- but this is an artifact and does not represent an actual failure. What "severity 
            -- failure" does is halt the simulation at the end of the test bench (after you hit "Run All"),
            -- so you do not need to specify how long to run the simulation.
          if error = '1' then
            assert false report "Simulation ended, test failed" severity failure;
          else
            assert false report "Simulation ended, test passed" severity failure;    
          end if;                      
          -- wait;
       end process;
end Behavioral;
