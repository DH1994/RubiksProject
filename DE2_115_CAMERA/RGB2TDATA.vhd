library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity RGB2TDATA is 

     port (
		  clk50		:	in std_logic;
		  send		:	in std_logic;
        iX_Cont :  in std_logic_vector( 10  downto 0  );
        iY_Cont :  in std_logic_vector( 10  downto 0  );
        iDVAL :  in std_logic;
        iCLK :  in std_logic;
        iRST :  in std_logic;
        iRed :  in std_logic_vector( 11  downto 0  );
        iGreen :  in std_logic_vector( 11  downto 0  );
        iBlue :  in std_logic_vector( 11  downto 0  );
		  oARGB : out std_logic_vector(17 downto 0);
		  UART_TX	:	out std_logic		  
    );
end entity;

architecture rtl of RGB2TDATA is
	 
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
	 
	 signal cube1_red : std_logic_vector(7 downto 0);
	 signal cube1_green : std_logic_vector(7 downto 0);
    signal cube1_blue : std_logic_vector(7 downto 0);
	 signal cube1_valid : std_logic;
	 signal send_data	 : std_logic_vector(8 downto 0);	
	 
	 component RGB2ARGB is	
	 	 generic(xStartPix 	:		Integer := 32;
				yStartPix		:		Integer := 64;
				size				:		Integer := 16
				);	
		 port(
		   
			CLK				: in		std_logic;
			RST				: in 		std_logic;
			Valid				: in 		std_logic;
			X_Const 			: in 		std_logic_vector(10 downto 0);
			y_Const 			: in 		std_logic_vector(10 downto 0);
			RedI				: in		std_logic_vector(11 downto 0);
			GreenI			: in		std_logic_vector(11 downto 0);
			BlueI				: in		std_logic_vector(11 downto 0);
			RedO				: out		std_logic_vector(7 downto 0);
			GreenO			: out		std_logic_vector(7 downto 0);
			BlueO				: out		std_logic_vector(7 downto 0);
			DValid			: out		std_logic
		 );
		 
	 end component RGB2ARGB;
	 
	component uart is
	  generic 
		 (
			g_CLKS_PER_BIT : integer
		 );
	  port 
	   (
			i_Clk				: in  std_logic;
			i_TX_DV			: std_logic;
			i_TX_Byte		: std_logic_vector(8 downto 0);
			o_TX_Serial 	: out std_logic;
			o_TX_Active 	: out std_logic
		);
	end component;
	 
	type RGBtype is array (0 to 26) of std_logic_vector(7 downto 0);
	signal sideRGB : RGBtype;
	signal sendRGB	: RGBtype;
	signal send_key, tx_active, send_signal : std_logic;
	
	signal LineRST, RST_Average : std_logic;
	
    begin 
		RST_Average <= (LineRST or iRST);
		serial : uart
			generic map(434) --9600 baud 50000000/9600=5208 --115200 = 434
			port map
			(
				clk50,
				send_signal,
				send_data,
				UART_TX,
				tx_active
			);
		
		   cube01 : RGB2ARGB 
			generic map(cube_xA+2,
							cube_yA+2,
							cubes_width-4)
			port map(	iCLK,
							RST_Average,
							iDVAL,
							iX_Cont,
							iY_Cont,
							iREd,
							iGreen,
							iBlue,
							sideRGB(0),
							sideRGB(1),
							sideRGB(2),
							cube1_valid
			);
			
		--sideRGB(3) <= "01111111";
		--sideRGB(4) <= "01111000";
		--sideRGB(5) <= "00011111";
		OARGB <= (others => '1');
		
		coordcheck: process(iCLK)
			begin
				if(iRST = '1') then
				
				elsif(rising_edge(iCLK)) then
					if(to_integer(unsigned(iX_Cont)) = 439) then
						LineRST <= '1';
					else	
						LineRST <= '0';
					end if;
				end if;
			end process;
		
		psend: process(CLK50, iRST)
			variable send_key_v	: std_logic;
			variable b_press		: std_logic;
			variable sending		: std_logic;
			variable cnt			: natural;
			variable send_sign	: std_logic;
			variable parity 		: std_logic;
			variable byte : std_logic_vector(7 downto 0);
		begin
		
			if(iRST = '0') then
				send_key_v 	:= '1';
				b_press		:= '0';
			elsif(rising_edge(CLK50)) then				
				if(send = '0') then
					if((send_key_v XOR send) = '1') then
						b_press := '1';
						cnt := 0;
					end if;
				end if;
				send_key_v := send;
				
				if(b_press = '1') then
					if((to_integer(unsigned(iX_Cont)) > 803) or (to_integer(unsigned(iX_Cont)) < 437)) then
							sendRGB <= sideRGB;
							sending := '1';
					end if;
					if(sending = '1') then
						if(cnt < 81) then
							if(tx_active = '0') then
								byte := sendRGB(cnt/3);
								parity := '0'; -- Set to '1' to get odd parity
								for i in byte'range loop
									parity := parity xor byte(i);
								end loop;
								send_data <= parity & byte;
								cnt := cnt + 1;
								send_sign := '1';
							else
								send_sign := '0';
							end if;
						else
							b_press := '0';
							sending := '0';
							send_sign := '0';
						end if;
					end if;
				end if;
				
			end if;
			
			send_signal <= send_sign;
			
		end process;	
   end;