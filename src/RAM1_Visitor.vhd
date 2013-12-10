library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.common.ALL;

entity RAM1_Visitor is
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
		RAM1_Enable: out std_logic := '1';
		RAM1_ReadEnable: out std_logic := '1';
		RAM1_WriteEnable: out std_logic := '1';

		SPort_WriteEnable:out std_logic := '1';
		SPort_ReadEnable: out std_logic := '1';


		DMemData:inout std_logic_vector(15 downto 0);
		DMemAddr: out std_logic_vector(15 downto 0)
		);
end RAM1_Visitor;

architecture behavior of RAM1_Visitor is


	signal tempMemData:std_logic_vector(15 downto 0);
	signal tempMemDataSrc: std_logic_vector(1 downto 0);
	signal	tempRAM1_Enable :std_logic;
	signal	tempSPort_WriteEnable:std_logic;
	signal	tempSPort_ReadEnable:std_logic;
	signal	tempRAM1_ReadEnable:std_logic;
	signal	tempRAM1_WriteEnable:std_logic;
	
begin
	
	process(DMemData,EXandMEM_AluRes,DataReady,TSRE, TBRE)
		variable temp:std_logic_vector(15 downto 0);
	begin
		if EXandMEM_AluRes = COM_STATUS_ADDR then
			temp:= "0000000000000001";
			temp(0):= TSRE and TBRE;
			temp(1):= DataReady;
			tempMemData <= temp;
		elsif EXandMEM_AluRes = COM_DATA_ADDR then
			tempMemData <= DMemData;--AcqPortData;
		else
			tempMemData <= DMemData;--AcqMemoryData;
		end if;
	end process;
	
	
	process(EXandMEM_AluRes, DMemReadWrite)
	begin
		if DMemReadWrite = MEM_READ then
			if (EXandMEM_AluRes = COM_DATA_ADDR) then
					tempMemDataSrc <= "00"; ------port
			elsif (EXandMEM_AluRes = COM_STATUS_ADDR) then
					tempMemDataSrc <= "11"; -- port status
					
			elsif EXandMEM_AluRes < DATA_MEM_BEGIN then
					tempMemDataSrc <="01";  ---------RAM2
			else
					tempMemDataSrc <="10";  ---------RAM1
			end if;
			
		elsif DMemReadWrite = MEM_WRITE then
			if (EXandMEM_AluRes = COM_DATA_ADDR) then
					tempMemDataSrc <= "00"; ------port data
			elsif (EXandMEM_AluRes = COM_STATUS_ADDR) then
					tempMemDataSrc <= "11"; -- port status
					
			elsif EXandMEM_AluRes < DATA_MEM_BEGIN then
					tempMemDataSrc <="01";  ---------RAM2
			else
					tempMemDataSrc <="10";  ---------RAM1
			end if;
		else
			tempMemDataSrc <= "10";
		end if;
	end process;
	
	
	process(EXandMEM_AluRes, DMemReadWrite, tempMemDataSrc, writeData, tempMemData)
	begin
	
		if DMemReadWrite = MEM_READ then
			if tempMemDataSrc = "00" then
				DMemData <= "ZZZZZZZZZZZZZZZZ";
				DMemAddr <= EXandMEM_AluRes;
			elsif tempMemDataSrc = "11" then
				DMemData <= tempMemData;
				DMemAddr <= EXandMEM_AluRes;
			elsif tempMemDataSrc = "10" then
				DMemData <= "ZZZZZZZZZZZZZZZZ";
				DMemAddr <= EXandMEM_AluRes;
			elsif tempMemDataSrc = "01" then
				DMemData <= "ZZZZZZZZZZZZZZZZ";
				DMemAddr <= EXandMEM_AluRes;	
			else
				DMemData <= "ZZZZZZZZZZZZZZZZ";
			end if;
			
		elsif DMemReadWrite = MEM_WRITE then
			if tempMemDataSrc = "00" then
				DMemData <= writeData;
				DMemAddr <= EXandMEM_AluRes;
			elsif tempMemDataSrc = "10" then
				DMemData <= writeData;
				DMemAddr <= EXandMEM_AluRes;	
			elsif tempMemDataSrc = "01" then
				DMemData <= writeData;
				DMemAddr <= EXandMEM_AluRes;	
			else
				DMemData <= "ZZZZZZZZZZZZZZZZ";
			end if;
		else
			DMemData <= "ZZZZZZZZZZZZZZZZ";	
		end if;
	end process;
	
	RAM1_Enable <=tempRAM1_Enable;
	SPort_WriteEnable <= tempSPort_WriteEnable;
	SPort_ReadEnable <= tempSPort_ReadEnable;
	RAM1_ReadEnable <= tempRAM1_ReadEnable;
	RAM1_WriteEnable <= tempRAM1_WriteEnable;
	
	process(clk, EXandMEM_AluRes, DMemReadWrite, tempMemDataSrc)
	begin
		if clk = '0' then
			if EXandMEM_AluRes = COM_DATA_ADDR then
				tempRAM1_Enable <= '1';
				tempRAM1_ReadEnable <= '1';
				tempRAM1_WriteEnable <= '1';
					if DMemReadWrite = MEM_READ then
						tempSport_ReadEnable <= '0';
						tempSport_WriteEnable <= '1';
					elsif DMemReadWrite = MEM_WRITE then
						tempSport_ReadEnable <= '1';
						tempSport_WriteEnable <= '0';
					else
						tempSport_ReadEnable <= '1';
						tempSport_WriteEnable <= '1';
					end if;
					
			elsif tempMemDataSrc = "10" then             ---------------------RAM1				
				tempRAM1_Enable <= '0';
				tempSPort_WriteEnable <= '1';
				tempSPort_ReadEnable <= '1';
				if DMemReadWrite = MEM_READ then
					tempRAM1_ReadEnable <= '0';
					tempRAM1_WriteEnable <= '1';
				elsif DMemReadWrite = MEM_WRITE then
					tempRAM1_ReadEnable <= '1';
					tempRAM1_WriteEnable <= '0';
				else
					tempRAM1_ReadEnable <= '1';
					tempRAM1_WriteEnable <= '1';
				end if;
			else
				tempRAM1_Enable <= '1';
				tempSPort_WriteEnable <= '1';
				tempSPort_ReadEnable <= '1';
				tempRAM1_ReadEnable <= '1';
				tempRAM1_WriteEnable <= '1';
			end if;
		elsif clk = '1' then
				tempRAM1_Enable <= '1';
				tempSPort_WriteEnable <= '1';
				tempSPort_ReadEnable <= '1';
				tempRAM1_ReadEnable <= '1';
				tempRAM1_WriteEnable <= '1';
		end if;
		
		
	end process;
	
end behavior;

