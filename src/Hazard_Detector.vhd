----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:38:59 11/23/2013 
-- Design Name: 
-- Module Name:    Hazard_Detector - Behavioral 
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
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hazard_Detector is
    Port ( STALL_OR_NOT_FU : in  STD_LOGIC := STALL_NO;
           
		   CUR_INST_CODE : in  STD_LOGIC_VECTOR (4 downto 0) := NOP_INST(15 downto 11);
           CUR_INST_RS : in  STD_LOGIC_VECTOR (2 downto 0) := NOP_INST(10 downto 8);
           CUR_INST_RT : in  STD_LOGIC_VECTOR (2 downto 0) := NOP_INST(7 downto 5);
           CUR_INST_RD : in  STD_LOGIC_VECTOR (2 downto 0) := NOP_INST(4 downto 2);
           CUR_INST_FUNC : in  STD_LOGIC_VECTOR (1 downto 0):= NOP_INST(1 downto 0);
           
		   LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC := WRITE_REGS_NO;
           LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
		   LAST_VISIT_DM_OR_NOT : in STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
           
		   LAST_LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC := WRITE_REGS_NO;
           LAST_LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0) := "ZZZ";
           
		   LAST_LAST_VISIT_DM_OR_NOT : in STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
		   LAST_LAST_DM_VISIT_ADDR : in  STD_LOGIC_VECTOR (15 downto 0) := HIGH_RESIST;
		   
		   CUR_DM_READ_WRITE : in STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
		   CUR_DM_WRITE_DATA_SRC : in STD_LOGIC_VECTOR(1 downto 0) := WRITE_DM_DATA_SRC_Z;
		   
		   JUMP_OR_NOT : in STD_LOGIC := JUMP_FALSE;
           
		   WRITE_PC_OR_NOT : out  STD_LOGIC := WRITE_PC_YES;
           NEW_PC_SRC_SELEC : out  STD_LOGIC_VECTOR (1 downto 0) := NEW_PC_SRC_SELEC_PC_ADD_ONE;
           WRITE_IR_OR_NOT : out  STD_LOGIC := WRITE_IR_YES;
           WRITE_IR_SRC_SELEC : out  STD_LOGIC := WRITE_IR_SRC_SELEC_ORIGIN;
           COMMAND_ORIGIN_OR_NOP : out  STD_LOGIC := COMMAND_ORIGIN;
		   
		   DM_DATA_RESULT_SELEC : out STD_LOGIC := DM_DATA_RESULT_DM ;
		   IM_ADDR_SELEC : out STD_LOGIC := IM_ADDR_PC;
		   IM_DATA_SELEC : out STD_LOGIC := IM_DATA_Z;
		   IM_READ_WRITE_SELEC : out STD_LOGIC_VECTOR(1 downto 0) := MEM_READ
	);
end Hazard_Detector;

architecture Behavioral of Hazard_Detector is
signal never_used_pin : std_logic;
begin
	never_used_pin <= STALL_OR_NOT_FU;
	process (CUR_INST_CODE, CUR_INST_RS, CUR_INST_RT, CUR_INST_RD, CUR_INST_FUNC,
			 LAST_WRITE_REGS_OR_NOT, LAST_WRITE_REGS_TARGET, LAST_VISIT_DM_OR_NOT,
			 LAST_LAST_WRITE_REGS_OR_NOT, LAST_LAST_WRITE_REGS_TARGET,
			 LAST_LAST_VISIT_DM_OR_NOT, LAST_LAST_DM_VISIT_ADDR, CUR_DM_READ_WRITE, CUR_DM_WRITE_DATA_SRC, JUMP_OR_NOT)
		variable inst_rd_func : std_logic_vector(4 downto 0);
		variable stall_or_not : boolean := False;
		variable write_dm_or_not : boolean := False;
		variable write_data_a_flag : boolean := False;
		variable write_data_b_flag : boolean := False;
		variable write_a_flag : boolean := False;
		variable write_b_flag : boolean := False;
		variable a_conflict_flag : boolean := False;
		variable b_conflict_flag : boolean := False;
	begin
		inst_rd_func(4 downto 2) := CUR_INST_RD;
		inst_rd_func(1 downto 0) := CUR_INST_FUNC;
		write_dm_or_not := (CUR_DM_READ_WRITE = MEM_WRITE) and (CUR_DM_READ_WRITE = MEM_WRITE);
		write_data_a_flag := CUR_DM_WRITE_DATA_SRC = WRITE_DM_DATA_SRC_A;
		write_data_b_flag := CUR_DM_WRITE_DATA_SRC = WRITE_DM_DATA_SRC_B;
		write_a_flag := (LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or 
								 (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS);
		write_b_flag := (LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RT) or 
								 (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RT);
		a_conflict_flag := write_data_a_flag and write_a_flag;
		b_conflict_flag := write_data_b_flag and write_b_flag;
		
		stall_or_not := write_dm_or_not and (a_conflict_flag or b_conflict_flag);
		
		-- if forward unit call for stall, stop PC, IR, set CMD NOP
		-- if (STALL_OR_NOT_FU = STALL_YES) then
			-- WRITE_PC_OR_NOT <= WRITE_PC_NO ;
			-- NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
			-- WRITE_IR_OR_NOT <= WRITE_IR_NO ;
			-- WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN ;
			-- COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
		-- 暂且无谓暂停也无所谓
		if (LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and 
			(LAST_WRITE_REGS_TARGET = CUR_INST_RS or LAST_WRITE_REGS_TARGET = CUR_INST_RT) and 
			LAST_VISIT_DM_OR_NOT = MEM_READ) then
			WRITE_PC_OR_NOT <= WRITE_PC_NO ;
			NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
			WRITE_IR_OR_NOT <= WRITE_IR_NO ;
			WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN ;
			COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
			
			-- load user's program, just stop PC
			if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
				CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
				DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
				IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
				IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
				IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
			-- no conflict keep all as origin
			else
				DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
				IM_ADDR_SELEC <= IM_ADDR_PC;
				IM_DATA_SELEC <= IM_DATA_Z;
				IM_READ_WRITE_SELEC <= MEM_READ;
			end if;
		-- SW型指令要直接用到A或B的值，有可能存在数据冲突，若有，暂停
		elsif (CUR_DM_READ_WRITE = MEM_WRITE and 
					((CUR_DM_WRITE_DATA_SRC = WRITE_DM_DATA_SRC_A and 
						((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or 
						 (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS))) 
				  or (CUR_DM_WRITE_DATA_SRC = WRITE_DM_DATA_SRC_B and 
						((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RT) or 
						 (LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RT))))) then
			WRITE_PC_OR_NOT <= WRITE_PC_NO ;
			NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
			WRITE_IR_OR_NOT <= WRITE_IR_NO ;
			WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN ;
			COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
			
			-- load user's program, just stop PC
			if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
				CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
				DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
				IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
				IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
				IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
			-- no conflict keep all as origin
			else
				DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
				IM_ADDR_SELEC <= IM_ADDR_PC;
				IM_DATA_SELEC <= IM_DATA_Z;
				IM_READ_WRITE_SELEC <= MEM_READ;
			end if;
		else
			case CUR_INST_CODE is 
				-- B inst, must jump, set PC to PC + IMM, set IR to NOP, set CMD to NOP
				when INST_CODE_B =>
					WRITE_PC_OR_NOT <= WRITE_PC_YES ;
					NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_IMM ;
					WRITE_IR_OR_NOT <= WRITE_IR_YES ;
					WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
					COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
					
					-- load user's program, just stop PC
					if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
						CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
						DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
						IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
						IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
						IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
					-- no conflict keep all as origin
					else
						DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
						IM_ADDR_SELEC <= IM_ADDR_PC;
						IM_DATA_SELEC <= IM_DATA_Z;
						IM_READ_WRITE_SELEC <= MEM_READ;
					end if;
				when INST_CODE_BEQZ =>
					-- BEQZ inst, if has data conflict, stall, stop PC, stop IR, set CMD to NOP
					if ((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or
						(LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS)) then
						WRITE_PC_OR_NOT <= WRITE_PC_NO ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
						WRITE_IR_OR_NOT <= WRITE_IR_NO ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
						
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					-- no conflict, if jump, set PC to PC + IMM, set IR to NOP, set CMD to NOP
					elsif (JUMP_OR_NOT = JUMP_TRUE) then
						WRITE_PC_OR_NOT <= WRITE_PC_YES ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_IMM ;
						WRITE_IR_OR_NOT <= WRITE_IR_YES ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
						
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					else
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							WRITE_PC_OR_NOT <= WRITE_PC_NO ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							-- load user's program, just stop PC
							if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
								CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
								IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
								IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
								IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
							-- no conflict keep all as origin
							else
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
								IM_ADDR_SELEC <= IM_ADDR_PC;
								IM_DATA_SELEC <= IM_DATA_Z;
								IM_READ_WRITE_SELEC <= MEM_READ;
							end if;
						-- no conflict keep all as origin
						else
							WRITE_PC_OR_NOT <= WRITE_PC_YES ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							-- load user's program, just stop PC
							if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
								CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
								IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
								IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
								IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
							-- no conflict keep all as origin
							else
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
								IM_ADDR_SELEC <= IM_ADDR_PC;
								IM_DATA_SELEC <= IM_DATA_Z;
								IM_READ_WRITE_SELEC <= MEM_READ;
							end if;
						end if;
					end if;
				when INST_CODE_BNEZ =>
					-- BNEZ inst, if has data conflict, stall, stop PC, stop IR, set CMD to NOP
					if ((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or
						(LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS)) then
						WRITE_PC_OR_NOT <= WRITE_PC_NO ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
						WRITE_IR_OR_NOT <= WRITE_IR_NO ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
						
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					-- no conflict, if jump, set PC to PC + IMM, set IR to NOP, set CMD to NOP
					elsif (JUMP_OR_NOT = JUMP_TRUE) then
						WRITE_PC_OR_NOT <= WRITE_PC_YES ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_IMM ;
						WRITE_IR_OR_NOT <= WRITE_IR_YES ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
						
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					else
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							WRITE_PC_OR_NOT <= WRITE_PC_NO ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							WRITE_PC_OR_NOT <= WRITE_PC_YES ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					end if;
				when INST_CODE_ADDSP_BTEQZ_MTSP =>
					if (CUR_INST_RS = INST_RS_BTEQZ ) then
						-- BTEQZ inst, if jump, set PC to PC + IMM, set IR to NOP, set CMD to NOP
						if (JUMP_OR_NOT = JUMP_TRUE) then
							WRITE_PC_OR_NOT <= WRITE_PC_YES ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_IMM ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
							
							-- load user's program, just stop PC
							if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
								CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
								IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
								IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
								IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
							-- no conflict keep all as origin
							else
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
								IM_ADDR_SELEC <= IM_ADDR_PC;
								IM_DATA_SELEC <= IM_DATA_Z;
								IM_READ_WRITE_SELEC <= MEM_READ;
							end if;
						else
							-- load user's program, just stop PC
							if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
								CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
								WRITE_PC_OR_NOT <= WRITE_PC_NO ;
								NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
								WRITE_IR_OR_NOT <= WRITE_IR_YES ;
								WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
								COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
								
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
								IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
								IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
								IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
							-- no conflict keep all as origin
							else
								WRITE_PC_OR_NOT <= WRITE_PC_YES ;
								NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
								WRITE_IR_OR_NOT <= WRITE_IR_YES ;
								WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
								COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
								
								DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
								IM_ADDR_SELEC <= IM_ADDR_PC;
								IM_DATA_SELEC <= IM_DATA_Z;
								IM_READ_WRITE_SELEC <= MEM_READ;
							end if;
						end if;
					else
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							WRITE_PC_OR_NOT <= WRITE_PC_NO ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							WRITE_PC_OR_NOT <= WRITE_PC_YES ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					end if;
				when INST_CODE_AND_TO_SLT =>
					if (inst_rd_func = INST_RD_FUNC_JALR_JR_MFPC ) then
						case CUR_INST_RT is
							-- JALR inst, jump, set PC to reg A, set IR to NOP, keep CMD as origin
							when INST_RT_JALR =>
								if ((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or
									(LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS)) then
									WRITE_PC_OR_NOT <= WRITE_PC_NO ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_REG_A  ;
									WRITE_IR_OR_NOT <= WRITE_IR_NO ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
									
									-- load user's program, just stop PC
									if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
										CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
										IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
										IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
										IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
									-- no conflict keep all as origin
									else
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
										IM_ADDR_SELEC <= IM_ADDR_PC;
										IM_DATA_SELEC <= IM_DATA_Z;
										IM_READ_WRITE_SELEC <= MEM_READ;
									end if;
								else
									WRITE_PC_OR_NOT <= WRITE_PC_YES ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_REG_A  ;
									WRITE_IR_OR_NOT <= WRITE_IR_YES ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
									
									-- load user's program, just stop PC
									if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
										CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
										IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
										IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
										IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
									-- no conflict keep all as origin
									else
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
										IM_ADDR_SELEC <= IM_ADDR_PC;
										IM_DATA_SELEC <= IM_DATA_Z;
										IM_READ_WRITE_SELEC <= MEM_READ;
									end if;
								end if;
							-- JR inst, jump, set PC to reg A, set IR to NOP, keep CMD as origin
							when INST_RT_JR =>
								if ((LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_WRITE_REGS_TARGET = CUR_INST_RS) or
									(LAST_LAST_WRITE_REGS_OR_NOT = WRITE_REGS_YES and LAST_LAST_WRITE_REGS_TARGET = CUR_INST_RS)) then
									WRITE_PC_OR_NOT <= WRITE_PC_NO ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_REG_A  ;
									WRITE_IR_OR_NOT <= WRITE_IR_NO ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
									
									-- load user's program, just stop PC
									if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
										CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
										IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
										IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
										IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
									-- no conflict keep all as origin
									else
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
										IM_ADDR_SELEC <= IM_ADDR_PC;
										IM_DATA_SELEC <= IM_DATA_Z;
										IM_READ_WRITE_SELEC <= MEM_READ;
									end if;
								else
									WRITE_PC_OR_NOT <= WRITE_PC_YES ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_REG_A  ;
									WRITE_IR_OR_NOT <= WRITE_IR_YES ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_NOP ;
									
									-- load user's program, just stop PC
									if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
										CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
										IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
										IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
										IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
									-- no conflict keep all as origin
									else
										DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
										IM_ADDR_SELEC <= IM_ADDR_PC;
										IM_DATA_SELEC <= IM_DATA_Z;
										IM_READ_WRITE_SELEC <= MEM_READ;
									end if;
								end if;
							when others =>
								-- load user's program, just stop PC
								if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
									CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
									WRITE_PC_OR_NOT <= WRITE_PC_NO ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
									WRITE_IR_OR_NOT <= WRITE_IR_YES ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
									
									DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
									IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
									IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
									IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
								-- no conflict keep all as origin
								else
									WRITE_PC_OR_NOT <= WRITE_PC_YES ;
									NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
									WRITE_IR_OR_NOT <= WRITE_IR_YES ;
									WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
									COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
									
									DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
									IM_ADDR_SELEC <= IM_ADDR_PC;
									IM_DATA_SELEC <= IM_DATA_Z;
									IM_READ_WRITE_SELEC <= MEM_READ;
								end if;
						end case;
					else
						-- load user's program, just stop PC
						if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
							CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
							WRITE_PC_OR_NOT <= WRITE_PC_NO ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
							IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
							IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
							IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
						-- no conflict keep all as origin
						else
							WRITE_PC_OR_NOT <= WRITE_PC_YES ;
							NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
							WRITE_IR_OR_NOT <= WRITE_IR_YES ;
							WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
							COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
							
							DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
							IM_ADDR_SELEC <= IM_ADDR_PC;
							IM_DATA_SELEC <= IM_DATA_Z;
							IM_READ_WRITE_SELEC <= MEM_READ;
						end if;
					end if;
				when others =>
					-- load user's program, just stop PC
					if ((LAST_LAST_VISIT_DM_OR_NOT = MEM_READ or LAST_LAST_VISIT_DM_OR_NOT = MEM_WRITE) and 
						CONV_INTEGER(LAST_LAST_DM_VISIT_ADDR) < INST_DATA_MEM_ADDR_EDGE) then
						WRITE_PC_OR_NOT <= WRITE_PC_NO ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
						WRITE_IR_OR_NOT <= WRITE_IR_YES ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_NOP;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
						
						DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_IM ;
						IM_ADDR_SELEC <= IM_ADDR_ALU_RESULT;
						IM_DATA_SELEC <= IM_DATA_ALU_RESULT;
						IM_READ_WRITE_SELEC <= LAST_LAST_VISIT_DM_OR_NOT;
					-- no conflict keep all as origin
					else
						WRITE_PC_OR_NOT <= WRITE_PC_YES ;
						NEW_PC_SRC_SELEC <= NEW_PC_SRC_SELEC_PC_ADD_ONE ;
						WRITE_IR_OR_NOT <= WRITE_IR_YES ;
						WRITE_IR_SRC_SELEC <= WRITE_IR_SRC_SELEC_ORIGIN;
						COMMAND_ORIGIN_OR_NOP <= COMMAND_ORIGIN ;
						
						DM_DATA_RESULT_SELEC <= DM_DATA_RESULT_DM ;
						IM_ADDR_SELEC <= IM_ADDR_PC;
						IM_DATA_SELEC <= IM_DATA_Z;
						IM_READ_WRITE_SELEC <= MEM_READ;
					end if;
			end case;
		end if;
	end process;
end Behavioral;

