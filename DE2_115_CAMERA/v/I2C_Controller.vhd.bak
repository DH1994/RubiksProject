library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity II2C_Controller is 
     port (
        CLOCK :  in std_logic;
        I2C_DATA :  in std_logic_vector(31  downto 0);
        GO :  in std_logic;
        RESET :  in std_logic;
        W_R :  in std_logic;
        I2C_SDAT :  inout std_logic;
        I2C_SCLK :  out std_logic;
        EEND :  out std_logic;
        ACK :  out std_logic
    );
end entity; 

architecture rtl of II2C_Controller is
 
    signal SDO : std_logic;
    signal SCLK : std_logic;
    signal SD : std_logic_vector( 31  downto 0  );
    signal SD_COUNTER : std_logic_vector( 6  downto 0  );
    signal ACK1 : std_logic;
    
	 begin 
	 
		I2C_SCLK <= SCLK when SCLK = '1' else
						not CLOCK when (to_integer(unsigned(SD_COUNTER)) >= 4) AND (to_integer(unsigned(SD_COUNTER)) <= 39) else '0';

		I2C_SDAT <= 'Z' when SDO='1' else '0'; --Z means pullup			

		ACK <= ACK1;
	 
        PCLK1 : process(CLOCK, RESET)
        begin
            if (RESET = '0')  then 
                SD_COUNTER <= "0111111";
            elsif(rising_edge(CLOCK)) then
                if (GO = '0') then 
                    SD_COUNTER <= (others => '0');
                else 
                    if (to_integer(unsigned(SD_COUNTER)) < 41) then 
                        SD_COUNTER <= ( std_logic_vector(unsigned(SD_COUNTER) + 1));
                    end if;
                end if;
            end if;
			end process;
				
			PCLK2 : process(CLOCK, RESET)
			begin
				if (RESET = '0') then 
                SCLK <= '1';
                SDO <= '1';
                ACK1 <= '0';
                EEND <= '1';
            elsif(rising_edge(CLOCK)) then
                case  (to_integer(unsigned(SD_COUNTER))) is 
                    when 
                        0  => 
                        ACK1 <= '0' ;
                        EEND <= '0' ;
                        SDO <= '1' ;
                        SCLK <= '1' ;
                    when 
                        1  => 
                        SD <= I2C_DATA;
                        SDO <= '0' ;
                    when 
                        2  => 
                        SCLK <= '0' ;
                    when 
                        3  => 
                        SDO <= SD(31);
                    when 
                        4  => 
                        SDO <= SD(30);
                    when 
                        5  => 
                        SDO <= SD(29);
                    when 
                        6  => 
                        SDO <= SD(28);
                    when 
                        7  => 
                        SDO <= SD(27);
                    when 
                        8	=> 
                        SDO <= SD(26);
                    when 
                        9  => 
                        SDO <= SD(25);
                    when 
                        10  => 
                        SDO <= SD(24);
                    when 
                        11  => 
                        SDO <= '1';
                    when 
                        12  => 
                        SDO <= SD(23);
                        ACK1 <= I2C_SDAT;
                    when 
                        13  => 
                        SDO <= SD(22);
                    when 
                        14  => 
                        SDO <= SD(21);
                    when 
                        15  => 
                        SDO <= SD(20);
                    when 
                        16  => 
                        SDO <= SD(19);
                    when 
                        17  => 
                        SDO <= SD(18);
                    when 
                        18  => 
                        SDO <= SD(17);
                    when 
                        19  => 
                        SDO <= SD(16);
                    when 
                        20  => 
                        SDO <= '1';
                    when 
                        21  => 
                        SDO <= SD(15);
                        ACK1 <= I2C_SDAT;
                    when 
                        22  => 
                        SDO <= SD(14);
                    when 
                        23  => 
                        SDO <= SD(13);
                    when 
                        24  => 
                        SDO <= SD(12);
                    when 
                        25  => 
                        SDO <= SD(11);
                    when 
                        26  => 
                        SDO <= SD(10);
                    when 
                        27  => 
                        SDO <= SD(9);
                    when 
                        28  => 
                        SDO <= SD(8);
                    when 
                        29  => 
                        SDO <= '1';
                    when 
                        30  => 
                        SDO <= SD(7);
                        ACK1 <= I2C_SDAT;
                    when 
                        31  => 
                        SDO <= SD(6);
                    when 
                        32  => 
                        SDO <= SD(5);
                    when 
                        33  => 
                        SDO <= SD(4);
                    when 
                        34  => 
                        SDO <= SD(3);
                    when 
                        35  => 
                        SDO <= SD(2);
                    when 
                        36  => 
                        SDO <= SD(1);
                    when 
                        37  => 
                        SDO <= SD(0);
                    when 
                        38  => 
                        SDO <= '1';
                    when 
                        39  => 
                        SDO <= '0';
                        SCLK <= '0';
                        ACK1 <= I2C_SDAT;
                    when 
                        40  => 
                        SCLK <= '1';
                    when 
                        41  => 
                        SDO <= '1';
                        EEND <= '1' ;
						  when others =>
								NULL;
                end case;
            end if;
				
				
        end process;
    end; 
