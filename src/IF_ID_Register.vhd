----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:48:24 11/21/2013 
-- Design Name: 
-- Module Name:    IF_ID_Register - Behavioral 
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

entity IF_ID_Register is
    Port ( NEW_PC_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
		   WRITE_PC_OR_NOT : in STD_LOGIC := WRITE_PC_YES;
           NEW_PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           CLK : in  STD_LOGIC;
		   INST_IN : in  STD_LOGIC_VECTOR (15 downto 0) := NOP_INST;
		   
           WRITE_IR_OR_NOT : in  STD_LOGIC := WRITE_IR_YES;
           WRITE_IR_SRC_SELEC : in  STD_LOGIC := WRITE_IR_SRC_SELEC_ORIGIN;
		   
		   INST_OUT_CODE : out STD_LOGIC_VECTOR(4 downto 0) := NOP_INST(15 downto 11);
		   INST_OUT_RS : out STD_LOGIC_VECTOR(2 downto 0) := NOP_INST(10 downto 8);
		   INST_OUT_RT : out STD_LOGIC_VECTOR(2 downto 0) := NOP_INST(7 downto 5);
		   INST_OUT_RD : out STD_LOGIC_VECTOR(2 downto 0) := NOP_INST(4 downto 2);
		   INST_OUT_FUNC : out STD_LOGIC_VECTOR(1 downto 0) := NOP_INST(1 downto 0)
	);
end IF_ID_Register;

architecture Behavioral of IF_ID_Register is

begin
	process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			-- update value at up edge
			if (WRITE_PC_OR_NOT = WRITE_PC_YES) then
				NEW_PC_OUT <= NEW_PC_IN;
			end if;
			
			if (WRITE_IR_OR_NOT = WRITE_IR_YES ) then
				case WRITE_IR_SRC_SELEC is
					when WRITE_IR_SRC_SELEC_ORIGIN =>
						INST_OUT_CODE <= INST_IN(15 downto 11);
						INST_OUT_RS <= INST_IN(10 downto 8);
						INST_OUT_RT <= INST_IN(7 downto 5);
						INST_OUT_RD <= INST_IN(4 downto 2);
						INST_OUT_FUNC <= INST_IN(1 downto 0);
					when WRITE_IR_SRC_SELEC_NOP =>
						INST_OUT_CODE <= NOP_INST(15 downto 11);
						INST_OUT_RS <= NOP_INST(10 downto 8);
						INST_OUT_RT <= NOP_INST(7 downto 5);
						INST_OUT_RD <= NOP_INST(4 downto 2);
						INST_OUT_FUNC <= NOP_INST(1 downto 0);
					when others =>
						INST_OUT_CODE <= INST_IN(15 downto 11);
						INST_OUT_RS <= INST_IN(10 downto 8);
						INST_OUT_RT <= INST_IN(7 downto 5);
						INST_OUT_RD <= INST_IN(4 downto 2);
						INST_OUT_FUNC <= INST_IN(1 downto 0);
				end case;
			end if;
		end if;
	end process;
end Behavioral;

