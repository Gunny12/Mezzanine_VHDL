----------------------------------------------------------------------------------
-- Company: LMU
-- Engineer: Gunter Wahl
-- 
-- Create Date:    11:36:28 04/12/2017 
-- Design Name: 
-- Module Name:    UART_package - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1.0 of 5/16/2017
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- UART settings: 9600 baud, 8 bits, no parity, no handshaking

package UART_package is
--    Port ( din : in  STD_LOGIC;
--           clk : in  STD_LOGIC;
--           rst : in  STD_LOGIC;
--           data : out  STD_LOGIC_VECTOR (7 downto 0);
--           err : out  STD_LOGIC;
--           data_valid : out  STD_LOGIC);
	 procedure receiver (signal rxd, clk, rst: in STD_LOGIC;
							signal dout: out STD_LOGIC_VECTOR (7 downto 0);
							signal err, data_valid: out STD_LOGIC);
							
	 procedure transmitter (signal clk, rst: in STD_LOGIC;
								signal din: in STD_LOGIC_VECTOR (7 downto 0);
								signal txd, data_valid: out STD_LOGIC);
end UART_package;


package body UART_package is

-- Serial data receiver
	procedure receiver (signal rxd, clk, rst: in STD_LOGIC;
							signal dout: out STD_LOGIC_VECTOR (7 downto 0);
							signal err, data_valid: out STD_LOGIC) is
	
-- 8 data bits

	--begin
		-- process(rst, clk)
		variable count: integer range 0 to 10;
		variable reg: STD_LOGIC_VECTOR (10 downto 0);
		variable temp: STD_LOGIC;
	
		begin
			if (rst='1') then
			count:=0;
			reg := (reg'range => '0');
			temp := '0';
			err <= '0';
			data_valid <= '0';
			elsif (clk'event and clk = '1') then
				if (reg(0) = '1' and rxd = '0') then
					reg(0) := '0';  -- start bit 0
				elsif (reg(0) = '0') then
					count := count + 1;
					if (count < 9) then
						reg(count) := rxd;
					elsif (count = 9) then
						temp := not reg(count);
						-- no parity. 9600, 8, N, 1
						--(reg(1) xor reg(2) xor reg(3) xor reg(4) xor reg(5) xor reg(6) xor
						-- reg(7) xor reg(8) xor reg(9)) or not reg(10);
						err <= temp;
						count := 0;
						reg(0) := rxd;
						if (temp = '0') then
							data_valid <= '1';
							dout <= reg(8 downto 1);
						end if;
					end if;
				end if;
			end if;
		-- end process;
	end receiver;

-- Serial data transmitter
	 procedure transmitter (signal clk, rst: in STD_LOGIC;
								signal din: in STD_LOGIC_VECTOR (7 downto 0);
								signal txd, data_valid: out STD_LOGIC) is
	-- begin
		-- process(rst, clk)
		variable count: integer range 0 to 10;
		variable reg: STD_LOGIC_VECTOR (10 downto 0);
		--variable parity: STD_LOGIC;
		
		begin
			if (rst='1') then
				count:=0;
				reg := (reg'range => '0');
				--temp := '0';
				--err <= '0';
				data_valid <= '0';
				reg(8 downto 1) := din;
				reg(0) := '0';  -- start bit
				reg(9) := '1';  -- stop bit
			elsif (clk'event and clk = '1') then
				if (reg(0) = '0') then
				count := count + 1;
					if (count < 9) then
						txd <= reg(count);
					elsif (count = 9) then
						--parity := (reg(1) xor reg(2) xor reg(3) xor reg(4) xor reg(5) xor reg(6) xor
						--reg(7) xor reg(8));
						--err <= temp;
											
						-- if (temp = '0') then
						-- reg(count) := parity;
							count := 0; 
							data_valid <= '1';
						-- end if;
					end if;
				end if;	
			end if;		
		-- end process;
	end transmitter;
end UART_package;

-- end Behavioral;

