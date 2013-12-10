----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:58:51 11/22/2013 
-- Design Name: 
-- Module Name:    Imm_Extend - Behavioral 
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

entity Imm_Extend is
	port(
		code : in STD_LOGIC_VECTOR(4 downto 0);
		rs : in STD_LOGIC_VECTOR(2 downto 0);
		rt : in STD_LOGIC_VECTOR(2 downto 0);
		rd : in STD_LOGIC_VECTOR(2 downto 0);
		func : in STD_LOGIC_VECTOR(1 downto 0);
		
		imm : out STD_LOGIC_VECTOR(15 downto 0)
	);
end Imm_Extend;

architecture Behavioral of Imm_Extend is

begin
	process(code, rs, rt, rd, func)
		variable c : integer := 0;
		variable res : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	begin
		c := 0;
		res := ZERO;
		case code is
			when CODE_IMM_0_0 =>
				c := 0;
			when CODE_IMM_0_1 =>
				c := 0;
			when CODE_IMM_0_2 =>
				c := 0;
			when CODE_IMM_0_3 =>
				c := 0;
			when CODE_IMM_0_4 =>
				c := 0;
			when CODE_IMM_0_5 =>
				c := 0;
			when CODE_IMM_0_6 =>
				c := 0;
			when CODE_IMM_0_7 =>
				c := 0;
			when CODE_IMM_1 =>
				c := 1;
			when CODE_IMM_2_0 =>
				c := 2;
			when CODE_IMM_2_1 =>
				c := 2;
			when CODE_IMM_3 =>
				c := 3;
			when CODE_IMM_4 =>
				c := 4;
			when CODE_IMM_5 =>
				c := 5;
			when others =>
				c := 6;
		end case;
		
		case c is
			when 0 =>
				if (rt(2) = '1') then
					res(15 downto 8) := FFFF(15 downto 8);
				end if;
				res(7 downto 5) := rt;
				res(4 downto 2) := rd;
				res(1 downto 0) := func;
			when 1 =>
				res(7 downto 5) := rt;
				res(4 downto 2) := rd;
				res(1 downto 0) := func;				
			when 2 =>
				if (rd(2) = '1') then
					res(15 downto 5) := FFFF(15 downto 5);
				end if;
				res(4 downto 2) := rd;
				res(1 downto 0) := func;				
			when 3 =>
				if (rs(2) = '1') then
					res(15 downto 11) := FFFF(15 downto 11);
				end if;
				res(10 downto 8) := rs;
				res(7 downto 5) := rt;
				res(4 downto 2) := rd;
				res(1 downto 0) := func;			
			when 4 =>
				if (rd(1) = '1') then
					res(15 downto 4) := FFFF(15 downto 4);
				end if;
				res(3 downto 2) := rd(1 downto 0);
				res(1 downto 0) := func;
			when 5 =>
				res(2 downto 0) := rd;
				if (res = ZERO) then
					res := EIGHT;
				end if;
			when others =>
				NULL;
		end case;
		
		imm <= res;
	end process;

end Behavioral;

