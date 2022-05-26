library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

--ReadPCAddedOrImm ->pcSelector (2 bits)

entity ControlUnit is
  port (
    OP: In std_logic_vector(4 downto 0);
    stall_pipeline: in std_logic;
    ALU_Control : out std_logic_vector(3 downto 0);
    
    MemoryWriteEnable: out std_logic;

    ----------Stack -----------
    SPEnable: out std_logic;
    AddORSub_SP: out std_logic; --------------add or subtract SP
    NewOrPrev_SP: out std_logic; --------------Output the Value after Add/sub or before the Add/sub
    SPOrALUResult: out std_logic; -----------Memory Adress from ALU OR from SP
    ReadPCAddedOrImm: out std_logic; --Imm For Call

    -------Write enable-------------
    RegisterWriteEnable: out std_logic;
    WBValueALUorMemory: out std_logic;
    

    
    ReadData2_Immediate: out std_logic_vector (1 downto 0); 
    ReadData1_ReadData2: out std_logic_vector(1 downto 0); 

    OutPort_Enable : out std_logic;
    InPort_ALU : out std_logic;
   
    MEM_Read: out std_logic;
    
    ------jump signals------

    JumpSignal : out std_logic_vector(1 downto 0);
    JumpEnable: out std_logic;
    ReturnSignal : out std_logic
   
  ) ;
end ControlUnit ;

architecture arch of ControlUnit is

begin
   
    ALU_Control <= 	("0111") when ((OP = "00010") and stall_pipeline /='1') --setC
    else           	("0001") when ((OP = "00011") and stall_pipeline /='1') --Not Rdst
    else           	("0010") when ((OP = "00100") and stall_pipeline /='1') --Inc Rdst
    else      		("0011") when ((OP = "01000" or OP = "01001" or OP = "10010") and stall_pipeline /='1') --Mov Rsrc,Rdst / SWAP / LDM Imm,RDst 
    else      		("1100") when ((OP = "01010") and stall_pipeline /='1') --Add 
    else      		("1111") when ((OP = "01101") and stall_pipeline /='1') --IAdd  
    else      		("1101") when ((OP = "01011") and stall_pipeline /='1') --Sub 
    else      		("1110") when ((OP = "01100") and stall_pipeline /='1') --And 
    else      		("1100") when ((OP = "10011" or OP = "10100" ) and stall_pipeline /='1')  ----Adding for load and store Operations
    else      		("0000"); ----------NOP and any other Operation
   
    -- RegisterWriteEnable is 1 for NOT, INC,IN
    -- MOV ,SWAP ,ADD ,SUB ,AND , IADD
    -- POP ,LDM ,LDD else it's 0
    RegisterWriteEnable <= ('1') when ((OP = "00011" or OP = "00100" or OP = "00110" 
    or OP = "01000" or OP = "01000"  or OP = "01001" or OP = "01010" or OP = "01011" or OP = "01100"  or OP = "01101"  
    or OP = "10001" or OP = "10010" or OP = "10011" ) and stall_pipeline /='1')
    else ('0');

   --OutPort_Enable is 1 for OUT operation else it's 0
    OutPort_Enable <= ('1') when ( OP = "00101" and stall_pipeline /='1')
    else  ('0');

   --InPort_ALU is 1 for IN operation else it's 0
    InPort_ALU <= ('1') when (OP = "00110")
    else ('0');

    --MemoryWriteEnable is 1 for PUSH(in stack which is part of memory) ,STORE, CALL,INT else it's 0
    MemoryWriteEnable <= ('1') when (OP = "10000" or OP = "10100" or OP = "11100" or OP = "11110") 
    else ('0');

    --ALU source1 selection (01) for IADD , LDM ,LDD ,STD else 00
    ReadData2_Immediate <= ("01") when (OP = "01101" or OP = "10010" or OP = "10011" or OP = "10100" ) 
    else  ("00");
    
    --ALU source2 selection (01) for STD ,LDD else 00 --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ReadData1_ReadData2 <= ("01") when (OP = "10011" or OP = "10100")
    else ("00");

    --writeBack value is from memory for POP , LDD operations else writeback ALU result
    WBValueALUorMemory <= ('0') when (OP = "10001" or OP = "10011")
    else ('1');

    --SPEnable for PUSH ,POP,CALL,RET,INT,RTI
    SPEnable <= ('1') when ((OP = "10000" or OP = "10001" or OP = "11100" or OP = "11101" or OP = "11110" or OP = "11111") and stall_pipeline /='1')
    else ('0');

    --(1): Add to stack pointer for POP ,RET, RTI ----else (0): subtract
    AddORSub_SP <= ('1') when (OP = "10001" or OP = "11101" or OP = "11111")
    else ('0');

    --(1):Output the Value before adding/subtracting to SP for POP ,RET, RTI ----else (0):Output the Value after adding/subtracting to SP  
    NewOrPrev_SP <= ('1') when (OP = "10001" or OP = "11101" or OP = "11111")
    else('0') ; 

    -- (0):take Memory address from SP for PUSH ,POP ,CALL, RET ,INT ,RTI  ----else (1): take Memory address from ALU result
    SPOrALUResult <= ('0') when (OP = "10000" or OP = "10001" or OP = "11100" or OP = "11101" or OP = "11110" or OP = "11111")
    else ('1');



    --(0): use Imm as PC value for CALL operation----else (1): use PC+1
    ReadPCAddedOrImm <= ('0') when (OP = "11100")
    else ('1'); 

    --!!!!!!!!!!!!!!!!!!!!!!!!!!! should we have a signal to indicate whether PC=PC+1 or PC=M[index+1] for RTI

    --(1): for POP,LDD ---else (0) !!!!!!!!!!!!!!! what about LDM?
    MEM_Read <= ('1') when ((OP = "10011" or OP = "10001")and stall_pipeline /='1')
    else ('0');


    ----Jump Conditions------
    JumpEnable <= ('1') when ((OP ="11000" or OP ="11001" or OP ="11010" or OP="11011" or OP = "11100" or OP = "11101" or OP = "11110" or OP = "11111")and stall_pipeline /='1') 
    else ('0');
    JumpSignal <= ("00") when (OP = "11000") --JZ
    else    ("01") when (OP = "11001")  -- JN
    else    ("10") when (OP = "11010")  -- JC
    else    ("11") when (OP = "11011" or OP = "11100" or OP = "11101" or OP = "11110" or OP = "11111"); -- JMP,CALL ,RET ,INT ,RTI
    
    ReturnSignal <= ('1') when (OP = "11101" or OP = "11111") --RET ,RTI
    else ('0');

   


end architecture ; 
