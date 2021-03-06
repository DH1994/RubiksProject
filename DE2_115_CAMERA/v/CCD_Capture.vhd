library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity CCCD_Capture is 
	
	generic 
	(
		COLUMN_WIDTH : INTEGER := 1280
   );
	
	port 
	(
		iDATA :  in std_logic_vector( 11  downto 0  );
		iFVAL :  in std_logic;
		iLVAL :  in std_logic;
		iSTART :  in std_logic;
		iEND :  in std_logic;
		iCLK :  in std_logic;
		iRST :  in std_logic;
		oDATA :  out std_logic_vector( 11  downto 0  );
		oX_Cont :  out std_logic_vector( 15  downto 0  );
		oY_Cont :  out std_logic_vector( 15  downto 0  );
		oFrame_Cont :  out std_logic_vector( 31  downto 0  );
		oDVAL :  out std_logic
	);
	
	end entity; 

architecture rtl of CCCD_Capture is 
 	
	signal Pre_FVAL : std_logic;
	signal mSTART : std_logic;
	signal mCCD_LVAL : std_logic;
	signal mCCD_FVAL : std_logic;
	signal mCCD_DATA : std_logic_vector(11  downto 0);
	signal Frame_Cont : std_logic_vector(31  downto 0);
	signal X_Cont : std_logic_vector(15  downto 0);
	signal Y_Cont : std_logic_vector(15  downto 0);
	signal comb_Pre_iF : std_logic_vector(1 downto 0);

begin
	
	comb_Pre_iF <= (Pre_FVAL & iFVAL);

	oX_Cont <= X_Cont;
	oY_Cont <= Y_Cont;
	oDATA <= mCCD_DATA;
	oDVAL <= ( mCCD_FVAL and mCCD_LVAL );
	oFrame_Cont <= Frame_Cont;

	
	PCLK1 : process(iCLK,iRST)
	
	begin
	
	if(iRST = '0') then
			Pre_FVAL	<=	'0';
			X_Cont	<=	(others => '0');
			Y_Cont	<=	(others => '0');
			MCCD_FVAL	<=	'0';
			MCCD_LVAL	<= '0';
	elsif(rising_edge(iCLK)) then	
		Pre_FVAL	<=	iFVAL;
	
		if(comb_Pre_iF = "01" and mSTART = '1') then
			mCCD_FVAL	<=	'1';
		elsif(comb_Pre_iF = "10") then
			MCCD_FVAL <= '0';
		end if;
		
		mCCD_LVAL	<=	iLVAL;
			
		if((MCCD_FVAL) = '1') then
			if(mCCD_LVAL = '1') then
				if(to_integer(unsigned(X_Cont)) < (COLUMN_WIDTH-1)) then
					X_Cont	<=	std_logic_vector( unsigned(X_Cont) + 1);
				else
					X_Cont <= (others => '0');
					Y_Cont	<=	std_logic_vector( unsigned(y_Cont) + 1);
				end if;
			end if;
		else
			X_Cont	<=	(others => '0');
			Y_Cont	<=	(others => '0');
		end if;
	end if;
end process;
	
PCLK2 : process(iCLK, iRST)
begin
	if(iRST = '0') then
		mSTART	<=	'0';
	elsif(rising_edge(iCLK)) then
		if(iSTART = '1') then
			mSTART	<=	'1';
		end if;
		
		if(iEND = '1') then
			mSTART	<=	'0';
		end if;
	end if;

end process;

PCLK3 : process(iCLK, iRST)
begin
	if(iRST = '0') then
		Frame_Cont <= (others => '0');
	elsif(rising_edge(iCLK)) then
		if(comb_Pre_iF = "01" and mSTART = '1') then
			Frame_Cont <= std_logic_vector( unsigned(Frame_Cont) + 1);
		end if;
	end if;
end process;

PCLK4 : process(iCLK, iRST)
begin
	if(iRST = '0') then
		mCCD_DATA	<=	(others => '0');
	elsif(rising_edge(iCLK)) then
		if (iLVAL = '1') then
			mCCD_DATA	<=	iDATA;
		else
			mCCD_DATA	<=	(others => '0');	
		end if;
	end if;
end process;

end architecture rtl;