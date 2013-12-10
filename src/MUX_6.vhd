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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_6 is
    Port ( SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_3 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_4 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
		   SRC_5 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_6 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SELEC : in  STD_LOGIC_VECTOR (2 downto 0) := "111";
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO
	);
end MUX_6;

architecture Behavioral of MUX_6 is

begin
	process (SRC_1, SRC_2, SRC_3, SRC_4, SRC_5, SRC_6, SELEC)
	begin
		case SELEC is
			when "000" =>
				OUTPUT <= SRC_1;
			when "001" => 
				OUTPUT <= SRC_2;
			when "010" =>
				OUTPUT <= SRC_3;
			when "011" =>
				OUTPUT <= SRC_4;
			when "100" =>
				OUTPUT <= SRC_5;
			when "101" =>
				OUTPUT <= SRC_6;
			when others =>
				OUTPUT <= HIGH_RESIST;
		end case;
	end process;
end Behavioral;

