----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:35 11/23/2013 
-- Design Name: 
-- Module Name:    Special_Register - Behavioral 
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

entity Special_Register is
	port(
		clk : in STD_LOGIC;
	
		T_cmd_write : in STD_LOGIC;
		T_cmd_src : in STD_LOGIC;
		T_src_SF : in STD_LOGIC;
		T_src_ZF : in STD_LOGIC;
		
		RA_cmd_write : in STD_LOGIC;
		RA_src : in STD_LOGIC_VECTOR(15 downto 0);
		
		IH_cmd_write : in STD_LOGIC;
		IH_src : in STD_LOGIC_VECTOR(15 downto 0);
		
		SP_cmd_write : in STD_LOGIC;
		SP_src : in STD_LOGIC_VECTOR(15 downto 0);
		
		T_value : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		RA_value : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		IH_value : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		SP_value : out STD_LOGIC_VECTOR(15 downto 0) := ZERO
	);

end Special_Register;

architecture Behavioral of Special_Register is
begin
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (T_cmd_write = WRITE_T_YES) then
				if (T_cmd_src = T_SRC_IS_SF) then
					if (T_src_SF = '1') then
						T_value <= FFFF;
					else
						T_value <= ZERO;
					end if;
				elsif (T_cmd_src = T_SRC_IS_NOT_ZF) then
					if (T_src_ZF = '0') then
						T_value <= FFFF;
					else
						T_Value <= ZERO;
					end if;
				else
					NULL;
				end if;
			end if;
		
			if (RA_cmd_write = WRITE_RA_YES) then
				RA_value <= RA_src;
			end if;
		
			if (IH_cmd_write = WRITE_IH_YES) then
				IH_value <= IH_src;
			end if;

			if (SP_cmd_write = WRITE_SP_YES) then
				SP_value <= SP_src;
			end if;	
		end if;
	end process;
end Behavioral;