--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package common is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;

type MY_CMD is
	record
		ALU_OP : std_logic_vector(3 downto 0);
		ALU_A_SRC : std_logic_vector(2 downto 0);
		ALU_B_SRC : std_logic_vector(1 downto 0);
		WRITE_REGS_DEST : std_logic_vector(1 downto 0);
		
		WRITE_RA_OR_NOT : std_logic;
		WRITE_IH_OR_NOT : std_logic;
		WRITE_SP_OR_NOT : std_logic;
		WRITE_T_OR_NOT : std_logic;
		WRITE_T_SRC : std_logic;
		
		DATA_MEM_READ_WRITE : std_logic_vector(1 downto 0);
		WRITE_DM_DATA_SRC : std_logic_vector(1 downto 0);		
		
		REGS_WRITE_OR_NOT : std_logic;
		REGS_WRITE_DATA_SRC : std_logic_vector(1 downto 0);
	end record;
--

-- Declare constants
	constant ZERO : std_logic_vector(15 downto 0) := "0000000000000000";
	constant FFFF : std_logic_vector(15 downto 0) := "1111111111111111";
	constant EIGHT : std_logic_vector(15 downto 0) := "0000000000001000";

   constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
   constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
   constant ALU_AND : std_logic_vector(3 downto 0) := "0010";
   constant ALU_OR  : std_logic_vector(3 downto 0) := "0011";
   constant ALU_XOR : std_logic_vector(3 downto 0) := "0100";
   constant ALU_NOT : std_logic_vector(3 downto 0) := "0101";
   constant ALU_SLL : std_logic_vector(3 downto 0) := "0110";
   constant ALU_SRL : std_logic_vector(3 downto 0) := "0111";
   constant ALU_SLA : std_logic_vector(3 downto 0) := "1000";
   constant ALU_SRA : std_logic_vector(3 downto 0) := "1001";
   constant ALU_ROL : std_logic_vector(3 downto 0) := "1010";
   constant ALU_ROR : std_logic_vector(3 downto 0) := "1011";
   constant ALU_NEG : std_logic_vector(3 downto 0) := "1100";
	constant ALU_NULL : std_logic_vector(3 downto 0) := "1111";
		
	constant ZF_TRUE : std_logic := '1';
	constant ZF_FALSE : std_logic := '0';
	
	constant SF_TRUE : std_logic := '1';
	constant SF_FALSE : std_logic := '0';
	
	constant JUMP_TRUE : std_logic := '1';
	constant JUMP_FALSE : std_logic := '0';
	
	constant REG0 : std_logic_vector(2 downto 0) := "000";
	constant REG1 : std_logic_vector(2 downto 0) := "001";
	constant REG2 : std_logic_vector(2 downto 0) := "010";
	constant REG3 : std_logic_vector(2 downto 0) := "011";
	constant REG4 : std_logic_vector(2 downto 0) := "100";
	constant REG5 : std_logic_vector(2 downto 0) := "101";
	constant REG6 : std_logic_vector(2 downto 0) := "110";
	constant REG7 : std_logic_vector(2 downto 0) := "111";
	
	--type 0: last 8 bit, sign_extend
	constant CODE_IMM_0_0 : std_logic_vector(4 downto 0) := "00000";
	constant CODE_IMM_0_1 : std_logic_vector(4 downto 0) := "00100";
	constant CODE_IMM_0_2 : std_logic_vector(4 downto 0) := "00101";
	constant CODE_IMM_0_3 : std_logic_vector(4 downto 0) := "01001";
	constant CODE_IMM_0_4 : std_logic_vector(4 downto 0) := "01100";
	constant CODE_IMM_0_5 : std_logic_vector(4 downto 0) := "01110";
	constant CODE_IMM_0_6 : std_logic_vector(4 downto 0) := "10010";
	constant CODE_IMM_0_7 : std_logic_vector(4 downto 0) := "11010";
	
	--type 1: last 8 bit, zero_extend
	constant CODE_IMM_1 : std_logic_vector(4 downto 0) := "01101";
	
	--type 2: last 5 bit, sign_extend
	constant CODE_IMM_2_0 : std_logic_vector(4 downto 0) := "10011";
	constant CODE_IMM_2_1 : std_logic_vector(4 downto 0) := "11011";
	
	--type 3: last 11 bit, sign_extend
	constant CODE_IMM_3 : std_logic_vector(4 downto 0) := "00010";
	
	--type 4: last 4 bit, sign_extend;
	constant CODE_IMM_4 : std_logic_vector(4 downto 0) := "01000";
	
	--type 5: from 4 downto 2 bit, zero_extend, change 0 to 8
	constant CODE_IMM_5 : std_logic_vector(4 downto 0) := "00110";

--begin of xjl area	
	--controller command
	constant ALU_A_SRC_A : std_logic_vector(2 downto 0) := "000";
	constant ALU_A_SRC_IMM : std_logic_vector(2 downto 0) := "001";
	constant ALU_A_SRC_ZERO : std_logic_vector(2 downto 0) := "010";
	constant ALU_A_SRC_SP : std_logic_vector(2 downto 0) := "011";
	constant ALU_A_SRC_PC : std_logic_vector(2 downto 0) := "100";
	constant ALU_A_SRC_IH : std_logic_vector(2 downto 0) := "101";	
	
	constant ALU_B_SRC_B : std_logic_vector(1 downto 0) := "00";
	constant ALU_B_SRC_IMM : std_logic_vector(1 downto 0) := "01";
	constant ALU_B_SRC_ZERO : std_logic_vector(1 downto 0) := "10";
	
	constant WRITE_REGS_DEST_RS : std_logic_vector(1 downto 0) := "00";
	constant WRITE_REGS_DEST_RT : std_logic_vector(1 downto 0) := "01";
	constant WRITE_REGS_DEST_RD : std_logic_vector(1 downto 0) := "10";

	constant WRITE_DM_DATA_SRC_A : std_logic_vector(1 downto 0) := "00";
	constant WRITE_DM_DATA_SRC_B : std_logic_vector(1 downto 0) := "01";
	constant WRITE_DM_DATA_SRC_Z : std_logic_vector(1 downto 0) := "10";
	
	constant WRITE_RA_YES : std_logic := '1';
	constant WRITE_RA_NO : std_logic := '0';
	
	constant WRITE_IH_YES : std_logic := '1';
	constant WRITE_IH_NO : std_logic := '0';
	
	constant WRITE_T_YES : std_logic := '1';
	constant WRITE_T_NO : std_logic := '0';
	
	constant T_SRC_IS_SF : std_logic := '1';
	constant T_SRC_IS_NOT_ZF : std_logic := '0';
	
	constant WRITE_SP_YES : std_logic := '1';
	constant WRITE_SP_NO : std_logic := '0';
	
	constant MEM_READ : std_logic_vector(1 downto 0) := "00";
	constant MEM_WRITE : std_logic_vector(1 downto 0) := "01";
	constant MEM_NONE : std_logic_vector(1 downto 0) := "10";

	constant WRITE_REGS_YES : std_logic := '1';
	constant WRITE_REGS_NO : std_logic := '0';
	
	constant REGS_WRITE_DATA_SRC_ALU_RESULT : std_logic_vector(1 downto 0) := "00";
	constant REGS_WRITE_DATA_SRC_DM_DATA : std_logic_vector(1 downto 0) := "01";
	constant REGS_WRITE_DATA_SRC_IH_REG : std_logic_vector(1 downto 0) := "10";
	constant REGS_WRITE_DATA_SRC_PC_REG : std_logic_vector(1 downto 0) := "11";	

	-- forward unit command
	constant STALL_YES : std_logic := '1';
	constant STALL_NO : std_logic := '0';
	
	constant ALU_A_SRC_SELECT_FINAL_ORIGIN : std_logic_vector(1 downto 0) := "00";
	constant ALU_A_SRC_SELECT_FINAL_EXE_MEM_REG : std_logic_vector(1 downto 0) := "01";
	constant ALU_A_SRC_SELECT_FINAL_MEM_WB_REG : std_logic_vector(1 downto 0) := "10";
	
	constant ALU_B_SRC_SELECT_FINAL_ORIGIN : std_logic_vector(1 downto 0) := "00";
	constant ALU_B_SRC_SELECT_FINAL_EXE_MEM_REG : std_logic_vector(1 downto 0) := "01";
	constant ALU_B_SRC_SELECT_FINAL_MEM_WB_REG : std_logic_vector(1 downto 0) := "10";	
	
	-- hazard detector command
	constant WRITE_PC_YES : std_logic := '1';
	constant WRITE_PC_NO : std_logic := '0';
	
	constant NEW_PC_SRC_SELEC_PC_ADD_ONE : std_logic_vector(1 downto 0) := "00";
	constant NEW_PC_SRC_SELEC_PC_ADD_IMM : std_logic_vector(1 downto 0) := "01";
	constant NEW_PC_SRC_SELEC_REG_A : std_logic_vector(1 downto 0) := "10";
	
	constant WRITE_IR_YES : std_logic := '1';
	constant WRITE_IR_NO : std_logic := '0';
	constant WRITE_IR_SRC_SELEC_ORIGIN : std_logic := '0';
	constant WRITE_IR_SRC_SELEC_NOP : std_logic := '1';
	
	constant COMMAND_ORIGIN : std_logic := '0';
	constant COMMAND_NOP : std_logic := '1';
	
	constant DM_DATA_RESULT_DM : std_logic := '0';
	constant DM_DATA_RESULT_IM : std_logic := '1';
	
	constant IM_ADDR_PC : std_logic := '0';
	constant IM_ADDR_ALU_RESULT : std_logic := '1';
	
	constant IM_DATA_Z : std_logic := '0';
	constant IM_DATA_ALU_RESULT : std_logic := '1';
	
	-- data constant
	constant HIGH_RESIST : std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
	
	constant INST_DATA_MEM_ADDR_EDGE : integer := 32768;
	
	constant NOP_INST : std_logic_vector(15 downto 0) := "0000100000000000";
	constant COM_STATUS_ADDR : std_logic_vector(15 downto 0) := "1011111100000001";
	constant COM_DATA_ADDR : std_logic_vector(15 downto 0) := "1011111100000000";
	constant DATA_MEM_BEGIN : std_logic_vector(15 downto 0) := "1000000000000000";
	--constant DEFAULT_VALUE : std_logic_vector(15 downto 0) := "";
	
	-- instruction type distinct constant
	constant INST_CODE_ADDSP3 : std_logic_vector(4 downto 0) := "00000";
	
	constant INST_CODE_NOP : std_logic_vector(4 downto 0) := "00001";
	
	constant INST_CODE_B : std_logic_vector(4 downto 0) := "00010";
	
	constant INST_CODE_BEQZ : std_logic_vector(4 downto 0) := "00100";
	
	constant INST_CODE_BNEZ : std_logic_vector(4 downto 0) := "00101";
	
	constant INST_CODE_SLL_SRA : std_logic_vector(4 downto 0) := "00110";
		constant INST_FUNC_SLL : std_logic_vector(1 downto 0) := "00";
		constant INST_FUNC_SRA : std_logic_vector(1 downto 0) := "11";
	
	constant INST_CODE_ADDIU3 : std_logic_vector(4 downto 0) := "01000";
	
	constant INST_CODE_ADDIU : std_logic_vector(4 downto 0) := "01001";
	
	constant INST_CODE_ADDSP_BTEQZ_MTSP : std_logic_vector(4 downto 0) := "01100";
		constant INST_RS_ADDSP : std_logic_vector(2 downto 0) := "011";
		constant INST_RS_BTEQZ : std_logic_vector(2 downto 0) := "000";
		constant INST_RS_MTSP : std_logic_vector(2 downto 0) := "100";
	
	constant INST_CODE_LI : std_logic_vector(4 downto 0) := "01101";
	
	constant INST_CODE_CMPI : std_logic_vector(4 downto 0) := "01110";
	
	constant INST_CODE_LW_SP : std_logic_vector(4 downto 0) := "10010";
	
	constant INST_CODE_LW : std_logic_vector(4 downto 0) := "10011";
	
	constant INST_CODE_SW_SP : std_logic_vector(4 downto 0) := "11010";
	
	constant INST_CODE_SW : std_logic_vector(4 downto 0) := "11011";
	
	constant INST_CODE_ADDU_SUBU : std_logic_vector(4 downto 0) := "11100";
		constant INST_FUNC_ADDU : std_logic_vector(1 downto 0) := "01";
		constant INST_FUNC_SUBU : std_logic_vector(1 downto 0) := "11";
	
	constant INST_CODE_AND_TO_SLT : std_logic_vector(4 downto 0) := "11101";
		constant INST_RD_FUNC_AND : std_logic_vector(4 downto 0) := "01100"; 
		constant INST_RD_FUNC_CMP : std_logic_vector(4 downto 0) := "01010";
		constant INST_RD_FUNC_JALR_JR_MFPC : std_logic_vector(4 downto 0) := "00000";
			constant INST_RT_JALR : std_logic_vector(2 downto 0) := "110";
			constant INST_RT_JR : std_logic_vector(2 downto 0) := "000";
			constant INST_RT_MFPC : std_logic_vector(2 downto 0) := "010";
		constant INST_RD_FUNC_NEG : std_logic_vector(4 downto 0) := "01011"; 
		constant INST_RD_FUNC_OR : std_logic_vector(4 downto 0) := "01101"; 
		constant INST_RD_FUNC_SLT : std_logic_vector(4 downto 0) := "00010"; 
	
	constant INST_CODE_MFIH_MTIH : std_logic_vector(4 downto 0) := "11110";
		constant INST_FUNC_MFIH : std_logic_vector(1 downto 0) := "00";
		constant INST_FUNC_MTIH : std_logic_vector(1 downto 0) := "01";
	
	
--end of xjl area

-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
	function get_cmd (
		ALU_OP : in std_logic_vector(3 downto 0);
		ALU_A_SRC : in std_logic_vector(2 downto 0);
		ALU_B_SRC : in std_logic_vector(1 downto 0);
		WRITE_REGS_DEST : in std_logic_vector(1 downto 0);
		
		WRITE_RA_OR_NOT : in std_logic;
		WRITE_IH_OR_NOT : in std_logic;
		WRITE_SP_OR_NOT : in std_logic;
		WRITE_T_OR_NOT : in std_logic;
		WRITE_T_SRC : in std_logic;
		
		DATA_MEM_READ_WRITE : in std_logic_vector(1 downto 0);
		WRITE_DM_DATA_SRC : in std_logic_vector(1 downto 0);		
		
		REGS_WRITE_OR_NOT : in std_logic;
		REGS_WRITE_DATA_SRC : in std_logic_vector(1 downto 0)
	) return MY_CMD;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end common;

package body common is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

	function get_cmd (
		ALU_OP : in std_logic_vector(3 downto 0);
		ALU_A_SRC : in std_logic_vector(2 downto 0);
		ALU_B_SRC : in std_logic_vector(1 downto 0);
		WRITE_REGS_DEST : in std_logic_vector(1 downto 0);
		
		WRITE_RA_OR_NOT : in std_logic;
		WRITE_IH_OR_NOT : in std_logic;
		WRITE_SP_OR_NOT : in std_logic;
		WRITE_T_OR_NOT : in std_logic;
		WRITE_T_SRC : in std_logic;
		
		DATA_MEM_READ_WRITE : in std_logic_vector(1 downto 0);
		WRITE_DM_DATA_SRC : in std_logic_vector(1 downto 0);		
		
		REGS_WRITE_OR_NOT : in std_logic;
		REGS_WRITE_DATA_SRC : in std_logic_vector(1 downto 0)
	) return MY_CMD is
		variable cmd : MY_CMD;
	begin
		cmd.ALU_OP := ALU_OP;
		cmd.ALU_A_SRC := ALU_A_SRC;
		cmd.ALU_B_SRC := ALU_B_SRC;
		cmd.WRITE_REGS_DEST := WRITE_REGS_DEST;

		cmd.WRITE_RA_OR_NOT := WRITE_RA_OR_NOT;
		cmd.WRITE_IH_OR_NOT := WRITE_IH_OR_NOT;
		cmd.WRITE_SP_OR_NOT := WRITE_SP_OR_NOT;
		cmd.WRITE_T_OR_NOT := WRITE_T_OR_NOT;
		cmd.WRITE_T_SRC := WRITE_T_SRC;

		cmd.DATA_MEM_READ_WRITE := DATA_MEM_READ_WRITE;
		cmd.WRITE_DM_DATA_SRC := WRITE_DM_DATA_SRC;
				
		cmd.REGS_WRITE_OR_NOT := REGS_WRITE_OR_NOT;
		cmd.REGS_WRITE_DATA_SRC := REGS_WRITE_DATA_SRC;
		
		return cmd;
	end get_cmd;


---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end common;
