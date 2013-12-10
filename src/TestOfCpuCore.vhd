--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:24:17 11/24/2013
-- Design Name:   
-- Module Name:   D:/Src/Computer/computer_work/CPU/TestOfCpuCore.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU_CORE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.common.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestOfCpuCore IS
END TestOfCpuCore;
 
ARCHITECTURE behavior OF TestOfCpuCore IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU_CORE
    PORT(
         CLK : IN  std_logic;
         RAM1_Addr : OUT  std_logic_vector(17 downto 0);
         RAM1_EN : OUT  std_logic;
         RAM1_WE : OUT  std_logic;
         RAM1_OE : OUT  std_logic;
         RAM1_Data : INOUT  std_logic_vector(15 downto 0);
         RAM2_Addr : OUT  std_logic_vector(17 downto 0);
         RAM2_EN : OUT  std_logic;
         RAM2_WE : OUT  std_logic;
         RAM2_OE : OUT  std_logic;
         RAM2_Data : INOUT  std_logic_vector(15 downto 0);
         com_data_ready : IN  std_logic;
         com_rdn : OUT  std_logic;
         com_tbre : IN  std_logic;
         com_tsre : IN  std_logic;
         com_wrn : OUT  std_logic;
         LED : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal com_data_ready : std_logic := '0';
   signal com_tbre : std_logic := '0';
   signal com_tsre : std_logic := '0';

	--BiDirs
   signal RAM1_Data : std_logic_vector(15 downto 0);
   signal RAM2_Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal RAM1_Addr : std_logic_vector(17 downto 0);
   signal RAM1_EN : std_logic;
   signal RAM1_WE : std_logic;
   signal RAM1_OE : std_logic;
   signal RAM2_Addr : std_logic_vector(17 downto 0);
   signal RAM2_EN : std_logic;
   signal RAM2_WE : std_logic;
   signal RAM2_OE : std_logic;
   signal com_rdn : std_logic;
   signal com_wrn : std_logic;
   signal LED : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU_CORE PORT MAP (
          CLK => CLK,
          RAM1_Addr => RAM1_Addr,
          RAM1_EN => RAM1_EN,
          RAM1_WE => RAM1_WE,
          RAM1_OE => RAM1_OE,
          RAM1_Data => RAM1_Data,
          RAM2_Addr => RAM2_Addr,
          RAM2_EN => RAM2_EN,
          RAM2_WE => RAM2_WE,
          RAM2_OE => RAM2_OE,
          RAM2_Data => RAM2_Data,
          com_data_ready => com_data_ready,
          com_rdn => com_rdn,
          com_tbre => com_tbre,
          com_tsre => com_tsre,
          com_wrn => com_wrn,
          LED => LED
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
      -- insert stimulus here 
	  wait for CLK_period/3;

	  -- SW到IM
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100101000000";	--LI R1 40			6940
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0011000100100000";	--SLL R1 R1 0000	3120
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110101010000000";	--LI R2 80
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101100101000000";	--SW R1 R2 0000
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110101100000001";	--LI R3 01
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110101100000010";	--LI R3 02
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110101100000011";	--LI R3 03
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110101100000100";	--LI R3 04
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  --kernel
		RAM1_Data <= ZERO;
		RAM2_Data <= "0000000000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0000000000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0001000001000100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1111000000000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0011000000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0100100000010000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110010000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0011011011000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0100111000010000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000010";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;		
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000011";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000101";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111101000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0100111100000011";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0001000001001010";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0011011011000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "0100111000000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1001111000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111000000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= "1110100011001100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0010000011111000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
--		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111100000000";	--JR R7
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
	  
	  
	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	  
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111101000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111101000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111101000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110111101000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  -- test of JR
-------------------------------------------TESTW		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;

--		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111010111111";  -- LI R6 BF 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;

--		RAM1_Data <= ZERO;
		RAM2_Data <= "0011011011000000";  -- SLL R6 R6 0x0000 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0100111000000001";	--ADDIU R6 0x0001 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "1001111000000000";	--LW R6 R0 0x0000 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111000000001";	--LI R6 0x0001 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "1110100011001100";	--AND R0 R6 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0010000011111000";	--BEQZ R0 TESTW
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;

-------------------------------------------访存到IM内		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000001";  -- LI R0 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000010";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
--		RAM1_Data <= ZERO;
		--RAM2_Data <= "1001100101000001";  -- LW from IM  OK
		RAM2_Data <= "1101100100000001";  -- SW to  
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100100000011";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100100000100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100100000101";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100100000111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;	
		
		
-------------------------------------------条件跳转  OK
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000001";  -- LI R0 
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000010";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0010000000001111"; --BEQZ R0 1111
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		wait for CLK_period;
		
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000101";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		
		
-------------------------------------------写后读		OK


		RAM1_Data <= ZERO;
		RAM2_Data <= "1001100100000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000000101001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000000101001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;		
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000000101001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
-------------------------------------------写后读		
		
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110100000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000101000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110001000100001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		
		
		
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1001100000100010";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1001100001000011";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000101000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110001000100001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000101000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110001000100001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110100000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110000101000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1110001000100001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
			   
			   
	  
	  
	  
	  --kernel
		RAM1_Data <= ZERO;
		RAM2_Data <= "0000000000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0000000000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0001000001000100";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100000000111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1111000000000001";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110100010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		
		
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= NOP_INST;
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0110111010111111";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0011011011000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "0100111000010000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;
		
		RAM1_Data <= ZERO;
		RAM2_Data <= "1101111000000000";
		com_data_ready <= '1';
		com_tbre <= '1';
		com_tsre <= '1';
		wait for CLK_period;



		
      wait;
   end process;

END;
