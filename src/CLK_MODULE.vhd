----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:35 11/22/2013 
-- Design Name: 
-- Module Name:    MUX_4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_MODULE is
    Port ( CLK_IN : in STD_LOGIC;
           CLK : inout STD_LOGIC := '1'
	);
end CLK_MODULE;

architecture Behavioral of CLK_MODULE is
	signal count : std_logic_vector(29 downto 0) := "000000000000000000000000000000";
begin
	process (CLK_IN)
	begin
		if (CLK_IN'event and CLK_IN = '0') then
			count <= count + 1;
			--if (count = "000001010110001001011010000000") then
			if (count = "000000000000000000000000000011") then
				CLK <= not CLK; 
				count <= "000000000000000000000000000000";
			end if;
		end if;
	end process;
end Behavioral;

