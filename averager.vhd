-- averages 16 samples
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity averager is
generic ( amount : positive := 16 );
	port (
		  clk   : in  std_logic;
		  EN    : in  std_logic;
		  reset : in  std_logic;
		  Din   : in  std_logic_vector(11 downto 0);
		  Q     : out std_logic_vector(11 downto 0));
	end averager;


architecture rtl of averager is
--
--type t_moving_average is array (0 to 2**amount-1) of std_logic_vector(11 downto 0);
--signal p_moving_average : t_moving_average;
--signal r_acc            : signed(12+amount-1 downto 0);  -- average accumulator

signal reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31,reg32 : std_logic_vector(11 downto 0);
signal tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8,tmp9,tmp10,tmp11,tmp12,tmp13,tmp14,tmp15,tmp16,tmp17,tmp18,tmp19,tmp20,tmp21,tmp22,tmp23,tmp24,tmp25,tmp26,tmp27,tmp28,tmp29,tmp30,tmp31 : integer;
signal tmp32 : std_logic_vector(16 downto 0);

begin

shift_reg : process(clk, reset)
	begin
	
--		if(reset = '1') then
--			r_acc              <= (others => '0');
--			p_moving_average   <= (others => (others => '0'));
--			Q		             <= (others => '0');
--		elsif(rising_edge(clk)) then
--			if EN = '1' then
--				p_moving_average   <= unsigned(Din) & p_moving_average (0 to p_moving_average'length-2);
--				r_acc              <= r_acc + unsigned(Din) - p_moving_average (p_moving_average'length-1);
--			end if;
--		Q	<= std_logic_vector(r_acc(12+amount-1 downto amount));  -- divide by 2^G_AVG_LEN_LOG
--			
			
		if(reset = '1') then
			reg1  <= (others => '0');
			reg2  <= (others => '0');
			reg3  <= (others => '0');
			reg4  <= (others => '0');
			reg5  <= (others => '0');
			reg6  <= (others => '0');
			reg7  <= (others => '0');
			reg8  <= (others => '0');
			reg9  <= (others => '0');
			reg10 <= (others => '0');
			reg11 <= (others => '0');
			reg12 <= (others => '0');
			reg13 <= (others => '0');
			reg14 <= (others => '0');
			reg15 <= (others => '0');
			reg16 <= (others => '0');
			reg17 <= (others => '0');
			reg18 <= (others => '0');
			reg19 <= (others => '0');
			reg20 <= (others => '0');
			reg21 <= (others => '0');
			reg22 <= (others => '0');
			reg23 <= (others => '0');
			reg24 <= (others => '0');
			reg25 <= (others => '0');
			reg26 <= (others => '0');
			reg27 <= (others => '0');
			reg28 <= (others => '0');
			reg29 <= (others => '0');
			reg30 <= (others => '0');
			reg31 <= (others => '0');
			reg32 <= (others => '0');
			Q     <= (others => '0');
		elsif rising_edge(clk) then
			if EN = '1' then
				reg1  <= Din;
				reg2  <= reg1;
				reg3  <= reg2;
				reg4  <= reg3;
				reg5  <= reg4;
				reg6  <= reg5;
				reg7  <= reg6;
				reg8  <= reg7;				
				reg9  <= reg8;
				reg10 <= reg9;
				reg11 <= reg10;
				reg12 <= reg11;
				reg13 <= reg12;
				reg14 <= reg13;
				reg15 <= reg14;
				reg16 <= reg15;
				reg17 <= reg16;
				reg18 <= reg17;
				reg19 <= reg18;
				reg20 <= reg19;
				reg21 <= reg20;
				reg22 <= reg21;
				reg23 <= reg22;				
				reg24 <= reg23;
				reg25 <= reg24;
				reg26 <= reg25;
				reg27 <= reg26;
				reg28 <= reg27;
				reg29 <= reg28;
				reg30 <= reg29;
				reg31 <= reg30;
				reg32 <= reg31;				
				Q     <= tmp32(16 downto 5); -- reg1; -- for testing
			end if;
		end if;
	end process shift_reg;

tmp1  <= to_integer(unsigned(reg1))  + to_integer(unsigned(reg2));
tmp2  <= to_integer(unsigned(reg3))  + to_integer(unsigned(reg4));  
tmp3  <= to_integer(unsigned(reg5))  + to_integer(unsigned(reg6));
tmp4  <= to_integer(unsigned(reg7))  + to_integer(unsigned(reg8));
tmp5  <= to_integer(unsigned(reg9))  + to_integer(unsigned(reg10));
tmp6  <= to_integer(unsigned(reg11)) + to_integer(unsigned(reg12));  
tmp7  <= to_integer(unsigned(reg13)) + to_integer(unsigned(reg14));
tmp8  <= to_integer(unsigned(reg15)) + to_integer(unsigned(reg16));
tmp9  <= to_integer(unsigned(reg17)) + to_integer(unsigned(reg18));
tmp10 <= to_integer(unsigned(reg19)) + to_integer(unsigned(reg20));  
tmp11 <= to_integer(unsigned(reg21)) + to_integer(unsigned(reg22));
tmp12 <= to_integer(unsigned(reg23)) + to_integer(unsigned(reg24));
tmp13 <= to_integer(unsigned(reg25)) + to_integer(unsigned(reg26));
tmp14 <= to_integer(unsigned(reg27)) + to_integer(unsigned(reg28));  
tmp15 <= to_integer(unsigned(reg29)) + to_integer(unsigned(reg30));
tmp16 <= to_integer(unsigned(reg31)) + to_integer(unsigned(reg32));


tmp17 <= tmp1 + tmp2;
tmp18 <= tmp3 + tmp4;
tmp19 <= tmp5 + tmp6;
tmp20 <= tmp7 + tmp8;
tmp21 <= tmp9 + tmp10;
tmp22 <= tmp11 + tmp12;
tmp23 <= tmp13 + tmp14;
tmp24 <= tmp15 + tmp16;

tmp25 <= tmp17  + tmp18;
tmp26 <= tmp19 + tmp20;
tmp27 <= tmp21  + tmp22;
tmp28 <= tmp23 + tmp24;

tmp29 <= tmp25 + tmp26;
tmp30 <= tmp27 + tmp28;

tmp31 <= tmp29 + tmp30; 
 
tmp32 <= std_logic_vector(to_unsigned(tmp31, tmp32'length)); 	
	
end rtl;
