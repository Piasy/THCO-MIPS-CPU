----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:26:22 11/22/2013 
-- Design Name: 
-- Module Name:    MEM_WB_Register - Behavioral 
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

entity MEM_WB_Register is
    Port ( CLK : in STD_LOGIC;
	
		   NEW_PC_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           WRITE_REGS_NUM_IN : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           ALU_RESULT_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           IH_REG_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           DM_DATA_IN : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
			  
           REGS_READ_WRITE_IN : in  STD_LOGIC := WRITE_REGS_NO;
           REGS_WRITE_DATA_SRC_IN : in  STD_LOGIC_VECTOR (1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
			  
           NEW_PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           WRITE_REGS_NUM_OUT : out  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           ALU_RESULT_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           IH_REG_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           DM_DATA_OUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
			  
           REGS_READ_WRITE_OUT : out  STD_LOGIC := WRITE_REGS_NO;
           REGS_WRITE_DATA_SRC_OUT : out  STD_LOGIC_VECTOR (1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT
	);
end MEM_WB_Register;

architecture Behavioral of MEM_WB_Register is

begin
	process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			NEW_PC_OUT <= NEW_PC_IN;
			WRITE_REGS_NUM_OUT <= WRITE_REGS_NUM_IN;
			ALU_RESULT_OUT <= ALU_RESULT_IN;
			IH_REG_OUT <= IH_REG_IN;
			DM_DATA_OUT <= DM_DATA_IN;
			
			REGS_READ_WRITE_OUT <= REGS_READ_WRITE_IN;
			REGS_WRITE_DATA_SRC_OUT <= REGS_WRITE_DATA_SRC_IN;
		end if;
	end process;
end Behavioral;

