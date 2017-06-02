----------------------------------------------------------------------------------
-- Company: LMU
-- Engineer: Gunter Wahl
-- 
-- Create Date:    11:15:34 04/12/2017 
-- Design Name: 
-- Module Name:    Mezz_main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1.0 of 05/17/2017
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.UART_package.all;
--use work.SPI_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mezz_main is
    Port ( rxd : in  STD_LOGIC;
           txd : out  STD_LOGIC;
           SCLK : in  STD_LOGIC;
           NCS : in  STD_LOGIC;
           UART_in : in  STD_LOGIC_VECTOR (7 downto 0);
           UART_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  rst : in STD_LOGIC;
			  we : in STD_LOGIC;
			  re : in STD_LOGIC; 
			  -- data: out STD_LOGIC_VECTOR (6 downto 0);
			  err, data_valid: out STD_LOGIC);
end Mezz_main;

architecture Behavioral of Mezz_main is

begin
	process(NCS, re, we, rxd, UART_in, SCLK, rst)
	
	begin
		if (NCS = '0') then 
		err <= '0';
--			clk <= SCK;
--			if (rst='1') then
--				err <= '0';
--				data_valid <= '0';
--			end if;
			-- elsif (clk'event and clk = '1') then   clk only in procedures in UART_package
				if (re = '1') then
				--	rxd <= MOSI;
					receiver (rxd, SCLK, rst, UART_out, err, data_valid);
					--data_valid <= '1';
				elsif (we = '1') then
					transmitter (SCLK, rst, UART_in, txd, data_valid);
				--	MISO <= txd;   
				--data_valid <= '1';
				else 
				data_valid <= '0';
			--		data <= reg(7 downto 0);
				end if;
			-- end if;
		end if;	
	end process;
	
		
end Behavioral;

