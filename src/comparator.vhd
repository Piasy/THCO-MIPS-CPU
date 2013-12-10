----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:53:34 11/20/2013 
-- Design Name: 
-- Module Name:    Comparator - Behavioral 
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

entity Comparator is
	port(
		code : in STD_LOGIC_VECTOR(4 downto 0);
		write_t : in STD_LOGIC;
		t : in STD_LOGIC_VECTOR(15 downto 0);
		T_src_SF : in STD_LOGIC;
		T_src_ZF : in STD_LOGIC;
		T_cmd_src : in STD_LOGIC;
		
		a : in STD_LOGIC_VECTOR(15 downto 0);
		
		jump : out STD_LOGIC
	);
end Comparator;

architecture Behavioral of Comparator is
begin
	process(code, write_t, t, T_src_SF, T_src_ZF, T_cmd_src, a)
		variable real_t : STD_LOGIC_VECTOR(15 downto 0) := ZERO;
	begin
		real_t := ZERO;
		case code is
			-- if (a == 0) jump
			when INST_CODE_BEQZ =>
				if (a = ZERO) then
					jump <= JUMP_TRUE;
				else
					jump <= JUMP_FALSE;
				end if;
			-- if (a != 0) jump
			when INST_CODE_BNEZ =>
				if (a = ZERO) then
					jump <= JUMP_FALSE;
				else
					jump <= JUMP_TRUE;
				end if;
			--if (t == 0) jump
			when INST_CODE_ADDSP_BTEQZ_MTSP =>
				if (write_t = WRITE_T_YES) then
					if (T_cmd_src = T_SRC_IS_SF) then
						if (T_src_SF = '1') then
							real_t := FFFF;
						else
							real_t := ZERO;
						end if;
					elsif (T_cmd_src = T_SRC_IS_NOT_ZF) then
						if (T_src_ZF = '0') then
							real_t := FFFF;
						else
							real_t := ZERO;
						end if;
					else
						NULL;
					end if;
				else
					real_t := t;
				end if;
				if (real_t = 0) then
					jump <= JUMP_TRUE;
				else
					jump <= JUMP_FALSE;
				end if;
			when others =>
				jump <= JUMP_FALSE;
		end case;
	end process;
end Behavioral;

