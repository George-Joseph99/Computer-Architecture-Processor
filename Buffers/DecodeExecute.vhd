library ieee;
use ieee.std_logic_1164.all;

entity DecodeExecute is
    port(
        --inputs 172 bits (flush, stall won't be used as dataIN register)
        clk,flush,stall : in std_logic;
        PC_Added1_in : in std_logic_vector(31 downto 0);
        inport_in : in std_logic_vector(31 downto 0);
        ReadData1_in : in std_logic_vector(31 downto 0);
        ReadData2_in : in std_logic_vector(31 downto 0);
        ExtendedImmOrOffset_in : in std_logic_vector(31 downto 0);
        ALU_OP_in : in std_logic_vector(3 downto 0);
        ReadData2_Or_Imm_in : in std_logic_vector(1 downto 0);
        WBAddress_in : in std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_in : in std_logic;
        Inport_Or_ALU_in : in std_logic;
        outport_DecEx_in : in std_logic;
        --outputs
        outport_DecEx_out : out std_logic;
        PC_Added1_out : out std_logic_vector(31 downto 0);
        inport_out : out std_logic_vector(31 downto 0);
        ReadData1_out : out std_logic_vector(31 downto 0);
        ReadData2_out : out std_logic_vector(31 downto 0);
        ExtendedImmOrOffset_out : out std_logic_vector(31 downto 0);
        ALU_OP_out : out std_logic_vector(3 downto 0);
        ReadData2_Or_Imm_out : out std_logic_vector(1 downto 0);
        WBAddress_out : out std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_out : out std_logic;
        Inport_Or_ALU_out : out std_logic;
        ------memory and stack control--------
        --inputs 9 bits 
        MemWriteEnable_in : in std_logic;
        SPEnable_in : in std_logic;
        SelectorSP_in : in std_logic;
        NewOrOldSP_in : in std_logic;
        SP_Or_ALU_Result_in : in std_logic;
        ReadData1_Or_PC_Added1_in : in std_logic;
        WBValue_ALU_OR_Memory_in : in std_logic;
        ReadData1_Or_ReadData2_in : in std_logic_vector(1 downto 0);
        --outputs
        MemWriteEnable_out : out std_logic;
        SPEnable_out : out std_logic;
        SelectorSP_out : out std_logic;
        NewOrOldSP_out : out std_logic;
        SP_Or_ALU_Result_out : out std_logic;
        ReadData1_Or_PC_Added1_out : out std_logic;
        WBValue_ALU_OR_Memory_out : out std_logic;
        ReadData1_Or_ReadData2_out : out std_logic_vector(1 downto 0);
        --second operand 4 bits
        Rsrc_in: in std_logic_vector(2 downto 0); --Address of second operand
        Rsrc_out: out std_logic_vector(2 downto 0); --Address of second operand
        MEM_Read_in: in std_logic;
        MEM_Read_out: out std_logic;

        --jump control 4 bits
        jump_signal_in: in std_logic_vector(1 downto 0);
        jump_enable_in: in std_logic;
        ret_signal_in: in std_logic;
        jump_signal_out: out std_logic_vector(1 downto 0);
        jump_enable_out: out std_logic;
        ret_signal_out: out std_logic
    );
end DecodeExecute;

architecture arch_DecodeExecute of DecodeExecute is
component mynDFF is
    -- 174 + 9 + 4 + 4 = 189 bits
generic (n : integer:= 189);
    port(
        clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0)
    );
end component;
signal dataIN : std_logic_vector(188 downto 0);
signal dataOUT : std_logic_vector(188 downto 0);
signal En : std_logic;
begin
dataIN <= PC_Added1_in & inport_in & ReadData1_in & ReadData2_in & ExtendedImmOrOffset_in & ALU_OP_in & ReadData2_Or_Imm_in & WBAddress_in & RegWB_enable_in & Inport_Or_ALU_in & outport_DecEx_in --inputs
& MEM_Read_in & Rsrc_in & MemWriteEnable_in & SPEnable_in & SelectorSP_in & NewOrOldSP_in & SP_Or_ALU_Result_in & ReadData1_Or_PC_Added1_in & WBValue_ALU_OR_Memory_in & ReadData1_Or_ReadData2_in -- second operand and memory and stack control
& jump_signal_in & jump_enable_in & ret_signal_in; --jump signals
En <= '0' when stall = '1' else '1';
reg: mynDFF port map(clk,flush,En,dataIN,dataOUT);

PC_Added1_out <= dataOUT(188 downto 157);
inport_out <= dataOUT(156 downto 125);
ReadData1_out <= dataOUT(124 downto 93);
ReadData2_out <= dataOUT(92 downto 61);
ExtendedImmOrOffset_out <= dataOUT(60 downto 29);
ALU_OP_out <= dataOUT(28 downto 25);
ReadData2_Or_Imm_out <= dataOUT(24 downto 23);
WBAddress_out <= dataOUT(22 downto 20);
RegWB_enable_out <= dataOUT(19);
Inport_Or_ALU_out <= dataOUT(18);
outport_DecEx_out <= dataOUT(17);
MEM_Read_out <= dataOUT(16);
Rsrc_out <= dataOUT(15 downto 13);
MemWriteEnable_out <= dataOUT(12);
SPEnable_out <= dataOUT(11);
SelectorSP_out <= dataOUT(10);
NewOrOldSP_out <= dataOUT(9);
SP_Or_ALU_Result_out <= dataOUT(8);
ReadData1_Or_PC_Added1_out <= dataOUT(7);
WBValue_ALU_OR_Memory_out <= dataOUT(6);
ReadData1_Or_ReadData2_out <= dataOUT(5 downto 4);
jump_signal_out <= dataOUT(3 downto 2);
jump_enable_out <= dataOUT(1);
ret_signal_out <= dataOUT(0);
end arch_DecodeExecute;
