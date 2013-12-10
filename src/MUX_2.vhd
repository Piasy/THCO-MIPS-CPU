----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:42:26 11/25/2013 
-- Design Name: 
-- Module Name:    MUX_2 - Behavioral 
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

entity MUX_2 is
    Port ( SELEC : in  STD_LOGIC;
           SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
end MUX_2;

architecture Behavioral of MUX_2 is

begin
	process(SRC_1, SRC_2, SELEC)
	begin
		case SELEC is
			when '0' =>
				OUTPUT <= SRC_1;
			when '1' =>
				OUTPUT <= SRC_2;
			when others =>
				OUTPUT <= HIGH_RESIST;
		end case;
	end process;
end Behavioral;

