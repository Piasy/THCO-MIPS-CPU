----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:28:54 11/19/2013 
-- Design Name: 
-- Module Name:    CPU_CORE - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_CORE is
    Port ( CLK_IN : in  STD_LOGIC;
           RAM1_Addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1_EN : out  STD_LOGIC;
           RAM1_WE : out  STD_LOGIC;
           RAM1_OE : out  STD_LOGIC;
           RAM1_Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM2_Addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2_EN : out  STD_LOGIC;
           RAM2_WE : out  STD_LOGIC;
           RAM2_OE : out  STD_LOGIC;
           RAM2_Data : inout  STD_LOGIC_VECTOR (15 downto 0);
		   com_data_ready : in STD_LOGIC;
		   com_rdn : out STD_LOGIC;
		   com_tbre : in STD_LOGIC;
		   com_tsre : in STD_LOGIC;
		   com_wrn : out STD_LOGIC;
		   DISP1 : inout std_logic_vector(6 downto 0) := "0111111";
		   DISP2 : inout std_logic_vector(6 downto 0) := "0111111";
           LED : out  STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000");
end CPU_CORE;

architecture Behavioral of CPU_CORE is
	COMPONENT CLK_MODULE
    Port ( CLK_IN : in STD_LOGIC;
           CLK : inout STD_LOGIC
	);
	END COMPONENT;

	COMPONENT PC_Register
    Port ( PC_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
		   WRITE_OR_NOT : in STD_LOGIC;
		   CLK : in STD_LOGIC
         );
    END COMPONENT;

	COMPONENT MUX_2
    Port ( SELEC : in  STD_LOGIC;
           SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
    END COMPONENT;
	
	COMPONENT MUX_3
    Port ( SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_3 : in  STD_LOGIC_VECTOR (15 downto 0);
           SELEC : in  STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
    END COMPONENT;
	
	COMPONENT MUX_4
    Port ( SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_3 : in  STD_LOGIC_VECTOR (15 downto 0);
           SRC_4 : in  STD_LOGIC_VECTOR (15 downto 0);
           SELEC : in  STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0));
    END COMPONENT;
	
	COMPONENT MUX_6
    Port ( SRC_1 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_2 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_3 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_4 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
		   SRC_5 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SRC_6 : in  STD_LOGIC_VECTOR (15 downto 0) := ZERO;
           SELEC : in  STD_LOGIC_VECTOR (2 downto 0) := "111";
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0) := ZERO
	);
	END COMPONENT;
	
	COMPONENT RAM1_Visitor
	port(

	---input
		clk:in std_logic;
		
		DMemReadWrite : in std_logic_vector(1 downto 0);
		
		EXandMEM_AluRes: in std_logic_vector(15 downto 0);

		DataReady: in std_logic;	
		
		WriteData: in std_logic_vector(15 downto 0);
		
		TSRE: in std_logic;
		TBRE: in std_logic;
		
		
	---output
	
		
				
	
		RAM1_Enable: out std_logic;
		RAM1_ReadEnable: out std_logic;
		RAM1_WriteEnable: out std_logic;

		SPort_WriteEnable:out std_logic;
		SPort_ReadEnable: out std_logic;


		DMemData:inout std_logic_vector(15 downto 0);
		DMemAddr: out std_logic_vector(15 downto 0)


		);
    END COMPONENT;
	
	COMPONENT RAM2_Visitor
	port(

	---input
		clk:in std_logic;
		
		DMemReadWrite : in std_logic_vector(1 downto 0);
		
		EXandMEM_AluRes: in std_logic_vector(15 downto 0);
		WriteData: in std_logic_vector(15 downto 0);
	---output
	
		RAM2_Enable: out std_logic := '1';
		RAM2_ReadEnable: out std_logic := '1';
		RAM2_WriteEnable: out std_logic := '1';
		DMemData:inout std_logic_vector(15 downto 0);
		DMemAddr: out std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT PC_Adder
    Port ( OLD_PC : in  STD_LOGIC_VECTOR (15 downto 0);
           NEW_PC : out  STD_LOGIC_VECTOR (15 downto 0)
		   );
    END COMPONENT;
	
	COMPONENT IF_ID_Register
    Port ( NEW_PC_IN : in  STD_LOGIC_VECTOR (15 downto 0);
		   WRITE_PC_OR_NOT : in STD_LOGIC;
           NEW_PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
           CLK : in  STD_LOGIC;
		   INST_IN : in  STD_LOGIC_VECTOR (15 downto 0);
		   
           WRITE_IR_OR_NOT : in  STD_LOGIC;
           WRITE_IR_SRC_SELEC : in  STD_LOGIC;
		   
		   INST_OUT_CODE : out STD_LOGIC_VECTOR(4 downto 0);
		   INST_OUT_RS : out STD_LOGIC_VECTOR(2 downto 0);
		   INST_OUT_RT : out STD_LOGIC_VECTOR(2 downto 0);
		   INST_OUT_RD : out STD_LOGIC_VECTOR(2 downto 0);
		   INST_OUT_FUNC : out STD_LOGIC_VECTOR(1 downto 0));
    END COMPONENT;
	
	COMPONENT Imm_Extend
	port(
		code : in STD_LOGIC_VECTOR(4 downto 0);
		rs : in STD_LOGIC_VECTOR(2 downto 0);
		rt : in STD_LOGIC_VECTOR(2 downto 0);
		rd : in STD_LOGIC_VECTOR(2 downto 0);
		func : in STD_LOGIC_VECTOR(1 downto 0);
		
		imm : out STD_LOGIC_VECTOR(15 downto 0)
	);
    END COMPONENT;
	
	COMPONENT adder
	port(
		pc : in STD_LOGIC_VECTOR(15 downto 0);
		imm : in STD_LOGIC_VECTOR(15 downto 0);
		res : out STD_LOGIC_VECTOR(15 downto 0)
	);
    END COMPONENT;
	
	COMPONENT Hazard_Detector
    Port ( STALL_OR_NOT_FU : in STD_LOGIC;
           
		   CUR_INST_CODE : in  STD_LOGIC_VECTOR (4 downto 0);
           CUR_INST_RS : in  STD_LOGIC_VECTOR (2 downto 0);
           CUR_INST_RT : in  STD_LOGIC_VECTOR (2 downto 0);
           CUR_INST_RD : in  STD_LOGIC_VECTOR (2 downto 0);
           CUR_INST_FUNC : in  STD_LOGIC_VECTOR (1 downto 0);
           
		   LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC;
           LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0);
		   LAST_VISIT_DM_OR_NOT : in STD_LOGIC_VECTOR(1 downto 0);
           
		   LAST_LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC;
           LAST_LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0);
           
		   LAST_LAST_VISIT_DM_OR_NOT : in STD_LOGIC_VECTOR(1 downto 0);
		   LAST_LAST_DM_VISIT_ADDR : in  STD_LOGIC_VECTOR (15 downto 0);
		   
		   CUR_DM_READ_WRITE : in STD_LOGIC_VECTOR(1 downto 0);
		   CUR_DM_WRITE_DATA_SRC : in STD_LOGIC_VECTOR(1 downto 0);
		   		   
		   JUMP_OR_NOT : in STD_LOGIC;
           
		   WRITE_PC_OR_NOT : out  STD_LOGIC;
           NEW_PC_SRC_SELEC : out  STD_LOGIC_VECTOR (1 downto 0);
           WRITE_IR_OR_NOT : out  STD_LOGIC;
           WRITE_IR_SRC_SELEC : out  STD_LOGIC;
           COMMAND_ORIGIN_OR_NOP : out  STD_LOGIC;
		   
		   DM_DATA_RESULT_SELEC : out STD_LOGIC;
		   IM_ADDR_SELEC : out STD_LOGIC;
		   IM_DATA_SELEC : out STD_LOGIC;
		   IM_READ_WRITE_SELEC : out STD_LOGIC_VECTOR(1 downto 0)
		);
    END COMPONENT;
	
	COMPONENT Controller
    Port ( INST_CODE : in STD_LOGIC_VECTOR(4 downto 0);
		   INST_RS : in STD_LOGIC_VECTOR(2 downto 0);
		   INST_RT : in STD_LOGIC_VECTOR(2 downto 0);
		   INST_RD : in STD_LOGIC_VECTOR(2 downto 0);
		   INST_FUNC : in STD_LOGIC_VECTOR(1 downto 0);
           ALU_OP : out  STD_LOGIC_VECTOR (3 downto 0);
           ALU_A_SRC : out  STD_LOGIC_VECTOR (2 downto 0);
           ALU_B_SRC : out  STD_LOGIC_VECTOR (1 downto 0);
           WRITE_REGS_DEST : out  STD_LOGIC_VECTOR (1 downto 0);
           WRITE_DM_DATA_SRC : out  STD_LOGIC_VECTOR (1 downto 0);
           WRITE_RA_OR_NOT : out  STD_LOGIC;
           WRITE_IH_OR_NOT : out  STD_LOGIC;
           WRITE_T_OR_NOT : out  STD_LOGIC;
           WRITE_SP_OR_NOT : out  STD_LOGIC;
           WRITE_T_SRC : out  STD_LOGIC;
           DATA_MEM_READ_WRITE : out  STD_LOGIC_VECTOR(1 downto 0);
           REGS_WRITE_OR_NOT : out  STD_LOGIC;
           REGS_WRITE_DATA_SRC : out  STD_LOGIC_VECTOR (1 downto 0));
    END COMPONENT;
	
	COMPONENT Common_Register
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
    END COMPONENT;
	
	COMPONENT Comparator
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
    END COMPONENT;
	
	COMPONENT ID_EXE_Register
	port(
		clk : in STD_LOGIC;

		--cmd cmd
		command_origin_or_nop : in STD_LOGIC;
		
		--common input
		in_pc : in STD_LOGIC_VECTOR(15 downto 0);
		in_reg_a : in STD_LOGIC_VECTOR(15 downto 0);
		in_reg_b : in STD_LOGIC_VECTOR(15 downto 0);
		in_imm : in STD_LOGIC_VECTOR(15 downto 0);
		
		in_rs : in STD_LOGIC_VECTOR(2 downto 0);
		in_rt : in STD_LOGIC_VECTOR(2 downto 0);
		in_rd : in STD_LOGIC_VECTOR(2 downto 0);
		
		--exe cmd
		in_alu : in STD_LOGIC_VECTOR(3 downto 0);
		in_a_src : in STD_LOGIC_VECTOR(2 downto 0);
		in_b_src : in STD_LOGIC_VECTOR(1 downto 0);
		in_reg_result : in STD_LOGIC_VECTOR(1 downto 0);
		in_mem_src : in STD_LOGIC_VECTOR(1 downto 0);
		in_flag_RA : in STD_LOGIC;
		in_flag_IH : in STD_LOGIC;
		in_flag_T : in STD_LOGIC;
		in_flag_SP : in STD_LOGIC;
		in_T_src : in STD_LOGIC;
		
		--mem cmd
		in_mem_cmd : in STD_LOGIC_VECTOR(1 downto 0);
		
		--wb cmd
		in_flag_reg : in STD_LOGIC;
		in_reg_src : in STD_LOGIC_VECTOR(1 downto 0);

		--common output
		out_pc : out STD_LOGIC_VECTOR(15 downto 0);
		out_imm : out STD_LOGIC_VECTOR(15 downto 0);
		out_reg_a : out STD_LOGIC_VECTOR(15 downto 0);
		out_reg_b : out STD_LOGIC_VECTOR(15 downto 0);
		
		--memory data
		out_mem_data : out STD_LOGIC_VECTOR(15 downto 0);
		
		--result register
		out_res_reg : out STD_LOGIC_VECTOR(2 downto 0);
		
		--exe cmd
		out_alu : out STD_LOGIC_VECTOR(3 downto 0);
		out_a_src : out STD_LOGIC_VECTOR(2 downto 0);
		out_b_src : out STD_LOGIC_VECTOR(1 downto 0);
		out_flag_RA : out STD_LOGIC;
		out_flag_IH : out STD_LOGIC;
		out_flag_T : out STD_LOGIC;
		out_flag_SP : out STD_LOGIC;
		out_T_src : out STD_LOGIC;
		
		--mem cmd
		out_mem_cmd : out STD_LOGIC_VECTOR(1 downto 0);
		
		--wb cmd
		out_flag_reg : out STD_LOGIC;
		out_reg_src : out STD_LOGIC_VECTOR(1 downto 0);
		
		cur_rs_num : out STD_LOGIC_VECTOR(2 downto 0);
		cur_rt_num : out STD_LOGIC_VECTOR(2 downto 0)
	);
    END COMPONENT;
	
	COMPONENT alu
	port(
		a : in STD_LOGIC_VECTOR(15 downto 0);
		b : in STD_LOGIC_VECTOR(15 downto 0);
		op : in STD_LOGIC_VECTOR(3 downto 0);

		zf : out STD_LOGIC;
		sf : out STD_LOGIC;
		c : out STD_LOGIC_VECTOR(15 downto 0)
	);
    END COMPONENT;
	
	COMPONENT Special_Register
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
		
		T_value : out STD_LOGIC_VECTOR(15 downto 0);
		RA_value : out STD_LOGIC_VECTOR(15 downto 0);
		IH_value : out STD_LOGIC_VECTOR(15 downto 0);
		SP_value : out STD_LOGIC_VECTOR(15 downto 0)
	);
    END COMPONENT;
	
	COMPONENT Forward_Unit
    Port ( -- current instruction info, if use reg as alu src, conflict may exist
		   CUR_RS_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0);
           CUR_RT_REG_NUM : in  STD_LOGIC_VECTOR (2 downto 0);
		   CUR_ALU_A_SRC_SELECT : in STD_LOGIC_VECTOR (2 downto 0);
		   CUR_ALU_B_SRC_SELECT : in STD_LOGIC_VECTOR (1 downto 0);
		   
		   -- last instruction info, if write regs, conflict may exist, if read DM, must stall
		   LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC;
		   LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0);
           LAST_DM_READ_WRITE : in  STD_LOGIC_VECTOR(1 downto 0);
		   
		   -- last last instruction info, if write regs, conflict may exist
           LAST_LAST_WRITE_REGS_OR_NOT : in  STD_LOGIC;
           LAST_LAST_WRITE_REGS_TARGET : in  STD_LOGIC_VECTOR (2 downto 0);
		   
           STALL_OR_NOT : out  STD_LOGIC;
           ALU_A_SRC_SELECT_FINAL : out  STD_LOGIC_VECTOR (1 downto 0);
           ALU_B_SRC_SELECT_FINAL : out  STD_LOGIC_VECTOR (1 downto 0));
    END COMPONENT;

	COMPONENT EXE_MEM_Register
    Port ( CLK : in  STD_LOGIC;
           
		   NEW_PC_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           WRITE_DM_DATA_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           WRITE_REG_NUM_IN : in  STD_LOGIC_VECTOR (2 downto 0);
           ALU_RESULT_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           IH_REG_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           
		   DATA_MEM_READ_WRITE_IN : in  STD_LOGIC_VECTOR(1 downto 0);
           REGS_READ_WRITE_IN : in  STD_LOGIC;
           REGS_WRITE_DATA_SRC_IN : in  STD_LOGIC_VECTOR (1 downto 0);
		   
		   NEW_PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
		   WRITE_DM_DATA_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
		   WRITE_REG_NUM_OUT : out  STD_LOGIC_VECTOR (2 downto 0);
		   ALU_RESULT_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
		   IH_REG_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
		   
		   DATA_MEM_READ_WRITE_OUT : out  STD_LOGIC_VECTOR(1 downto 0);
           REGS_READ_WRITE_OUT : out  STD_LOGIC;
           REGS_WRITE_DATA_SRC_OUT : out  STD_LOGIC_VECTOR (1 downto 0));
    END COMPONENT;
	
	COMPONENT MEM_WB_Register
    Port ( CLK : in STD_LOGIC;
	
		   NEW_PC_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           WRITE_REGS_NUM_IN : in  STD_LOGIC_VECTOR (2 downto 0);
           ALU_RESULT_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           IH_REG_IN : in  STD_LOGIC_VECTOR (15 downto 0);
           DM_DATA_IN : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           REGS_READ_WRITE_IN : in  STD_LOGIC;
           REGS_WRITE_DATA_SRC_IN : in  STD_LOGIC_VECTOR (1 downto 0);
			  
           NEW_PC_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
           WRITE_REGS_NUM_OUT : out  STD_LOGIC_VECTOR (2 downto 0);
           ALU_RESULT_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
           IH_REG_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
           DM_DATA_OUT : out  STD_LOGIC_VECTOR (15 downto 0);
			  
           REGS_READ_WRITE_OUT : out  STD_LOGIC;
           REGS_WRITE_DATA_SRC_OUT : out  STD_LOGIC_VECTOR (1 downto 0));
    END COMPONENT;

--controller, all to id/exe reg
	signal alu_op_controller : std_logic_vector(3 downto 0) := ALU_NULL;
	signal alu_a_src_select_controller : std_logic_vector(2 downto 0) := ALU_A_SRC_ZERO;
	signal alu_b_src_select_controller : std_logic_vector(1 downto 0) := ALU_B_SRC_ZERO;
	signal write_regs_dest_select_controller : std_logic_vector(1 downto 0) := WRITE_REGS_DEST_RS;
	signal write_dm_data_src_select_controller : std_logic_vector(1 downto 0) := WRITE_DM_DATA_SRC_Z;
	signal write_ra_or_not_select_controller : std_logic := WRITE_RA_NO;
	signal write_ih_or_not_select_controller : std_logic := WRITE_IH_NO;
	signal write_t_or_not_select_controller : std_logic := WRITE_T_NO;
	signal write_sp_or_not_select_controller : std_logic := WRITE_SP_NO;
	signal write_t_src_select_controller : std_logic := T_SRC_IS_SF;
	signal data_mem_read_write_select_controller : std_logic_vector(1 downto 0) := MEM_NONE;							
	signal regs_read_write_select_controller : std_logic := WRITE_REGS_NO;						
	signal regs_write_data_src_select_controller : std_logic_vector(1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
	
-- hazard detector 
	-- to PC reg
	signal write_pc_or_not_hazard_detector : std_logic := WRITE_PC_YES;
	-- to PC mux
	signal new_pc_src_select_hazard_detector : std_logic_vector(1 downto 0) := NEW_PC_SRC_SELEC_PC_ADD_ONE;
	-- to if/id reg
	signal write_ir_or_not_hazard_detector : std_logic := WRITE_IR_YES;
	signal write_ir_src_select_hazard_detector : std_logic := WRITE_IR_SRC_SELEC_ORIGIN;
	-- to id/exe reg
	signal command_origin_or_nop_hazard_detector : std_logic := COMMAND_ORIGIN;
	-- to mem/wb reg
	signal dm_visit_data_result_select_hazard_detector : std_logic := DM_DATA_RESULT_DM;
	-- to im
	signal im_visit_data_select_hazard_detector : std_logic :=IM_DATA_Z;
	signal im_visit_addr_select_hazard_detector : std_logic := IM_ADDR_PC;
	signal im_read_write_select_hazard_detector : std_logic_vector(1 downto 0) := MEM_READ;	
	
-- forward unit  
	-- to hazard detector
	signal stall_or_not_forward_unit : std_logic := STALL_NO;
	-- to alu a src mux 2
	signal alu_a_src_select_final_forward_unit : std_logic_vector(1 downto 0) := ALU_A_SRC_SELECT_FINAL_ORIGIN;
	-- to alu b src mux 2
	signal alu_b_src_select_final_forward_unit : std_logic_vector(1 downto 0) := ALU_B_SRC_SELECT_FINAL_ORIGIN;
	
-- comparator
	-- to hazard detector
	signal jump_or_not_comparator : std_logic := JUMP_FALSE;
	
-- if
	-- PC to IM, PC Adder
	signal pc_value_pc_reg_to_im : std_logic_vector(15 downto 0) := ZERO;
	-- PC Adder to if/id reg, PC mux
	signal pc_value_pc_adder_to_if_id_reg : std_logic_vector(15 downto 0) := ZERO;
	-- IM to if/id reg
	signal inst_im_to_if_id_reg : std_logic_vector(15 downto 0) := HIGH_RESIST;
	-- PC mux to PC
	signal pc_value_pc_mux_to_pc : std_logic_vector(15 downto 0) := ZERO;
	
-- id
	-- if/id reg to controller, imm extender, id/exe reg(rs, rt, rd), 
	--comparator(code), hazard detector, common regs(rs, st)
	signal inst_code_if_id_reg_to_controller : std_logic_vector(4 downto 0) := NOP_INST(15 downto 11);
	signal inst_rs_if_id_reg_to_controller : std_logic_vector(2 downto 0) := NOP_INST(10 downto 8);
	signal inst_rt_if_id_reg_to_controller : std_logic_vector(2 downto 0) := NOP_INST(7 downto 5);
	signal inst_rd_if_id_reg_to_controller : std_logic_vector(2 downto 0) := NOP_INST(4 downto 2);
	signal inst_func_if_id_reg_to_controller : std_logic_vector(1 downto 0) := NOP_INST(1 downto 0);
	-- if/id reg to id/exe reg, PC IMM Adder, to special regs(RA)
	signal pc_value_if_id_reg_to_id_exe_reg : std_logic_vector(15 downto 0) := ZERO;
	-- imm extender to id/exe reg, PC IMM Adder
	signal imm_imm_extend_to_id_exe_reg : std_logic_vector(15 downto 0) := ZERO;
	-- PC IMM Adder to PC mux
	signal pc_value_pc_imm_adder_to_pc_mux : std_logic_vector(15 downto 0) := ZERO;
	-- common regs to id/exe reg, comparator(A), PC mux(A)
	signal a_reg_common_regs_to_id_exe_reg : std_logic_vector(15 downto 0) := ZERO;
	signal b_reg_common_regs_to_id_exe_reg : std_logic_vector(15 downto 0) := ZERO;
	-- if/id reg to im
	--signal inst_if_id_reg_to_im : std_logic_vector(15 downto 0) := HIGH_RESIST;
	-- if/id reg to forward unit
	signal cur_rs_num_if_id_reg_to_forward_unit : std_logic_vector(2 downto 0) := "ZZZ";
	signal cur_rt_num_if_id_reg_to_forward_unit : std_logic_vector(2 downto 0) := "ZZZ";
	
-- exe	
	-- id/exe reg to alu src mux 1
	signal alu_a_src_select_id_exe_reg_to_alu_a_src_mux_1 : std_logic_vector(2 downto 0) := ALU_A_SRC_ZERO;
	signal alu_b_src_select_id_exe_reg_to_alu_b_src_mux_1 : std_logic_vector(1 downto 0) := ALU_B_SRC_ZERO;
	signal a_reg_id_exe_reg_to_alu_a_src_mux_1 : std_logic_vector(15 downto 0) := ZERO;
	signal b_reg_id_exe_reg_to_alu_a_src_mux_1 : std_logic_vector(15 downto 0) := ZERO;
	signal imm_id_exe_reg_to_alu_src_mux_1 : std_logic_vector(15 downto 0) := ZERO;
	-- id/exe reg to exe/mem reg
	signal pc_value_id_exe_reg_to_exe_mem_reg : std_logic_vector(15 downto 0) := ZERO;
	signal write_dm_data_id_exe_reg_to_exe_mem_reg : std_logic_vector(15 downto 0) := HIGH_RESIST;
	signal regs_read_write_select_id_exe_reg_to_exe_mem_reg : std_logic := WRITE_REGS_NO;
	signal write_regs_num_id_exe_reg_to_exe_mem_reg : std_logic_vector(2 downto 0) := "ZZZ";
	signal regs_write_data_src_select_id_exe_reg_to_exe_mem_reg : std_logic_vector(1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
	signal data_mem_read_write_select_id_exe_reg_to_exe_mem_reg : std_logic_vector(1 downto 0) := MEM_NONE;
	
	-- id/exe reg to alu
	signal alu_op_id_exe_reg_to_alu : std_logic_vector(3 downto 0) := ALU_NULL;
	-- id/exe to special regs, to comparator(write t or not)
	signal write_t_or_not_select_id_exe_reg_to_special_regs : std_logic := WRITE_T_NO;
	signal write_t_src_select_id_exe_reg_to_special_regs : std_logic := T_SRC_IS_SF;
	signal write_ra_or_not_select_id_exe_reg_to_special_regs : std_logic := WRITE_RA_NO;
	signal write_ih_or_not_select_id_exe_reg_to_special_regs : std_logic := WRITE_IH_NO;
	signal write_sp_or_not_select_id_exe_reg_to_special_regs : std_logic := WRITE_SP_NO;
	-- constant to alu src mux 1
	signal all_zeros : std_logic_vector(15 downto 0) := ZERO;
	-- special regs to alu src mux 1(SP)
	signal sp_reg_special_regs_to_alu_a_src_mux_1 : std_logic_vector(15 downto 0) := ZERO;
	-- special regs to exe/mem reg(IH)
	signal ih_reg_special_regs_to_exe_mem_reg : std_logic_vector(15 downto 0) := ZERO;
	-- special regs to comparator(T)
	signal t_reg_special_regs_to_exe_mem_reg : std_logic_vector(15 downto 0) := ZERO;
	-- alu src mux 1 to alu src mux 2
	signal alu_a_src_value_mux1_to_mux2 : std_logic_vector(15 downto 0) := ZERO;
	signal alu_b_src_value_mux1_to_mux2 : std_logic_vector(15 downto 0) := ZERO;
	-- alu mux 2 to alu
	signal alu_a_src_alu_mux2_to_alu : std_logic_vector(15 downto 0) := ZERO;
	signal alu_b_src_alu_mux2_to_alu : std_logic_vector(15 downto 0) := ZERO;
	-- alu to exe/mem reg
	signal alu_result_alu_to_exe_mem_reg : std_logic_vector(15 downto 0) := ZERO;
	-- alu to special regs(T)
	signal alu_sf_alu_to_special_regs : std_logic := '0';
	signal alu_zf_alu_to_special_regs : std_logic := '0';
	
-- mem in exe/mem reg 
	-- to RAM_Visitor
	signal data_mem_read_write_select_exe_mem_reg_to_dm : std_logic_vector(1 downto 0) := MEM_NONE;
	-- as data memory address, to mem/wb reg
	signal alu_result_exe_mem_reg_to_dm : std_logic_vector(15 downto 0) := ZERO;
	-- as data memory data, to mem/wb reg
	signal write_dm_data_exe_mem_reg_to_dm : std_logic_vector(15 downto 0) := HIGH_RESIST;
	-- to mem/wb reg
	signal regs_read_write_select_exe_mem_reg_to_mem_wb_reg : std_logic := WRITE_REGS_NO;
	signal write_regs_num_exe_mem_reg_to_mem_wb_reg : std_logic_vector(2 downto 0) := "ZZZ";
	signal regs_write_data_src_select_exe_mem_reg_to_mem_wb_reg : std_logic_vector(1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
	signal ih_reg_exe_mem_reg_to_mem_wb_reg : std_logic_vector(15 downto 0) := ZERO;
	signal pc_value_exe_mem_reg_mem_wb_reg : std_logic_vector(15 downto 0) := ZERO;
	-- lw/sw to IM
	signal im_visit_addr_im_mux_to_im : std_logic_vector(15 downto 0);
	signal im_visit_data_im_mux_to_im : std_logic_vector(15 downto 0);
	
-- DM to mem/wb reg
	signal read_dm_data_dm_to_mem_wb_reg : std_logic_vector(15 downto 0);
	signal dm_visit_data_dm_mux_to_mem_wb_reg : std_logic_vector(15 downto 0);

	
-- wb in mem/wb reg
	-- to common regs write src mux
	signal ih_reg_mem_wb_reg_to_common_regs_write_src_mux : std_logic_vector(15 downto 0) := ZERO;
	signal alu_result_mem_wb_reg_to_common_regs_write_src_mux : std_logic_vector(15 downto 0) := ZERO;
		--alse to special regs(IH, SP)
	signal dm_data_mem_wb_reg_to_common_regs_write_src_mux : std_logic_vector(15 downto 0) := ZERO;
		-- also to alu src mux 2
	signal pc_value_mem_wb_reg_to_common_regs_write_src_mux : std_logic_vector(15 downto 0) := ZERO;
	signal regs_write_data_src_select_mem_wb_reg_to_common_regs_write_src_mux : std_logic_vector(1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
	-- to common regs
	signal regs_read_write_select_mem_wb_reg_to_common_regs : std_logic := WRITE_REGS_NO;
	signal write_regs_num_mem_wb_reg_to_common_regs : std_logic_vector(2 downto 0) := "ZZZ";
	-- common regs write src mux to common regs
	signal write_regs_data_src_mux_to_regs : std_logic_vector(15 downto 0) := ZERO;
	
-- not used
	signal ra_reg_special_regs_to_where : std_logic_vector(15 downto 0) := ZERO;
	signal watch_info : std_logic_vector(15 downto 0) := ZERO;
	signal high_resist_port : std_logic_vector(15 downto 0) := HIGH_RESIST;
	-- signal write_pc_force : std_logic := '1';
	-- signal write_ir_force : std_logic := '1';
	-- signal write_ir_origin_force : std_logic := '0';
	-- signal write_pc_add_one_force : std_logic_vector(1 downto 0) := "00";
	signal led_ram_visitor_to_cpu_core : std_logic_vector(7 downto 0) := "00000000";
	signal useless_pin : std_logic_vector(4 downto 0) := "11111";
	signal CLK : std_logic := '1';
--	signal step_disp1 : std_logic_vector(6 downto 0) := "0111111";
--	signal step_disp1 : std_logic_vector(6 downto 0) := "0111111";
	
begin
	Unit_CLK_MODULE : CLK_MODULE port map (
		CLK_IN => CLK_IN,
		CLK => CLK
	);

	Unit_New_PC_Src_Mux3 : MUX_3 port map (
		-- PC + 1
		SRC_1 => pc_value_pc_adder_to_if_id_reg,
		-- PC + IMM
		SRC_2 => pc_value_pc_imm_adder_to_pc_mux,
		-- A reg
		SRC_3 => a_reg_common_regs_to_id_exe_reg,
		SELEC => new_pc_src_select_hazard_detector, --write_pc_add_one_force,--
		OUTPUT => pc_value_pc_mux_to_pc
	);

	Unit_PC_Register : PC_Register port map (
		PC_IN => pc_value_pc_mux_to_pc,
		PC_OUT => pc_value_pc_reg_to_im,
		WRITE_OR_NOT => write_pc_or_not_hazard_detector, --write_pc_force,--
		CLK => CLK
	);
	
	Unit_PC_Adder : PC_Adder port map (
		OLD_PC => pc_value_pc_reg_to_im,
		NEW_PC => pc_value_pc_adder_to_if_id_reg
	);		
		
	Unit_IM_Addr_Mux : MUX_2 port map( 
		SELEC => im_visit_addr_select_hazard_detector,
        SRC_1 => pc_value_pc_reg_to_im,
        SRC_2 => alu_result_exe_mem_reg_to_dm,
        OUTPUT => im_visit_addr_im_mux_to_im
	);

	Unit_IM_Data_Mux : MUX_2 port map( 
		SELEC => im_visit_data_select_hazard_detector,
        SRC_1 => high_resist_port,
        SRC_2 => write_dm_data_exe_mem_reg_to_dm,
        OUTPUT => im_visit_data_im_mux_to_im
	);
		
	Unit_RAM1_Visitor : RAM1_Visitor port map (
	---input
		clk => CLK,
		
		DMemReadWrite => data_mem_read_write_select_exe_mem_reg_to_dm,
		
		EXandMEM_AluRes => alu_result_exe_mem_reg_to_dm,

		DataReady => com_data_ready,
		
		WriteData => write_dm_data_exe_mem_reg_to_dm,
		
		TSRE => com_tsre,
		TBRE => com_tbre,
		
		
	---output
	
		
				
	
		RAM1_Enable => RAM1_EN,
		RAM1_ReadEnable => RAM1_OE,
		RAM1_WriteEnable => RAM1_WE,

		SPort_WriteEnable => com_wrn,
		SPort_ReadEnable => com_rdn,


		DMemData => RAM1_Data,
		DMemAddr => RAM1_Addr(15 downto 0)
	);
	
	Unit_RAM2_Visitor : RAM2_Visitor port map (
	---input
		clk => CLK,
		
		DMemReadWrite => im_read_write_select_hazard_detector,
		
		EXandMEM_AluRes => im_visit_addr_im_mux_to_im,

--		DataReady => useless_pin(4),
		
		WriteData => im_visit_data_im_mux_to_im,
		
--		TSRE => useless_pin(3),
--		TBRE => useless_pin(2),
		
	---output
		RAM1_Enable => RAM2_EN,
		RAM1_ReadEnable => RAM2_OE,
		RAM1_WriteEnable => RAM2_WE,

--		SPort_WriteEnable => useless_pin(1),
--		SPort_ReadEnable => useless_pin(0),


		DMemData => RAM2_Data,
		DMemAddr => RAM2_Addr(15 downto 0)
	);
	
	RAM1_Addr(17 downto 16) <= "00";
	RAM2_Addr(17 downto 16) <= "00";
	
--	LED(15 downto 8) <= led_ram_visitor_to_cpu_core;
	
	Unit_IF_ID_Register : IF_ID_Register port map (
		NEW_PC_IN => pc_value_pc_adder_to_if_id_reg,
		WRITE_PC_OR_NOT => write_pc_or_not_hazard_detector,
		NEW_PC_OUT => pc_value_if_id_reg_to_id_exe_reg,
		CLK => CLK,
		INST_IN => inst_im_to_if_id_reg,

		WRITE_IR_OR_NOT => write_ir_or_not_hazard_detector, --write_ir_force,--
		WRITE_IR_SRC_SELEC => write_ir_src_select_hazard_detector, --write_ir_origin_force,--

		INST_OUT_CODE => inst_code_if_id_reg_to_controller,
		INST_OUT_RS => inst_rs_if_id_reg_to_controller,
		INST_OUT_RT => inst_rt_if_id_reg_to_controller,
		INST_OUT_RD => inst_rd_if_id_reg_to_controller,
		INST_OUT_FUNC => inst_func_if_id_reg_to_controller
	);

	-- detect before id, just after INST could be read rightly
	Unit_Hazard_Detector : Hazard_Detector port map (
		STALL_OR_NOT_FU => stall_or_not_forward_unit,

		CUR_INST_CODE => inst_code_if_id_reg_to_controller,
		CUR_INST_RS => inst_rs_if_id_reg_to_controller,
		CUR_INST_RT => inst_rt_if_id_reg_to_controller,
		CUR_INST_RD => inst_rd_if_id_reg_to_controller,
		CUR_INST_FUNC => inst_func_if_id_reg_to_controller,

		-- in id/exe reg
		LAST_WRITE_REGS_OR_NOT => regs_read_write_select_id_exe_reg_to_exe_mem_reg,
		LAST_WRITE_REGS_TARGET => write_regs_num_id_exe_reg_to_exe_mem_reg,
		LAST_VISIT_DM_OR_NOT => data_mem_read_write_select_id_exe_reg_to_exe_mem_reg,

		-- in exe/mem reg
		LAST_LAST_WRITE_REGS_OR_NOT => regs_read_write_select_exe_mem_reg_to_mem_wb_reg,
		LAST_LAST_WRITE_REGS_TARGET => write_regs_num_exe_mem_reg_to_mem_wb_reg,

		-- in exe/mem reg
		LAST_LAST_VISIT_DM_OR_NOT => data_mem_read_write_select_exe_mem_reg_to_dm,
		LAST_LAST_DM_VISIT_ADDR => alu_result_exe_mem_reg_to_dm,

		CUR_DM_READ_WRITE => data_mem_read_write_select_controller,
		CUR_DM_WRITE_DATA_SRC => write_dm_data_src_select_controller,
		   
		JUMP_OR_NOT => jump_or_not_comparator,

		WRITE_PC_OR_NOT => write_pc_or_not_hazard_detector,
		NEW_PC_SRC_SELEC => new_pc_src_select_hazard_detector,
		WRITE_IR_OR_NOT => write_ir_or_not_hazard_detector,
		WRITE_IR_SRC_SELEC => write_ir_src_select_hazard_detector,
		COMMAND_ORIGIN_OR_NOP => command_origin_or_nop_hazard_detector,
		
		DM_DATA_RESULT_SELEC => dm_visit_data_result_select_hazard_detector,
		IM_ADDR_SELEC => im_visit_addr_select_hazard_detector,
		IM_DATA_SELEC => im_visit_data_select_hazard_detector,
		IM_READ_WRITE_SELEC => im_read_write_select_hazard_detector
	);
	
	Unit_Controller : Controller port map (
		INST_CODE => inst_code_if_id_reg_to_controller,
		INST_RS => inst_rs_if_id_reg_to_controller,
		INST_RT => inst_rt_if_id_reg_to_controller,
		INST_RD => inst_rd_if_id_reg_to_controller,
		INST_FUNC => inst_func_if_id_reg_to_controller,
		
		ALU_OP => alu_op_controller,
		ALU_A_SRC => alu_a_src_select_controller,
		ALU_B_SRC => alu_b_src_select_controller,
		WRITE_REGS_DEST => write_regs_dest_select_controller,
		WRITE_DM_DATA_SRC => write_dm_data_src_select_controller,
		WRITE_RA_OR_NOT => write_ra_or_not_select_controller,
		WRITE_IH_OR_NOT => write_ih_or_not_select_controller,
		WRITE_T_OR_NOT => write_t_or_not_select_controller,
		WRITE_SP_OR_NOT => write_sp_or_not_select_controller,
		WRITE_T_SRC => write_t_src_select_controller,
		DATA_MEM_READ_WRITE => data_mem_read_write_select_controller,
		REGS_WRITE_OR_NOT => regs_read_write_select_controller,
		REGS_WRITE_DATA_SRC => regs_write_data_src_select_controller
	);
	
	Unit_Imm_Extend : Imm_Extend port map (
		code => inst_code_if_id_reg_to_controller,
		rs => inst_rs_if_id_reg_to_controller,
		rt => inst_rt_if_id_reg_to_controller,
		rd => inst_rd_if_id_reg_to_controller,
		func => inst_func_if_id_reg_to_controller,
		
		imm => imm_imm_extend_to_id_exe_reg
	);
	
	Unit_adder : adder port map (
		pc => pc_value_if_id_reg_to_id_exe_reg,
		imm => imm_imm_extend_to_id_exe_reg,
		res => pc_value_pc_imm_adder_to_pc_mux
	);
	
	Unit_Common_regs_write_src_Mux4 : MUX_4 port map (
		-- ALU result
		SRC_1 => alu_result_mem_wb_reg_to_common_regs_write_src_mux,
		-- DM data
		SRC_2 => dm_data_mem_wb_reg_to_common_regs_write_src_mux,
		-- IH
		SRC_3 => ih_reg_mem_wb_reg_to_common_regs_write_src_mux,
		-- PC
		SRC_4 => pc_value_mem_wb_reg_to_common_regs_write_src_mux,
		SELEC => regs_write_data_src_select_mem_wb_reg_to_common_regs_write_src_mux,
		OUTPUT => write_regs_data_src_mux_to_regs
	);
	
	Unit_Common_Register : Common_Register port map (
		clk => CLK,
	
		rs => inst_rs_if_id_reg_to_controller,
		rt => inst_rt_if_id_reg_to_controller,
		
		write_flag => regs_read_write_select_mem_wb_reg_to_common_regs,
		write_reg => write_regs_num_mem_wb_reg_to_common_regs,
		write_data => write_regs_data_src_mux_to_regs,
		
		a => a_reg_common_regs_to_id_exe_reg,
		b => b_reg_common_regs_to_id_exe_reg
	);
	
	Unit_Comparator : Comparator port map (
		code => inst_code_if_id_reg_to_controller,
		write_t => write_t_or_not_select_id_exe_reg_to_special_regs,
		t => t_reg_special_regs_to_exe_mem_reg,
		-- could not be given as one value
		T_src_SF => alu_sf_alu_to_special_regs,
		T_src_ZF => alu_zf_alu_to_special_regs,
		T_cmd_src => write_t_src_select_id_exe_reg_to_special_regs,
		a => a_reg_common_regs_to_id_exe_reg,
		
		jump => jump_or_not_comparator
	);
	
	Unit_ID_EXE_Register : ID_EXE_Register port map (
		clk => CLK,

		--cmd cmd
		command_origin_or_nop => command_origin_or_nop_hazard_detector,
		
		--common input
		in_pc => pc_value_if_id_reg_to_id_exe_reg,
		in_reg_a => a_reg_common_regs_to_id_exe_reg,
		in_reg_b => b_reg_common_regs_to_id_exe_reg,
		in_imm => imm_imm_extend_to_id_exe_reg,
		
		in_rs => inst_rs_if_id_reg_to_controller,
		in_rt => inst_rt_if_id_reg_to_controller,
		in_rd => inst_rd_if_id_reg_to_controller,
		
		--exe cmd
		in_alu => alu_op_controller,
		in_a_src => alu_a_src_select_controller,
		in_b_src => alu_b_src_select_controller,
		in_reg_result => write_regs_dest_select_controller,
		in_mem_src => write_dm_data_src_select_controller,
		in_flag_RA => write_ra_or_not_select_controller,
		in_flag_IH => write_ih_or_not_select_controller,
		in_flag_T => write_t_or_not_select_controller,
		in_flag_SP => write_sp_or_not_select_controller,
		in_T_src => write_t_src_select_controller,
		
		--mem cmd
		in_mem_cmd => data_mem_read_write_select_controller,
		
		--wb cmd
		in_flag_reg => regs_read_write_select_controller,
		in_reg_src => regs_write_data_src_select_controller,

		--common output
		out_pc => pc_value_id_exe_reg_to_exe_mem_reg,
		out_imm => imm_id_exe_reg_to_alu_src_mux_1,
		out_reg_a => a_reg_id_exe_reg_to_alu_a_src_mux_1,
		out_reg_b => b_reg_id_exe_reg_to_alu_a_src_mux_1,
		
		--memory data
		out_mem_data => write_dm_data_id_exe_reg_to_exe_mem_reg,
		
		--result register
		out_res_reg => write_regs_num_id_exe_reg_to_exe_mem_reg,
		
		--exe cmd
		out_alu => alu_op_id_exe_reg_to_alu,
		out_a_src => alu_a_src_select_id_exe_reg_to_alu_a_src_mux_1,
		out_b_src => alu_b_src_select_id_exe_reg_to_alu_b_src_mux_1,
		out_flag_RA => write_ra_or_not_select_id_exe_reg_to_special_regs,
		out_flag_IH => write_ih_or_not_select_id_exe_reg_to_special_regs,
		out_flag_T => write_t_or_not_select_id_exe_reg_to_special_regs,
		out_flag_SP => write_sp_or_not_select_id_exe_reg_to_special_regs,
		out_T_src => write_t_src_select_id_exe_reg_to_special_regs,
		
		--mem cmd
		out_mem_cmd => data_mem_read_write_select_id_exe_reg_to_exe_mem_reg,
		
		--wb cmd
		out_flag_reg => regs_read_write_select_id_exe_reg_to_exe_mem_reg,
		out_reg_src => regs_write_data_src_select_id_exe_reg_to_exe_mem_reg,
		
		cur_rs_num => cur_rs_num_if_id_reg_to_forward_unit,
		cur_rt_num => cur_rt_num_if_id_reg_to_forward_unit
	);
	 
	all_zeros <= ZERO;
	 
	Unit_ALU_A_Src_Select1_Mux6 : MUX_6 port map (
		-- A
		SRC_1 => a_reg_id_exe_reg_to_alu_a_src_mux_1,
		-- IMM
		SRC_2 => imm_id_exe_reg_to_alu_src_mux_1,
		-- 0
		SRC_3 => all_zeros,
		-- SP
		SRC_4 => sp_reg_special_regs_to_alu_a_src_mux_1,
		-- PC
		SRC_5 => pc_value_id_exe_reg_to_exe_mem_reg,
		-- IH
		SRC_6 => ih_reg_special_regs_to_exe_mem_reg,
		SELEC => alu_a_src_select_id_exe_reg_to_alu_a_src_mux_1,
		OUTPUT => alu_a_src_value_mux1_to_mux2
	);
	
	Unit_ALU_B_Src_Select1_Mux3 : MUX_3 port map (
		-- B
		SRC_1 => b_reg_id_exe_reg_to_alu_a_src_mux_1,
		-- IMM
		SRC_2 => imm_id_exe_reg_to_alu_src_mux_1,
		-- 0
		SRC_3 => all_zeros,
		SELEC => alu_b_src_select_id_exe_reg_to_alu_b_src_mux_1,
		OUTPUT => alu_b_src_value_mux1_to_mux2
	);
	
	Unit_ALU_A_Src_Select2_Mux3 : MUX_3 port map (
		-- origin, regs output
		SRC_1 => alu_a_src_value_mux1_to_mux2,
		-- exe/mem reg, alu result
		SRC_2 => alu_result_exe_mem_reg_to_dm,
		-- mem/wb reg, write back value
		SRC_3 => write_regs_data_src_mux_to_regs,
		SELEC => alu_a_src_select_final_forward_unit,
		OUTPUT => alu_a_src_alu_mux2_to_alu
	);
	
	Unit_ALU_B_Src_Select2_Mux3 : MUX_3 port map (
		-- origin, regs output
		SRC_1 => alu_b_src_value_mux1_to_mux2,
		-- exe/mem reg, alu result
		SRC_2 => alu_result_exe_mem_reg_to_dm,
		-- mem/wb reg, write back value
		SRC_3 => write_regs_data_src_mux_to_regs,
		SELEC => alu_b_src_select_final_forward_unit,
		OUTPUT => alu_b_src_alu_mux2_to_alu
	);
	
	Unit_ALU : alu port map (
		a => alu_a_src_alu_mux2_to_alu,
		b => alu_b_src_alu_mux2_to_alu,
		op => alu_op_id_exe_reg_to_alu,

		zf => alu_zf_alu_to_special_regs,
		sf => alu_sf_alu_to_special_regs,
		c => alu_result_alu_to_exe_mem_reg
	);
	
	Unit_Special_Register : Special_Register port map (
		clk => CLK,
	
		T_cmd_write => write_t_or_not_select_id_exe_reg_to_special_regs,
		T_cmd_src => write_t_src_select_id_exe_reg_to_special_regs,
		T_src_SF => alu_sf_alu_to_special_regs,
		T_src_ZF => alu_zf_alu_to_special_regs,
		
		-- from controller, id/exe reg is too late
		RA_cmd_write => write_ra_or_not_select_controller,
		RA_src => pc_value_if_id_reg_to_id_exe_reg,
		
		IH_cmd_write => write_ih_or_not_select_id_exe_reg_to_special_regs,
		IH_src => alu_result_mem_wb_reg_to_common_regs_write_src_mux,
		
		SP_cmd_write => write_sp_or_not_select_id_exe_reg_to_special_regs,
		SP_src => alu_result_mem_wb_reg_to_common_regs_write_src_mux,
		
		T_value => t_reg_special_regs_to_exe_mem_reg,
		RA_value => ra_reg_special_regs_to_where,
		IH_value => ih_reg_special_regs_to_exe_mem_reg,
		SP_value => sp_reg_special_regs_to_alu_a_src_mux_1
	);
	
	-- judge before update id/exe reg, to stop next inst get in
	Unit_Forward_Unit : Forward_Unit port map (
		-- current instruction info, if use reg as alu src, conflict may exist
		-- get from if/id reg
		-- detect early, stop early
		CUR_RS_REG_NUM => cur_rs_num_if_id_reg_to_forward_unit,--inst_rs_if_id_reg_to_controller,
		CUR_RT_REG_NUM => cur_rt_num_if_id_reg_to_forward_unit,--inst_rt_if_id_reg_to_controller,
		-- get it from controller, from id/exe reg is too late
		CUR_ALU_A_SRC_SELECT => alu_a_src_select_id_exe_reg_to_alu_a_src_mux_1,--alu_a_src_select_controller,
		CUR_ALU_B_SRC_SELECT => alu_b_src_select_id_exe_reg_to_alu_b_src_mux_1,--alu_b_src_select_controller,

		-- last instruction info, if write regs, conflict may exist, if read DM, must stall
		-- from id/exe reg
		-- 
		-- 
		LAST_WRITE_REGS_OR_NOT => regs_read_write_select_exe_mem_reg_to_mem_wb_reg,--regs_read_write_select_id_exe_reg_to_exe_mem_reg,
		LAST_WRITE_REGS_TARGET => write_regs_num_exe_mem_reg_to_mem_wb_reg,--write_regs_num_id_exe_reg_to_exe_mem_reg,
		LAST_DM_READ_WRITE => data_mem_read_write_select_exe_mem_reg_to_dm,--data_mem_read_write_select_id_exe_reg_to_exe_mem_reg,

		-- last last instruction info, if write regs, conflict may exist
		-- from exe/mem reg
		LAST_LAST_WRITE_REGS_OR_NOT => regs_read_write_select_mem_wb_reg_to_common_regs, --regs_read_write_select_exe_mem_reg_to_mem_wb_reg,
		LAST_LAST_WRITE_REGS_TARGET => write_regs_num_mem_wb_reg_to_common_regs, --write_regs_num_exe_mem_reg_to_mem_wb_reg,

		STALL_OR_NOT => stall_or_not_forward_unit,
		ALU_A_SRC_SELECT_FINAL => alu_a_src_select_final_forward_unit,
		ALU_B_SRC_SELECT_FINAL => alu_b_src_select_final_forward_unit
	);
	
	Unit_EXE_MEM_Register : EXE_MEM_Register port map (
		CLK => CLK,

		NEW_PC_IN => pc_value_id_exe_reg_to_exe_mem_reg,
		WRITE_DM_DATA_IN => write_dm_data_id_exe_reg_to_exe_mem_reg,
		WRITE_REG_NUM_IN => write_regs_num_id_exe_reg_to_exe_mem_reg,
		ALU_RESULT_IN => alu_result_alu_to_exe_mem_reg,
		IH_REG_IN => ih_reg_special_regs_to_exe_mem_reg,

		DATA_MEM_READ_WRITE_IN => data_mem_read_write_select_id_exe_reg_to_exe_mem_reg,
		REGS_READ_WRITE_IN => regs_read_write_select_id_exe_reg_to_exe_mem_reg,
		REGS_WRITE_DATA_SRC_IN => regs_write_data_src_select_id_exe_reg_to_exe_mem_reg,

		NEW_PC_OUT => pc_value_exe_mem_reg_mem_wb_reg,
		WRITE_DM_DATA_OUT => write_dm_data_exe_mem_reg_to_dm,
		WRITE_REG_NUM_OUT => write_regs_num_exe_mem_reg_to_mem_wb_reg,
		ALU_RESULT_OUT => alu_result_exe_mem_reg_to_dm,
		IH_REG_OUT => ih_reg_exe_mem_reg_to_mem_wb_reg,

		DATA_MEM_READ_WRITE_OUT => data_mem_read_write_select_exe_mem_reg_to_dm,
		REGS_READ_WRITE_OUT => regs_read_write_select_exe_mem_reg_to_mem_wb_reg,
		REGS_WRITE_DATA_SRC_OUT => regs_write_data_src_select_exe_mem_reg_to_mem_wb_reg
	);

	Unit_DM_Data_Result_Mux : MUX_2 port map( 
		SELEC => dm_visit_data_result_select_hazard_detector,
        SRC_1 => read_dm_data_dm_to_mem_wb_reg,
        SRC_2 => inst_im_to_if_id_reg,
        OUTPUT => dm_visit_data_dm_mux_to_mem_wb_reg
	);
	
	Unit_MEM_WB_Register : MEM_WB_Register port map (
		CLK => CLK,

		NEW_PC_IN => pc_value_exe_mem_reg_mem_wb_reg,
		WRITE_REGS_NUM_IN => write_regs_num_exe_mem_reg_to_mem_wb_reg,
		ALU_RESULT_IN => alu_result_exe_mem_reg_to_dm,
		IH_REG_IN => ih_reg_exe_mem_reg_to_mem_wb_reg,
		DM_DATA_IN => dm_visit_data_dm_mux_to_mem_wb_reg,
		 
		-- cmd
		REGS_READ_WRITE_IN => regs_read_write_select_exe_mem_reg_to_mem_wb_reg,
		REGS_WRITE_DATA_SRC_IN => regs_write_data_src_select_exe_mem_reg_to_mem_wb_reg,
		  
		NEW_PC_OUT => pc_value_mem_wb_reg_to_common_regs_write_src_mux,
		WRITE_REGS_NUM_OUT => write_regs_num_mem_wb_reg_to_common_regs,
		ALU_RESULT_OUT => alu_result_mem_wb_reg_to_common_regs_write_src_mux,
		IH_REG_OUT => ih_reg_mem_wb_reg_to_common_regs_write_src_mux,
		DM_DATA_OUT => dm_data_mem_wb_reg_to_common_regs_write_src_mux,
		  
		REGS_READ_WRITE_OUT => regs_read_write_select_mem_wb_reg_to_common_regs,
		REGS_WRITE_DATA_SRC_OUT => regs_write_data_src_select_mem_wb_reg_to_common_regs_write_src_mux
	);
	
	read_dm_data_dm_to_mem_wb_reg <= RAM1_Data;
	inst_im_to_if_id_reg <= RAM2_Data;
	
	process (CLK, inst_im_to_if_id_reg, pc_value_pc_reg_to_im, write_pc_or_not_hazard_detector, write_ir_or_not_hazard_detector)
		--variable step : integer := 0;
	begin		
		if (CLK'event and CLK = '0') then
			-- IF
			watch_info <= watch_info + "0000000000000001";
			 -- LED(15 downto 11) <= inst_code_if_id_reg_to_controller;
			 -- LED(10 downto 8) <= inst_rs_if_id_reg_to_controller;
			 -- LED(7 downto 5) <= inst_rt_if_id_reg_to_controller;
			 -- LED(4 downto 2) <= inst_rd_if_id_reg_to_controller;
			-- LED(1 downto 0) <= inst_func_if_id_reg_to_controller;
			LED <= pc_value_pc_reg_to_im;

			case DISP1 is
				when "0111111" =>
					DISP1 <= "0000110";
				when "0000110" =>
					DISP1 <= "1011011";
				when "1011011" =>
					DISP1 <= "1001111";
				when "1001111" =>
					DISP1 <= "1100110";
				when "1100110" =>
					DISP1 <= "1101101";
				when "1101101" =>
					DISP1 <= "1111101";
				when "1111101" =>
					DISP1 <= "0000111";
				when "0000111" =>
					DISP1 <= "1111111";
				when "1111111" =>
					DISP1 <= "1101111";
				when "1101111" =>
					DISP1 <= "0111111";
					case DISP2 is
						when "1101111" =>
							DISP2 <= "0111111";
						when "0111111" =>
							DISP2 <= "0000110";
						when "0000110" =>
							DISP2 <= "1011011";
						when "1011011" =>
							DISP2 <= "1001111";
						when "1001111" =>
							DISP2 <= "1100110";
						when "1100110" =>
							DISP2 <= "1101101";
						when "1101101" =>
							DISP2 <= "1111101";
						when "1111101" =>
							DISP2 <= "0000111";
						when "0000111" =>
							DISP2 <= "1111111";
						when "1111111" =>
							DISP2 <= "1101111";
						when others =>
							DISP2 <= "0111111";
					end case;
				when others =>
					DISP1 <= "0111111";
			end case;
			
			
		elsif (CLK = '1') then
			high_resist_port <= HIGH_RESIST;
		end if;
	end process;	
end Behavioral;

