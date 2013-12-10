----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:02:20 11/22/2013 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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

entity Controller is
	Port ( 
		INST_CODE : in STD_LOGIC_VECTOR(4 downto 0);
		INST_RS : in STD_LOGIC_VECTOR(2 downto 0);
		INST_RT : in STD_LOGIC_VECTOR(2 downto 0);
		INST_RD : in STD_LOGIC_VECTOR(2 downto 0);
		INST_FUNC : in STD_LOGIC_VECTOR(1 downto 0);
		
		ALU_OP : out  STD_LOGIC_VECTOR (3 downto 0) := ALU_NULL;
		ALU_A_SRC : out  STD_LOGIC_VECTOR (2 downto 0) := ALU_A_SRC_ZERO;
		ALU_B_SRC : out  STD_LOGIC_VECTOR (1 downto 0) := ALU_B_SRC_ZERO;
		
		WRITE_REGS_DEST : out  STD_LOGIC_VECTOR (1 downto 0);
		WRITE_DM_DATA_SRC : out  STD_LOGIC_VECTOR (1 downto 0) := WRITE_DM_DATA_SRC_Z;
		
		WRITE_RA_OR_NOT : out  STD_LOGIC := WRITE_RA_NO;
		WRITE_IH_OR_NOT : out  STD_LOGIC := WRITE_IH_NO;
		WRITE_T_OR_NOT : out  STD_LOGIC := WRITE_T_NO;
		WRITE_SP_OR_NOT : out  STD_LOGIC := WRITE_SP_NO;
		WRITE_T_SRC : out  STD_LOGIC;
		
		DATA_MEM_READ_WRITE : out  STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
		
		REGS_WRITE_OR_NOT : out  STD_LOGIC := WRITE_REGS_NO;
		REGS_WRITE_DATA_SRC : out  STD_LOGIC_VECTOR (1 downto 0)
	);
end Controller;

architecture Behavioral of Controller is
begin
	process (INST_CODE, INST_RS, INST_RT, INST_RD, INST_FUNC)
		variable inst_rd_func : std_logic_vector(4 downto 0);
		variable cmd : MY_CMD;
	begin
		cmd := get_cmd(ALU_NULL, ALU_A_SRC_ZERO, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
							WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
							MEM_NONE, WRITE_DM_DATA_SRC_Z,
							WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
	
		inst_rd_func(4 downto 2) := INST_RD;
		inst_rd_func(1 downto 0) := INST_FUNC;
		
		case INST_CODE is
			when INST_CODE_ADDSP3 =>
				--ADDPS3  		//[rs] = sp + imm
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_SP, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_NONE, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_NOP =>
				--NOP 			//null
				NULL;
			when INST_CODE_B =>
				--B				//pc = pc + imm
				NULL;
			when INST_CODE_BEQZ =>
				--BEQZ			//if (a == 0) pc = pc + imm
				NULL;
			when INST_CODE_BNEZ =>
				--BEQZ			//if (a != 0) pc = pc + imm
				NULL;
			when INST_CODE_SLL_SRA =>
				case INST_FUNC is
					when INST_FUNC_SLL =>
					--SLL				//[rs] = A sll imm
						cmd := get_cmd(ALU_SLL, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_FUNC_SRA =>
					--SRA				//[rs] = A sra imm
						cmd := get_cmd(ALU_SRA, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when others =>
						NULL;
				end case;
			when INST_CODE_ADDIU3 =>
				--ADDIU3			//[rt] = A + imm
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RT,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_NONE, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_ADDIU =>
				--ADDIU			//[rs] = A + imm
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_NONE, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_ADDSP_BTEQZ_MTSP =>
				case INST_RS is
					when INST_RS_ADDSP =>
						--ADDSP			//sp = sp + imm
						cmd := get_cmd(ALU_ADD, ALU_A_SRC_SP, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_YES, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_RS_BTEQZ =>
						--BETQZ			//if (T == 0) pc = pc + imm
						NULL;
					when INST_RS_MTSP =>
						--MTSP			//SP = 0 + B
						cmd := get_cmd(ALU_ADD, ALU_A_SRC_ZERO, ALU_B_SRC_B, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_YES, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);	
					when others =>
						NULL;
				end case;
			when INST_CODE_LI =>
				--LI			//[rs] = 0 + imm
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_ZERO, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_NONE, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);					
			when INST_CODE_CMPI =>
				--CMPI		//if (A - imm == 0) T = 0; else t = 1;
				cmd := get_cmd(ALU_SUB, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_YES, T_SRC_IS_NOT_ZF,
									MEM_NONE, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_LW_SP =>
				--LW_SP		//[rs] = MEM[SP+imm]
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_SP, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_READ, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_DM_DATA);
			when INST_CODE_LW =>
				--LW			//[rt] = MEM[A+imm]
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RT,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_READ, WRITE_DM_DATA_SRC_Z,
									WRITE_REGS_YES, REGS_WRITE_DATA_SRC_DM_DATA);
			when INST_CODE_SW_SP =>
				--SW_SP		//MEM[SP+imm] = A
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_SP, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_WRITE, WRITE_DM_DATA_SRC_A,
									WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_SW =>
				--SW			//MEM[A+imm] = B
				cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_IMM, WRITE_REGS_DEST_RS,
									WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
									MEM_WRITE, WRITE_DM_DATA_SRC_B,
									WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
			when INST_CODE_ADDU_SUBU =>
				case INST_FUNC is
					when INST_FUNC_ADDU =>
						--ADDU		//[rd] = A + B
						cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RD,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_FUNC_SUBU =>
						--SUBU		//[rd] = A - B
						cmd := get_cmd(ALU_SUB, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RD,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when others =>
						NULL;
				end case;
			when INST_CODE_AND_TO_SLT =>
				case inst_rd_func is
					when INST_RD_FUNC_AND =>
						--AND				//[rs] = A and B
						cmd := get_cmd(ALU_AND, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);						
					when INST_RD_FUNC_CMP =>
						--CMP				//if (A - B == 0) T = 0; else T = 1;
						cmd := get_cmd(ALU_SUB, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_YES, T_SRC_IS_NOT_ZF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_RD_FUNC_JALR_JR_MFPC =>
						case INST_RT is
							when INST_RT_JALR =>
								--JALR			//PC = A; RA = PC;
								cmd := get_cmd(ALU_NULL, ALU_A_SRC_ZERO, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
													WRITE_RA_YES, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
													MEM_NONE, WRITE_DM_DATA_SRC_Z,
													WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
							when INST_RT_JR =>
								--JR				//PC = A
								NULL;
							when INST_RT_MFPC =>
								--MFPC			//[rs] = PC
								--CHANGE HERE
								cmd := get_cmd(ALU_ADD, ALU_A_SRC_PC, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
													WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
													MEM_NONE, WRITE_DM_DATA_SRC_Z,
													WRITE_REGS_YES, REGS_WRITE_DATA_SRC_PC_REG);
							when others =>
								NULL;
						end case;
					when INST_RD_FUNC_NEG =>
						--NEG			//[rs] = -A
						cmd := get_cmd(ALU_NEG, ALU_A_SRC_A, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_RD_FUNC_OR =>
						--OR			//[rs] = A or B
						cmd := get_cmd(ALU_OR, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when INST_RD_FUNC_SLT =>
						--SLT			//if (A - B < 0) T = 1; else T = 0;
						cmd := get_cmd(ALU_SUB, ALU_A_SRC_A, ALU_B_SRC_B, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_YES, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);
					when others =>
						NULL;
				end case;
			when INST_CODE_MFIH_MTIH =>
				case INST_FUNC is 
					when INST_FUNC_MFIH =>
						--MFIH		//[rs] = IH
						--CHANGE HERE
						cmd := get_cmd(ALU_ADD, ALU_A_SRC_IH, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_NO, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SRC_Z,
											WRITE_REGS_YES, REGS_WRITE_DATA_SRC_IH_REG);
					when INST_FUNC_MTIH =>
						--MTIH		//IH = A + 0
						cmd := get_cmd(ALU_ADD, ALU_A_SRC_A, ALU_B_SRC_ZERO, WRITE_REGS_DEST_RS,
											WRITE_RA_NO, WRITE_IH_YES, WRITE_SP_NO, WRITE_T_NO, T_SRC_IS_SF,
											MEM_NONE, WRITE_DM_DATA_SrC_Z,
											WRITE_REGS_NO, REGS_WRITE_DATA_SRC_ALU_RESULT);						
					when others =>
						NULL;
				end case;
			when others =>
				NULL;
		end case;
		ALU_OP <= cmd.ALU_OP;
		ALU_A_SRC <= cmd.ALU_A_SRC;
		ALU_B_SRC <= cmd.ALU_B_SRC;
		WRITE_REGS_DEST <= cmd.WRITE_REGS_DEST;

		WRITE_RA_OR_NOT <= cmd.WRITE_RA_OR_NOT;
		WRITE_IH_OR_NOT <= cmd.WRITE_IH_OR_NOT;
		WRITE_SP_OR_NOT <= cmd.WRITE_SP_OR_NOT;
		WRITE_T_OR_NOT <= cmd.WRITE_T_OR_NOT;
		WRITE_T_SRC <= cmd.WRITE_T_SRC;

		DATA_MEM_READ_WRITE <= cmd.DATA_MEM_READ_WRITE;
		WRITE_DM_DATA_SRC <= cmd.WRITE_DM_DATA_SRC;
				
		REGS_WRITE_OR_NOT <= cmd.REGS_WRITE_OR_NOT;
		REGS_WRITE_DATA_SRC <= cmd.REGS_WRITE_DATA_SRC;
	end process;
end Behavioral;
