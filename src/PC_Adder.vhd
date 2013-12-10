----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:50:15 11/21/2013 
-- Design Name: 
-- Module Name:    PC_Adder_4 - Behavioral 
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
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;
library work;
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_Adder is
    Port ( OLD_PC : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           NEW_PC : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO
        );
end PC_Adder;

architecture Behavioral of PC_Adder is

begin
	process (OLD_PC)
	begin
		NEW_PC <= OLD_PC + "0000000000000001";
	end process;
end Behavioral;

