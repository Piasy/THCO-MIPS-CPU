----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:19:15 11/22/2013 
-- Design Name: 
-- Module Name:    PC_Register - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_Register is
    Port ( PC_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
		   WRITE_OR_NOT : in STD_LOGIC := WRITE_PC_YES;
           CLK : in  STD_LOGIC);
end PC_Register;

architecture Behavioral of PC_Register is

begin
	process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			-- update pc value at up edge
			if (WRITE_OR_NOT = WRITE_PC_YES) then
				PC_OUT <= PC_IN;
			end if;
		end if;
	end process;
end Behavioral;

