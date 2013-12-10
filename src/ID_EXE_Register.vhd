----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:37:47 11/22/2013 
-- Design Name: 
-- Module Name:    ID_EXE_Register - Behavioral 
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

entity ID_EXE_Register is
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
		out_pc : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		out_imm : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		out_reg_a : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		out_reg_b : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		
		--memory data
		out_mem_data : out STD_LOGIC_VECTOR(15 downto 0) := ZERO;
		
		--result register
		out_res_reg : out STD_LOGIC_VECTOR(2 downto 0) := "ZZZ";
		
		--exe cmd
		out_alu : out STD_LOGIC_VECTOR(3 downto 0) := ALU_NULL;
		out_a_src : out STD_LOGIC_VECTOR(2 downto 0) := ALU_A_SRC_ZERO;
		out_b_src : out STD_LOGIC_VECTOR(1 downto 0) := ALU_B_SRC_ZERO;
		out_flag_RA : out STD_LOGIC := WRITE_RA_NO;
		out_flag_IH : out STD_LOGIC := WRITE_IH_NO;
		out_flag_T : out STD_LOGIC := WRITE_T_NO;
		out_flag_SP : out STD_LOGIC := WRITE_SP_NO;
		out_T_src : out STD_LOGIC := T_SRC_IS_SF;
		
		--mem cmd
		out_mem_cmd : out STD_LOGIC_VECTOR(1 downto 0) := MEM_NONE;
		
		--wb cmd
		out_flag_reg : out STD_LOGIC := WRITE_REGS_NO;
		out_reg_src : out STD_LOGIC_VECTOR(1 downto 0) := REGS_WRITE_DATA_SRC_ALU_RESULT;
		
		-- addition output
		cur_rs_num : out STD_LOGIC_VECTOR(2 downto 0) := "ZZZ";
		cur_rt_num : out STD_LOGIC_VECTOR(2 downto 0) := "ZZZ"
	);
end ID_EXE_Register;

architecture Behavioral of ID_EXE_Register is

begin
	process(clk)
	begin
		if (clk'EVENT and clk = '1') then

			out_pc <= in_pc;
			out_imm <= in_imm;
			out_reg_a <= in_reg_a;
			out_reg_b <= in_reg_b;
			
			-- add by xjl
			cur_rs_num <= in_rs;
			cur_rt_num <= in_rt;
			-- add by xjl
			
			case in_reg_result is
				when "00" => 
					out_res_reg <= in_rs;
				when "01" =>
					out_res_reg <= in_rt;
				when others =>
					out_res_reg <= in_rd;
			end case;
			
			if (command_origin_or_nop = COMMAND_ORIGIN) then
				case in_mem_src is
					when WRITE_DM_DATA_SRC_A =>
						out_mem_data <= in_reg_a;
					when WRITE_DM_DATA_SRC_B =>
						out_mem_data <= in_reg_b;
					when others =>
						out_mem_data <= HIGH_RESIST;
				end case;
			
				out_alu <= in_alu;
				out_a_src <= in_a_src;
				out_b_src <= in_b_src;
				out_flag_RA <= in_flag_RA;
				out_flag_IH <= in_flag_IH;
				out_flag_T <= in_flag_T;
				out_flag_SP <= in_flag_SP;
				out_T_src <= in_T_src;
		
				out_mem_cmd <= in_mem_cmd;
		
				out_flag_reg <= in_flag_reg;
				out_reg_src <= in_reg_src;
			else
				out_mem_data <= HIGH_RESIST;

				out_alu <= ALU_NULL;
				out_a_src <= ALU_A_SRC_ZERO;
				out_b_src <= ALU_B_SRC_ZERO;
				out_flag_RA <= WRITE_RA_NO;
				out_flag_IH <= WRITE_IH_NO;
				out_flag_T <= WRITE_T_NO;
				out_flag_SP <= WRITE_SP_NO;
		
				out_mem_cmd <= MEM_NONE;
				
				out_flag_reg <= WRITE_REGS_NO;
			end if;
		end if;
	end process;
end Behavioral;

