
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;


entity RGB2ARGB is
	 generic(xStartPix 		:		Integer := 32;
				yStartPix		:		Integer := 64;
				size				:		Integer := 16
				);		
    port(
	  	CLK				: in		std_logic;
		RST				: in 		std_logic;
		Valid			: in 		std_logic;
		X_Const 		: in 		std_logic_vector(10 downto 0);
		y_Const 		: in 		std_logic_vector(10 downto 0);
		RedI			: in		std_logic_vector(11 downto 0);
		GreenI			: in		std_logic_vector(11 downto 0);
		BlueI			: in		std_logic_vector(11 downto 0);
		RedO			: out		std_logic_vector(7 downto 0);
		GreenO			: out		std_logic_vector(7 downto 0);
		BlueO			: out		std_logic_vector(7 downto 0);
		DValid			: out		std_logic
    );
end entity RGB2ARGB;

architecture rtl of RGB2ARGB is


begin
	P: Process (CLK, RST)
	variable RTotal, GTotal, BTotal : Integer := 0;
	variable counter : integer := 0;
		begin

		if(RST = '0') then
			RTotal := 0;
			GTotal := 0;
			BTotal := 0;
			counter := 0;
		elsif(rising_edge(clk)) then
			if(Valid = '1') then
				if((to_integer(unsigned(x_Const)) >= xStartPix and to_integer(unsigned(x_Const)) < xStartPix + size) and (to_integer(unsigned(y_Const)) >= yStartPix and to_integer(unsigned(y_const)) < yStartPix + size)) then
					counter := counter + 1;
					RTotal  := RTotal + to_integer(unsigned(RedI));
					GTotal  := GTotal + to_integer(unsigned(GreenI));
					BTotal  := BTotal + to_integer(unsigned(BlueI));
					RedO <= std_logic_vector(to_unsigned(RTotal / counter, RedO'length));
					GreenO <= std_logic_vector(to_unsigned(GTotal / counter, GreenO'length));
					BlueO <= std_logic_vector(to_unsigned(BTotal / counter, BlueO'length));	
				--elsif(y_Const > (yStartPix + size)) then
					--DValid <= '1';
				end if;
			end if;
		end if;
	end process;
end;

