----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:29:36 11/21/2013 
-- Design Name: 
-- Module Name:    MUX_3 - Behavioral 
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

entity MUX_3 is
    Port ( SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_3 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SELEC : in  STD_LOGIC_VECTOR (1 downto 0) := "00";
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO
	);
end MUX_3;

architecture Behavioral of MUX_3 is

begin
	process(SRC_1, SRC_2, SRC_3, SELEC)
	begin
		case SELEC is
			when "00" =>
				OUTPUT <= SRC_1;
			when "01" =>
				OUTPUT <= SRC_2;
			when "10" =>
				OUTPUT <= SRC_3;
			when others =>
				OUTPUT <= HIGH_RESIST;
		end case;
	end process;
end Behavioral;

