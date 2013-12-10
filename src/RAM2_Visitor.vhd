library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.common.ALL;

entity RAM2_Visitor is
	port(

	---input
		clk:in std_logic;
		
		DMemReadWrite : in std_logic_vector(1 downto 0);
		
		EXandMEM_AluRes: in std_logic_vector(15 downto 0);
		WriteData: in std_logic_vector(15 downto 0);
		
	---output
		RAM2_Enable: out std_logic := '1';
		RAM2_ReadEnable: out std_logic := '1';
		RAM2_WriteEnable: out std_logic := '1;
		DMemData:inout std_logic_vector(15 downto 0);
		DMemAddr: out std_logic_vector(15 downto 0)


		);
end RAM2_Visitor;

architecture behavior of RAM2_Visitor is

	
	signal	tempRAM2_Enable :std_logic;
	signal	tempRAM2_ReadEnable:std_logic;
	signal	tempRAM2_WriteEnable:std_logic;
	
begin
	
	process(EXandMEM_AluRes, DMemReadWrite, writeData)
	begin
	
		if DMemReadWrite = MEM_READ then
				DMemData <= "ZZZZZZZZZZZZZZZZ";
				DMemAddr <= EXandMEM_AluRes;
		elsif DMemReadWrite = MEM_WRITE then
				DMemData <= writeData;
				DMemAddr <= EXandMEM_AluRes;	
		else
			DMemData <= "ZZZZZZZZZZZZZZZZ";	
		end if;
	end process;
	
	RAM2_Enable <=tempRAM2_Enable;
	RAM2_ReadEnable <= tempRAM2_ReadEnable;
	RAM2_WriteEnable <= tempRAM2_WriteEnable;
	
	process(clk, EXandMEM_AluRes, DMemReadWrite)
	begin
		if clk = '0' then		
				tempRAM2_Enable <= '0';
				if DMemReadWrite = MEM_READ then
					tempRAM2_ReadEnable <= '0';
					tempRAM2_WriteEnable <= '1';
				elsif DMemReadWrite = MEM_WRITE then
					tempRAM2_ReadEnable <= '1';
					tempRAM2_WriteEnable <= '0';
				else
					tempRAM2_ReadEnable <= '1';
					tempRAM2_WriteEnable <= '1';
				end if;
		elsif clk = '1' then
				tempRAM2_Enable <= '1';
				tempRAM2_ReadEnable <= '1';
				tempRAM2_WriteEnable <= '1';
		end if;
		
		
	end process;
	
end behavior;

