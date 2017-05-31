
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity RRAW2RGB is 

     port (
        iX_Cont :  in std_logic_vector( 10  downto 0  );
        iY_Cont :  in std_logic_vector( 10  downto 0  );
        iDATA :  in std_logic_vector( 11  downto 0  );
        iDVAL :  in std_logic;
        iCLK :  in std_logic;
        iRST :  in std_logic;
        oRed :  out std_logic_vector( 11  downto 0  );
        oGreen :  out std_logic_vector( 11  downto 0  );
        oBlue :  out std_logic_vector( 11  downto 0  );
        oDVAL :  out std_logic
    );
end entity; 


architecture rtl of RRAW2RGB is

	signal mDATA_0 : std_logic_vector( 11  downto 0  );
	signal mDATA_1 : std_logic_vector( 11  downto 0  );
	signal mDATAd_0 : std_logic_vector( 11  downto 0  );
	signal mDATAd_1 : std_logic_vector( 11  downto 0  );
	signal mCCD_R : std_logic_vector( 11  downto 0  );
	signal mCCD_G : std_logic_vector( 12  downto 0  );
	signal mCCD_B : std_logic_vector( 11  downto 0  );
	signal iXY_Cont : std_logic_vector( 0 to 1); 
	signal mDVAL : std_logic;
   
	component Line_Buffer1 is 
         port (
            clken :  in std_logic;
            clock :  in std_logic;
            shiftin :  in std_logic_vector( 11  downto 0  );
            taps0x :  inout std_logic_vector( 11  downto 0  );
            taps1x :  inout std_logic_vector( 11  downto 0  )
        );
    end component;
	 
	 constant cube_x			: INTEGER := 441;
	 constant cube_y			: INTEGER := 500;
	 constant cube_width		: INTEGER := 360;
	 constant cube_xA			: INTEGER := cube_x + 30;
	 constant cube_yA			: INTEGER := cube_y + 30;
	 constant cube_xB			: INTEGER := cube_x + 150;
	 constant cube_yB			: INTEGER := cube_y + 150;
	 constant cube_xC			: INTEGER := cube_x + 270;
	 constant cube_yC			: INTEGER := cube_y + 270;
	 constant cubes_width 	: INTEGER := 60;
	 --constant 
	 
    begin 
	 
        oRed <= mCCD_R(11  downto 0 );
        oGreen <= mCCD_G(12  downto 1 );
        oBlue <= mCCD_B(11  downto 0 );
        oDVAL <= mDVAL;
		  
		iXY_Cont <= (iX_Cont(0) & iY_Cont(0));
		
        u0 : Line_Buffer1
            port map 
				(
                clken => iDVAL,
                clock => iCLK,
                shiftin => iDATA,
                taps0x => mDATA_1,
                taps1x => mDATA_0
            );
					 
		process(iCLK,iRST)
			
		variable draw	:	std_logic;
		begin

			if ( iRST = '0' ) then 
                mCCD_R <= (others => '0');
                mCCD_G <= (others => '0');
                mCCD_B <= (others => '0');
                mDATAd_0 <= (others => '0');
                mDATAd_1 <= (others => '0');
                mDVAL <= '0';
					 draw := '0';
					 
			elsif(rising_edge(iCLK)) then
				draw := '0';
				
				mDATAd_0 <= mDATA_0;
				mDATAd_1 <= mDATA_1;
				
				if((iY_Cont(0) or iX_Cont(0)) = '1') then
					mDVAL <= '0';
				else
					mDVAL <= iDVAL;
				end if;
				
				if(to_integer(unsigned(iY_Cont)) = cube_y or to_integer(unsigned(iY_Cont)) = (cube_y + cube_width)) then
					if((to_integer(unsigned(iX_Cont)) > cube_x) and (to_integer(unsigned(iX_Cont)) < (cube_x + cube_width))) then
						mCCD_R <= (others => '1');
						mCCD_G(12 downto 1) <= (others => '0');
						mCCD_B <= (others => '0');
						draw := '1';
					end if;
				end if;
				
				if(to_integer(unsigned(iX_Cont)) = cube_x or to_integer(unsigned(iX_Cont)) = (cube_x + cube_width)) then
					if((to_integer(unsigned(iY_Cont)) > cube_y) and (to_integer(unsigned(iY_Cont)) < (cube_y + cube_width))) then
						mCCD_R <= (others => '1');
						mCCD_G(12 downto 1) <= (others => '0');
						mCCD_B <= (others => '0');
						draw := '1';
					end if;
				end if;
				
				if((to_integer(unsigned(iY_Cont)) = cube_ya) or (to_integer(unsigned(iY_Cont)) = (cube_ya + cubes_width)) or (to_integer(unsigned(iY_Cont)) = cube_yb) or (to_integer(unsigned(iY_Cont)) = (cube_yb + cubes_width)) or (to_integer(unsigned(iY_Cont)) = cube_yc) or (to_integer(unsigned(iY_Cont)) = (cube_yc + cubes_width))) then
					if(((to_integer(unsigned(iX_Cont)) > cube_xa) and (to_integer(unsigned(iX_Cont)) < (cube_xa + cubes_width))) or ((to_integer(unsigned(iX_Cont)) > cube_xb) and (to_integer(unsigned(iX_Cont)) < (cube_xb + cubes_width))) or ((to_integer(unsigned(iX_Cont)) > cube_xc) and (to_integer(unsigned(iX_Cont)) < (cube_xc + cubes_width)))) then
						mCCD_R <= (others => '0');
						mCCD_G(12 downto 1) <= (others => '0');
						mCCD_B <= (others => '1');
						draw := '1';
					end if;
				end if;
				
				if((to_integer(unsigned(iY_Cont)) = cube_ya) or (to_integer(unsigned(iY_Cont)) = (cube_ya + cubes_width)) or (to_integer(unsigned(iY_Cont)) = cube_yb) or (to_integer(unsigned(iY_Cont)) = (cube_yb + cubes_width)) or (to_integer(unsigned(iY_Cont)) = cube_yc) or (to_integer(unsigned(iY_Cont)) = (cube_yc + cubes_width))) then
					if(((to_integer(unsigned(iX_Cont)) > cube_xa) and (to_integer(unsigned(iX_Cont)) < (cube_xa + cubes_width))) or ((to_integer(unsigned(iX_Cont)) > cube_xb) and (to_integer(unsigned(iX_Cont)) < (cube_xb + cubes_width))) or ((to_integer(unsigned(iX_Cont)) > cube_xc) and (to_integer(unsigned(iX_Cont)) < (cube_xc + cubes_width)))) then
						mCCD_R <= (others => '0');
						mCCD_G(12 downto 1) <= (others => '0');
						mCCD_B <= (others => '1');
						draw := '1';
					end if;
				end if;
				
				if((to_integer(unsigned(iX_Cont)) = cube_xa) or (to_integer(unsigned(iX_Cont)) = (cube_xa + cubes_width)) or (to_integer(unsigned(iX_Cont)) = cube_xb) or (to_integer(unsigned(iX_Cont)) = (cube_xb + cubes_width)) or (to_integer(unsigned(iX_Cont)) = cube_xc) or (to_integer(unsigned(iX_Cont)) = (cube_xc + cubes_width))) then
					if(((to_integer(unsigned(iY_Cont)) > cube_ya) and (to_integer(unsigned(iY_Cont)) < (cube_ya + cubes_width))) or ((to_integer(unsigned(iY_Cont)) > cube_yb) and (to_integer(unsigned(iY_Cont)) < (cube_yb + cubes_width))) or ((to_integer(unsigned(iY_Cont)) > cube_yc) and (to_integer(unsigned(iY_Cont)) < (cube_yc + cubes_width)))) then
						mCCD_R <= (others => '0');
						mCCD_G(12 downto 1) <= (others => '0');
						mCCD_B <= (others => '1');
						draw := '1';
					end if;
				end if;
						
            if(draw = '0') then    
					if (iXY_Cont = "10") then 
						mCCD_R <= mDATAd_1;
						mCCD_G <= std_logic_vector((unsigned('0' & mDATAd_0) + unsigned('0' & mDATA_1)));
						mCCD_B <= mDATA_0;
						
					elsif (iXY_Cont = "11" ) then 
						mCCD_R <= mDATA_1;
						mCCD_G <= std_logic_vector((unsigned('0' & mDATA_0) + unsigned('0' & mDATAd_1)));
						mCCD_B <= mDATAd_0;
						
					elsif (iXY_Cont = "00") then 
						mCCD_R <= mDATAd_0;
						mCCD_G <= std_logic_vector((unsigned('0' & mDATA_0) + unsigned('0' & mDATAd_1)));
						mCCD_B <= mDATA_1;
						
					elsif (iXY_Cont = "01") then 
						mCCD_R <= mDATA_0;
						mCCD_G <= std_logic_vector((unsigned('0' & mDATAd_0) + unsigned('0' & mDATA_1)));
						mCCD_B <= mDATAd_1;	
					end if;
				end if;
			end if;
      end process;
   end; 