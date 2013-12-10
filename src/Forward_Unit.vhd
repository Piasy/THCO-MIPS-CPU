----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:47:55 11/23/2013 
-- Design Name: 
-- Module Name:    Forward_Unit - Behavioral 
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

entity Forward_Unit is
    Port ( -- current instruction info, if use reg as alu src, conflict may exist
		   CUR_RS_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           CUR_RT_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
		   CUR_ALU_A_SRC_SELECT : in STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
		   CUR_ALU_B_SRC_SELECT : in STD_LOGIC_VECTOR (1 downto 0) := "ZZ";
		   
		   -- last instruction info, if write regs, conflict may exist, if read DM, must stall
		   LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC := WRITE_REGS_NO;
		   LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           LAST_DM_READ_WRITE : in  STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
		   
		   -- last last instruction info, if write regs, conflict may exist
           LAST_LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC := WRITE_REGS_NO;
           LAST_LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
		   
           STALL_OR_NOT : out  STD_LOGIC := STALL_NO;
           ALU_A_SRC_SELECT_FINAL : out  STD_LOGIC_VECTOR (1 downto 0) := ALU_A_SRC_SELECT_FINAL_ORIGIN;
           ALU_B_SRC_SELECT_FINAL : out  STD_LOGIC_VECTOR (1 downto 0) := ALU_B_SRC_SELECT_FINAL_ORIGIN
	);
end Forward_Unit;

architecture Behavioral of Forward_Unit is

begin
	process(CUR_RS_REG_NUM, CUR_RT_REG_NUM, CUR_ALU_A_SRC_SELECT, CUR_ALU_B_SRC_SELECT, 
			LAST_WRITE_REGS_OR_NOT, LAST_WRITE_REGS_TARGET, LAST_DM_READ_WRITE,
			LAST_LAST_WRITE_REGS_OR_NOT, LAST_LAST_WRITE_REGS_TARGET)
	begin
		-- 本条指令用A  B 作为ALU操作数，可能有冲突
		if (CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A or CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
			if (LAST_DM_READ_WRITE = MEM_READ and LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES) then
			-- 上访，上写，冲突则必须停
				if (LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
					STALL_OR_NOT <= STALL_YES;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				elsif (LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
					STALL_OR_NOT <= STALL_YES;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				else
					-- 无冲突，正常执行
					STALL_OR_NOT <= STALL_NO;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				end if;				
			elsif (LAST_DM_READ_WRITE = MEM_READ and LAST_WRITE_REGS_OR_NOT = WRITE_REGS_NO) then
			-- 上访，上不写，上上写，有冲突选旁路
				if (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES) then
					-- A conflict, need not stall, select mem/wb reg value
					if (LAST_LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_MEM_WB_REG  ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN  ;
					-- B conflict, need not stall, select mem/wb reg value
					elsif (LAST_LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN  ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_MEM_WB_REG  ;
					else
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
					end if;
				else
				-- 无冲突，正常执行
					STALL_OR_NOT <= STALL_NO;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				end if;
			elsif (LAST_DM_READ_WRITE /= MEM_READ and LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES) then
			-- 上不访，上写，上上写，有冲突优先选EXE/MEM(优先判断上条指令)
				if (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES) then
					if (LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_EXE_MEM_REG ;
						-- 还要判断上上条是否和B冲突
						if (LAST_LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
							ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_MEM_WB_REG;
						else
							ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
						end if;
					elsif (LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
						STALL_OR_NOT <= STALL_NO;
						if (LAST_LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
							ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_MEM_WB_REG ;
						else
							ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN;
						end if;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_EXE_MEM_REG;
					else
					-- 上条指令无冲突，判断上上条指令是否冲突
						if (LAST_LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
							STALL_OR_NOT <= STALL_NO;
							ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_MEM_WB_REG;
							ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
						elsif (LAST_LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
							STALL_OR_NOT <= STALL_NO;
							ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
							ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_MEM_WB_REG;
						else
							STALL_OR_NOT <= STALL_NO;
							ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
							ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
						end if;
					end if;	
				-- 上不访，上写，上上不写，有冲突选旁路
				else
					if (LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_EXE_MEM_REG ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
					elsif (LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_EXE_MEM_REG ;
					else
					-- 无冲突，正常执行
						STALL_OR_NOT <= STALL_NO;
						ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
						ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
					end if;	
				end if;
			-- 上不访，上不写，上上写，有冲突选旁路
			elsif (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES) then
				if (LAST_LAST_WRITE_REGS_TARGET = CUR_RS_REG_NUM and CUR_ALU_A_SRC_SELECT = ALU_A_SRC_A) then
					STALL_OR_NOT <= STALL_NO;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_MEM_WB_REG;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				elsif (LAST_LAST_WRITE_REGS_TARGET = CUR_RT_REG_NUM and CUR_ALU_B_SRC_SELECT = ALU_B_SRC_B) then
					STALL_OR_NOT <= STALL_NO;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_MEM_WB_REG;
				else
					STALL_OR_NOT <= STALL_NO;
					ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
					ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
				end if;
			-- 上不访，上不写，上上不写，无冲突
			else
				STALL_OR_NOT <= STALL_NO;
				ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
				ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
			end if;
		else
			STALL_OR_NOT <= STALL_NO;
			ALU_A_SRC_SELECT_FINAL <= ALU_A_SRC_SELECT_FINAL_ORIGIN ;
			ALU_B_SRC_SELECT_FINAL <= ALU_B_SRC_SELECT_FINAL_ORIGIN ;
		end if;
	end process;
end Behavioral;

