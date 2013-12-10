----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:27:36 11/22/2013 
-- Design Name: 
-- Module Name:    Register - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.common.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Common_Register is
	port(
		clk : in STD_LOGIC;
	
		rs : in STD_LOGIC_VECTOR(2 downto 0);
		rt : in STD_LOGIC_VECTOR(2 downto 0);
		
		write_flag : in STD_LOGIC;
		write_reg : in STD_LOGIC_VECTOR(2 downto 0);
		write_data : in STD_LOGIC_VECTOR(15 downto 0);
		
		a : out STD_LOGIC_VECTOR(15 downto 0);
		b : out STD_LOGIC_VECTOR(15 downto 0)
	);
end Common_Register;

architecture Behavioral of Common_Register is
	signal R0 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R1 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R2 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R3 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R4 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R5 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R6 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	signal R7 : STD_LOGIC_VECTOR(15 downto 0) := ZERO;

begin
	process(clk)
	begin
		if (clk'event and clk = '0') then
			if (write_flag = WRITE_REGS_YES) then
				case write_reg is
					when REG0 =>
						R0 <= write_data;
					when REG1 =>
						R1 <= write_data;
					when REG2 =>
						R2 <= write_data;
					when REG3 =>
						R3 <= write_data;
					when REG4 =>
						R4 <= write_data;
					when REG5 =>
						R5 <= write_data;
					when REG6 =>
						R6 <= write_data;
					when REG7 =>
						R7 <= write_data;
					when others =>
						NULL;
				end case;
			end if;
		end if;
	end process;
	
	process(rs, R0, R1, R2, R3, R4, R5, R6, R7)
	begin
		case rs is
			when REG0 =>
				a <= R0;
			when REG1 =>
				a <= R1;
			when REG2 =>
				a <= R2;
			when REG3 =>
				a <= R3;
			when REG4 =>
				a <= R4;
			when REG5 =>
				a <= R5;
			when REG6 =>
				a <= R6;
			when REG7 =>
				a <= R7;
			when others =>
				a <= ZERO;
		end case;
	end process;
	
	process(rt, R0, R1, R2, R3, R4, R5, R6, R7)
	begin
		case rt is
			when REG0 =>
				b <= R0;
			when REG1 =>
				b <= R1;
			when REG2 =>
				b <= R2;
			when REG3 =>
				b <= R3;
			when REG4 =>
				b <= R4;
			when REG5 =>
				b <= R5;
			when REG6 =>
				b <= R6;
			when REG7 =>
				b <= R7;
			when others =>
				b <= ZERO;
		end case;	
	end process;
end Behavioral;

