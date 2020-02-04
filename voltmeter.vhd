library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

 
entity voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  PWM_OUTPUT						  : out STD_LOGIC;
			  buzzer								  : out STD_LOGIC;
			  switch								  : in  STD_LOGIC;
			  switch2							  : in  STD_LOGIC;
			  switch_wave						  : in  STD_LOGIC_VECTOR (1 downto 0);
			  switch_f_a						  : in  STD_LOGIC;
			  switch_buzzer					  : in  STD_LOGIC;
			  button1							  : in  STD_LOGIC;
			  button2							  : in  STD_LOGIC
          );
           
end voltmeter;

architecture Behavioral of voltmeter is

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 		: STD_LOGIC_VECTOR (3  downto 0):= (others=>'0');
Signal ADC_read, rsp_data, q_outputs_1, q_outputs_2 								: STD_LOGIC_VECTOR (11 downto 0);
signal response_valid_out_i1, response_valid_out_i2, response_valid_out_i3 : STD_LOGIC_VECTOR (0  downto 0);
Signal DP_in		: STD_LOGIC_VECTOR (5 downto 0);
Signal voltage		: STD_LOGIC_VECTOR (12 downto 0);
Signal busy			: STD_LOGIC;
Signal bcd			: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp1 	: STD_LOGIC_VECTOR(11 downto 0);
--Signal Node 		: STD_LOGIC_VECTOR(12 downto 0);
Signal Dist 		: STD_LOGIC_VECTOR(12 downto 0);
Signal Dist2 		: STD_LOGIC_VECTOR(12 downto 0);
Signal Mux_O 		: STD_LOGIC_VECTOR(12 downto 0);
Signal Mux_O_2 	: STD_LOGIC_VECTOR(12 downto 0);
Signal errorout 	: STD_LOGIC_VECTOR(15 downto 0);
Signal pointp		: STD_LOGIC_VECTOR (5 downto 0);
Signal errorout2 	: STD_LOGIC_VECTOR(15 downto 0);
Signal errorout1 	: STD_LOGIC_VECTOR(15 downto 0);
Signal pwmout		: STD_LOGIC;
Signal frequency 	: STD_LOGIC_VECTOR(8 downto 0);
Signal amplitude 	: STD_LOGIC_VECTOR(8 downto 0);
Signal pulse		: STD_LOGIC;

Signal f_i, f_d, a_i, a_d			: std_logic;
Signal f_c			: natural;
Signal a_c		 	: STD_LOGIC_VECTOR(8 downto 0);
Signal amp_out	 	: STD_LOGIC;

Signal freq_wa		: STD_LOGIC;
Signal amp_wa	 	: STD_LOGIC;
Signal freq_clk	: STD_LOGIC;
Signal rectinput	: STD_LOGIC_VECTOR(8 downto 0);
Signal pulse2		: STD_LOGIC;
Signal F_MAX		: INTEGER;



Signal si,si1,si2,si3,pbi1,pbi2			: std_logic;



Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
END Component;

Component ADC_Conversion is
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
END Component;

Component binary_bcd is
	Port (
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;


Component registers is
   generic(bits : integer);
   port
     ( 
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(bits-1 downto 0);
      q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;

Component averager is
  port(
    clk, reset : in std_logic;
    Din : in  std_logic_vector(11 downto 0);
    EN  : in  std_logic; -- response_valid_out
    Q   : out std_logic_vector(11 downto 0)
    );
  end Component;
  
Component MUX2TO1 is
	Port(
     in1  		: IN  STD_LOGIC_VECTOR(12 DOWNTO 0);                     
     in2		   : IN  STD_LOGIC_VECTOR(12 DOWNTO 0); 
     s    		: IN  STD_LOGIC;
     mux_out   : OUT STD_LOGIC_VECTOR(12 DOWNTO 0)   
	  );           
END Component;

Component voltage2distance is
	Port(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0)
		);  
END Component;

Component voltage2distance_small is
	Port(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance_small :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0)
		);  
END Component;

Component Error is
	port(
		distance			: 	in std_logic_vector(15 downto 0);
		errorout1		: 	out std_logic_vector(15 downto 0)
	
		);
END Component;

Component Error_small is
	port(
		distance			: 	in std_logic_vector(15 downto 0);
		errorout2		: 	out std_logic_vector(15 downto 0)
		);
END Component;

Component MUX2TO1_Error is
	Port(
     in1  		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);                     
     in2		   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); 
     s    		: IN  STD_LOGIC;
     mux2_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   
	  );           
END Component;


--Component clock_divider is
--    	 ( clk      : in  STD_LOGIC;
--           reset    : in  STD_LOGIC;
--           enable   : in  STD_LOGIC;
--           sec_dig1 : out STD_LOGIC_VECTOR(3 downto 0); -- seconds digit
--           sec_dig2 : out STD_LOGIC_VECTOR(3 downto 0); -- tens of seconds digit
--           min_dig1 : out STD_LOGIC_VECTOR(3 downto 0); -- minutes digit
--           min_dig2 : out STD_LOGIC_VECTOR(3 downto 0)  -- tens of minutes digit
--           );
--END Component;
--

Component downcounter is
 --Generic ( period : natural := 1000); -- number to count       
	 Port ( clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
           enable : in  STD_LOGIC; -- active-high enable
			  f_c		: in  natural;
           zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
      --     value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
END Component;

Component freq_counter is
    PORT ( clk    			: in  STD_LOGIC;
			  reset				: in  STD_LOGIC;
			  enable				: in  STD_LOGIC;
--           button1  			: in  STD_LOGIC; 
--           button2			: in  STD_LOGIC;
--			  f_i  				: in  STD_LOGIC; 
--           f_d					: in  STD_LOGIC;
           f_c			   	: out natural
         );
END Component;

Component amp_counter is
    PORT ( clk    			: in  STD_LOGIC;
			  reset				: in  STD_LOGIC;
			  enable				: in  STD_LOGIC;
           button1  			: in  STD_LOGIC; 
           button2			: in  STD_LOGIC;
--			  a_i  				: in  STD_LOGIC; 
--           a_d					: in  STD_LOGIC;
           a_c			   	: out STD_LOGIC_VECTOR(8 downto 0)
         );
END Component;

Component inc_dec_mux IS
	PORT (
	f_button		:   in std_logic;
	a_button    :   in std_logic;
	s    			:   in std_logic;
	f_i		   :   out std_logic;
	f_d		   :   out std_logic;
	a_i		   :   out std_logic;
	a_d		   :   out std_logic
	);
END Component;

Component wave_gen is
   Port    ( 
				 clk							: in std_logic;
				 clk_1kHz_pulse			: in std_logic;
				 buttontop					: in std_logic;
				 buttonbottom				: in std_logic;
				 freqoramp					: in std_logic;
				 reset						: in std_logic;
             wave_switch				: in STD_LOGIC_VECTOR(1 downto 0);
				 PWM_OUT						: out std_logic;
--				 freq_input					: in STD_LOGIC_VECTOR(8 downto 0);
				 rect_input					: in STD_LOGIC_VECTOR(8 downto 0)
           );
END Component;


Component counterr is
	 Generic (width : natural := 9);     
    PORT ( clk    			: in  STD_LOGIC;
			  enable				: in  STD_LOGIC;
           up_en  			: in  STD_LOGIC; 
           down_en			: in  STD_LOGIC;
           output_wave   	: out STD_LOGIC_VECTOR(width-1 downto 0)
         );
END Component;

Component counter2 is
	 Generic (width : natural := 9);     
    PORT ( clk    			: in  STD_LOGIC;
			  enable				: in  STD_LOGIC;
           up_en  			: in  STD_LOGIC; 
           down_en			: in  STD_LOGIC;
           output_wave   	: out STD_LOGIC_VECTOR(width-1 downto 0)
         );
END Component;

Component amp_buzzer is
   Port    ( 
				 clk							: in std_logic;
				 clk_1kHz_pulse			: in std_logic;
				 reset						: in std_logic;
             amp_buzz					: in STD_LOGIC_VECTOR(12 downto 0);
				 amp_wave					: out std_logic
           );
end Component;




Component freq_buzz_gen is
   Port    ( 
				 clk							: in std_logic;
				 reset						: in std_logic;
				 freq_clk					: in std_logic;
				 freq_buzz					: out std_logic
           );
end Component;


Component clk_divider_buzz is
    PORT ( clk    		: in  STD_LOGIC; -- clock to be divided
           reset  		: in  STD_LOGIC; -- active-high reset
           enable 		: in  STD_LOGIC; -- active-high enable
			  dis_freq		: in  STD_LOGIC_VECTOR(12 downto 0);
           clock_out   	: out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
     --      value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
end Component;


Component MUX_BUZZER IS
	PORT (
	in1     		:   in std_logic;
	in2  		   :   in std_logic;
	s    			:   in std_logic;
	mux_out     :   out std_logic
	);
end Component;

Component debounce1 IS

  PORT(
    s3,pb1,pb2     : IN  STD_LOGIC;  --input clock
    clk						   : IN  STD_LOGIC;  --input signal to be debounced
    reset   					: IN  STD_LOGIC;  --reset
    si3,pbi1,pbi2  : OUT STD_LOGIC   --debounced signal
    );
END Component;

Component logic IS

  PORT(
    clk						   : IN  STD_LOGIC;  
    reset   					: IN  STD_LOGIC;  --reset
    si3,pbi1,pbi2  : IN 	STD_LOGIC;
	 sqr_amp   					: OUT  STD_LOGIC_VECTOR(8 downto 0);
	 max_count   				: OUT  INTEGER
    );
END Component;

Component clk_transformer is
    PORT ( clk    	: in  STD_LOGIC; -- clock to be divided
           reset  	: in  STD_LOGIC; -- active-high reset
           max_count : in  integer; -- active-high enable
           clk_x   	: out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
     --      value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
END Component;



begin
   Num_Hex0 <= errorout(3  downto  0); 
   Num_Hex1 <= errorout(7  downto  4);
   Num_Hex2 <= errorout(11 downto  8);
   Num_Hex3 <= errorout(15 downto 12);
   Num_Hex4 <= "1111";  -- blank this display
   Num_Hex5 <= "1111";  -- blank this display   
--	if switch='0' then
--   DP_in    <= "001000";-- position of the decimal point in the display
--   else 
--	DP_in    <= "000100";
--     end if            
DP_in    <= "000100"; 


ave :    averager
         port map(
                  clk       => clk,
                  reset     => reset,
                  Din       => q_outputs_2,
                  EN        => response_valid_out_i3(0),
                  Q         => Q_temp1
                  );
   
sync1 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => ADC_read,
                 q_outputs => q_outputs_1
                );

sync2 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => q_outputs_1,
                 q_outputs => q_outputs_2
                );
                
sync3 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i1,
                 q_outputs => response_valid_out_i2
                );

sync4 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i2,
                 q_outputs => response_valid_out_i3
                );             

process(switch)
begin
    if (switch = '0') then
		 pointp <= ('0','0', '1', '0', '0', '0');
	 else
		 pointp <= ('0','0', '0', '1', '0', '0');			
	 end if;
end process;

                
SevenSegment_ins: SevenSegment  
						PORT	MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in    => pointp
									 );
                                     
ADC_Conversion_ins:  ADC_Conversion  	 Port MAP(      
                                     MAX10_CLK1_50       => clk,
                                     response_valid_out  => response_valid_out_i1(0),
                                     ADC_out             => ADC_read);
 
LEDR(9 downto 0) <= Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
voltage <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers

binary_bcd_ins: binary_bcd                               
		PORT MAP(
      clk      => 	clk,                          
      reset    => 	reset,                                 
      ena      => 	'1',                           
      binary   => 	Mux_O,    
      busy     => 	busy,                         
      bcd      => 	bcd         
      );

MUX2TO1_ins: MUX2TO1
      port map (
		in1 		=>		voltage,
		in2 		=> 	Mux_O_2,
		s 			=> 	switch,
		mux_out  => 	Mux_O
		);			
		
voltage2distance_ins: voltage2distance 
		port map(
      clk       =>   clk,          
      reset     =>   reset,    
      voltage   =>   voltage,
      distance  =>   Dist
		);
		
voltage2distance_2_ins: voltage2distance_small 
		port map(
      clk       =>   clk,          
      reset     =>   reset,    
      voltage   =>   voltage,
      distance_small  =>   Dist2
		);
		
Error_ins: Error
		port map(
		distance   =>	bcd,
		errorout1  =>	errorout1
		);

Error2_ins: Error_small
		port map(
		distance   =>	bcd,
		errorout2  =>	errorout2
		);
		
MUX2TO1_2_ins: MUX2TO1
      port map (
		in1 		=>		Dist,
		in2 		=> 	Dist2,
		s 			=> 	switch2,
		mux_out  => 	Mux_O_2
		);			
		
MUX2TO1_Error_ins: MUX2TO1_Error
      port map (
		in1 		=>		errorout1,
		in2 		=> 	errorout2,
		s 			=> 	switch2,
		mux2_out  => 	errorout
		);			
		
down: downcounter      
		port map (  clk		=>		clk,
						reset		=>		reset,
						enable	=>		'1',
						zero		=>		pulse,
						f_c		=>		f_c
         );
			
Freq: freq_counter      
		port map (  clk		=>		clk,
						reset		=>		reset,
						enable	=>		'1',
--						button1	=>		button1,
--						button2	=> 	button2,
--						f_i		=>		f_i,
--						f_d		=>		f_d,
						f_c		=>		f_c
         );
			
--Amp: amp_counter      
--		port map (  clk		=>		clk,
--						reset		=>		reset,
--						enable	=>		'1',
--						button1	=>		button1,
--						button2	=> 	button2,
----						a_i		=>		a_i,
----						a_d		=>		a_d,
--						a_c		=>		a_c
--         );
			

wavegen: wave_gen
		port map (  clk					=>		clk,
						clk_1kHz_pulse		=>		pulse2,
						buttontop			=>		button1,
						buttonbottom		=>		button2,
						freqoramp			=>		switch_f_a,
						reset					=>		reset,
						wave_switch			=>		switch_wave,
						PWM_OUT				=>		PWM_OUTPUT,
--						freq_input			=>		frequency,
						rect_input			=>		rectinput
           );
			  

amp_buz: amp_buzzer
   port map  ( 
				 clk							=>		clk,
				 clk_1kHz_pulse			=>		pulse,
				 reset						=>		reset,
             amp_buzz					=>		Dist,
				 amp_wave					=>		amp_wa
           );
			  
			  
freq_buzz: freq_buzz_gen
      port map (
		clk 					=>		clk,
		reset 				=> 	reset,
		freq_clk				=> 	freq_clk,
		freq_buzz			=> 	freq_wa
		);		
		
		
MUX_BUZ: MUX_BUZZER
      port map (
		in1 		=>		freq_wa,
		in2 		=> 	amp_wa,
		s 			=> 	switch_buzzer,
		mux_out  => 	buzzer
		);		
		
clk_div: clk_divider_buzz
      port map (
		clk 			=>		clk,
		reset 		=> 	reset,
		enable 		=> 	'1',
		dis_freq  	=> 	Dist,
		clock_out 	=>		freq_clk
		);		
		
deb: debounce1 

  PORT MAP(

	 s3	=>		switch_f_a,
	 pb1	=>		button1,
	 pb2 	=>		button2,
    clk	=>		clk,
    reset  => 	reset,			

	 si3	=>		si3,
	 pbi1	=>		pbi1,
	 pbi2 =>		pbi2
    );

log: logic 

  PORT MAP(
    clk		=>		clk,	   
    reset   =>		reset,
--    si1		=>		open,
--	 si2		=>		open,
	 si3		=>		si3,
	 pbi1		=>		pbi1,
	 pbi2  	=>		pbi2,
	 sqr_amp =>		rectinput,	
	 max_count	=>	F_MAX
    );

trans: clk_transformer 
    PORT MAP( 	clk    		=>		clk,
					reset  		=>		reset,
					max_count 	=>		F_MAX,
					clk_x   		=>		pulse2

         );



--freqcounter: counterr
--     	port map ( 	clk    			=>		clk,
--						enable			=>		switch_f_a,
--						up_en  			=>		button1,
--						down_en			=>		button2,
--						output_wave   	=>		frequency
--         );
--
--			
--ampcounter: counter2     
--    	port map ( 	clk    			=>		clk,
--						enable			=>		switch_f_a,
--						up_en  			=>		button1,
--						down_en			=>		button2,
--						output_wave   	=>		amplitude
--         );
			
			
--PWM_DAC_Waves: PWM_DAC
--   port map( reset      => reset,
--             clk        => clk,
--             duty_cycle =>
--             pwm_out    =>
--           );
--			  
--PWM_DAC_Buzzer: PWM_DAC
--   port map( reset      => reset,
--             clk        => clk,
--             duty_cycle =>
--             pwm_out    =>
--           );
--END Component;

end Behavioral;