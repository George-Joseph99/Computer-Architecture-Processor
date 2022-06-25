library ieee;
use ieee.std_logic_1164.all;

entity ExecuteMemory is
    port(
        --inputs 100 bits
        EX_MEM_ReadData1_IN : in std_logic_vector(31 downto 0);
        EX_MEM_ReadData1_OUT : out std_logic_vector(31 downto 0);
        clk,flush,stall : in std_logic;
        PC_Added_in : in std_logic_vector(31 downto 0);
        ALU_Result_in : in std_logic_vector(31 downto 0);
        ReadData1_in : in std_logic_vector(31 downto 0);
        WBAddress_in : in std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_in : in std_logic;

        --outputs
        PC_Added_out : out std_logic_vector(31 downto 0);
        ALU_Result_out : out std_logic_vector(31 downto 0);
        ReadData1_out : out std_logic_vector(31 downto 0);
        WBAddress_out : out std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_out : out std_logic;

        --memory and stack control 8 bits
        MemWriteEnable_in : in std_logic;
        SPEnable_in : in std_logic;
        SelectorSP_in : in std_logic;
        NewOrOldSP_in : in std_logic;
        SP_Or_ALU_Result_in : in std_logic;
        Imm_Or_PC_Added1_in : in std_logic_vector(1 downto 0);
        WBValue_ALU_OR_Memory_in : in std_logic_vector(1 downto 0);

        MemWriteEnable_out : out std_logic;
        SPEnable_out : out std_logic;
        SelectorSP_out : out std_logic;
        NewOrOldSP_out : out std_logic;
        SP_Or_ALU_Result_out : out std_logic;
        Imm_Or_PC_Added1_out : out std_logic_vector(1 downto 0);
        WBValue_ALU_OR_Memory_out : out std_logic_vector(1 downto 0);
        MEM_Read_in: in std_logic;
        MEM_Read_out: out std_logic;

        --jump control 1 bit
        ret_signal_in: in std_logic;
        ret_signal_out: out std_logic
    );
end ExecuteMemory;

architecture arch_ExecuteMemory of ExecuteMemory is
component DFF is
        -- 100 + 8 + 1 = 109 bits
generic (n : integer:= 143);
    port(
        clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0)
    );
end component;

signal dataIN : std_logic_vector(142 downto 0);
signal dataOUT : std_logic_vector(142 downto 0);
signal En : std_logic;

begin
dataIN <= EX_MEM_ReadData1_IN & PC_Added_in & ALU_Result_in & ReadData1_in & WBAddress_in & RegWB_enable_in --inputs
& MemWriteEnable_in & SPEnable_in & SelectorSP_in & NewOrOldSP_in & SP_Or_ALU_Result_in & Imm_Or_PC_Added1_in & WBValue_ALU_OR_Memory_in & MEM_Read_in -- memory and stack
& ret_signal_in; -- jumps
En <= '0' when stall = '1' else '1';

reg: DFF port map(clk,flush,En,dataIN,dataOUT);

EX_MEM_ReadData1_OUT <= dataOUT(142 downto 111);
PC_Added_out <= dataOUT(110 downto 79);
ALU_Result_out <= dataOUT(78 downto 47);
ReadData1_out <= dataOUT(46 downto 15);
WBAddress_out <= dataOUT(14 downto 12);
RegWB_enable_out <= dataOUT(11);
MemWriteEnable_out <= dataOUT(10);
SPEnable_out <= dataOUT(9);
SelectorSP_out <= dataOUT(8);
NewOrOldSP_out <= dataOUT(7);
SP_Or_ALU_Result_out <= dataOUT(6);
Imm_Or_PC_Added1_out <= dataOUT(5 downto 4);
WBValue_ALU_OR_Memory_out <= dataOUT(3 downto 2);
MEM_Read_out <= dataOUT(1);
ret_signal_out <= dataOUT(0);
end arch_ExecuteMemory;
