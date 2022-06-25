library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


 entity processor is
  port(
    clk	, rst: in std_logic ;
   	Processor_INPORT : In std_logic_vector (31 downto 0);
    Processor_OUTPORT: out std_logic_vector (31 downto 0)
    );
end processor;

architecture arch_processor of processor is
--------------------------------FETCH STAGE--------------------------------
--PC_Register
component PC_Register is 
	port (
    clk: in std_logic;
    stall: in std_logic;
    In_PC: in std_logic_vector (31 downto 0);
    Out_PC: out std_logic_vector (31 downto 0)
    );
end component;

--PC_Adder
component PC_Adder is 
  port (
    PC: in std_logic_vector (31 downto 0);
    PC_Added: out std_logic_vector (31 downto 0)
    );
end component;

--MUX2x1
component MUX2x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    sel: in std_logic;
    output: out std_logic_vector (31 downto 0)
    );
end component;  

--MUX4X1
component MUX4x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    in2: in std_logic_vector (31 downto 0);
    in3: in std_logic_vector (31 downto 0);
    sel: in std_logic_vector (1 downto 0);
    output: out std_logic_vector (31 downto 0)
    );
end component;

-- mux 3bits
component MUX2x1_3bits IS
	port (
    in0: in std_logic_vector (2 downto 0);
    in1: in std_logic_vector (2 downto 0);
    sel: in std_logic;
    output: out std_logic_vector (2 downto 0));
end component;

--MEMORY
component Memory is
  port(
    clk : in std_logic;     
    WriteEnable : in std_logic;
    address : in std_logic_vector(31 downto 0);--address or PC
    datain : in std_logic_vector(31 downto 0); 
    dataout : out std_logic_vector(31 downto 0) --dataout or instruction fetched
    );
end component;

--IF/ID buffer
component FetchDecode is
  port(
      -- inputs
      clk,stall,flush : in std_logic;
      -- stall comes from hazard detection unit
      -- flush comes from control unit
      PC_Added_in : in std_logic_vector(31 downto 0);
      instruction_in : in std_logic_vector(31 downto 0);
      inport_in : in std_logic_vector(31 downto 0);
      -- outputs
      PC_Added_out : out std_logic_vector(31 downto 0);
      instruction_out : out std_logic_vector(31 downto 0);
      inport_out : out std_logic_vector(31 downto 0)
  );
end component;
-----------------------------------------------------------------------------------------------------------------------------
--------------------------------DECODE STAGE--------------------------------
--register file
component registerFile1 IS
generic ( n : integer := 32);
  port( 
      srcEnable, distEnable : IN std_logic; 
      readAddress1 ,readAddress2 : IN std_logic_vector(2 DOWNTO 0);
      WriteAddress : IN std_logic_vector(2 DOWNTO 0);
      dataOut1 ,dataOut2: OUT std_logic_vector(n-1 DOWNTO 0);
      WriteData: IN std_logic_vector(n-1 DOWNTO 0);
      clk : IN std_logic;
      rst : IN std_logic
    );
end component;

--CU
component ControlUnit is
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
    ReadPCAddedOrImm: out std_logic_vector (1 downto 0); --Imm For Call --M[index+2]
    -------Write enable-------------
    RegisterWriteEnable: out std_logic;
    WBValueALUorMemory: out std_logic_vector(1 downto 0);
    ReadData2_Immediate: out std_logic_vector (1 downto 0); 
    ReadData1_ReadData2: out std_logic_vector(1 downto 0); 
    OutPort_Enable : out std_logic;
    InPort_ALU : out std_logic;
    MEM_Read: out std_logic;
    ------jump signals------
    JumpSignal : out std_logic_vector(1 downto 0);
    JumpEnable: out std_logic;
    ReturnSignal : out std_logic
    );
end component;

--ID/IE buffer
component DecodeExecute is
  port(
      --inputs 172 bits (flush, stall won't be used as dataIN register)
      Rsrc2_in : in std_logic_vector(2 downto 0);
      Rsrc2_out : out std_logic_vector(2 downto 0);
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
      Imm_Or_PC_Added1_in : in std_logic_vector(1 downto 0);
      WBValue_ALU_OR_Memory_in : in std_logic_vector(1 downto 0);
      ReadData1_Or_ReadData2_in : in std_logic_vector(1 downto 0);
      --outputs
      MemWriteEnable_out : out std_logic;
      SPEnable_out : out std_logic;
      SelectorSP_out : out std_logic;
      NewOrOldSP_out : out std_logic;
      SP_Or_ALU_Result_out : out std_logic;
      Imm_Or_PC_Added1_out : out std_logic_vector(1 downto 0);
      WBValue_ALU_OR_Memory_out : out std_logic_vector(1 downto 0);
      ReadData1_Or_ReadData2_out : out std_logic_vector(1 downto 0);
      --second operand 4 bits
      Rsrc1_in: in std_logic_vector(2 downto 0); --Address of second operand
      Rsrc1_out: out std_logic_vector(2 downto 0); --Address of second operand
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
end component;
--------------------------------Execute STAGE--------------------------------
--ALU
component ALU1 is
  port(
  A,B: in std_logic_vector(31 downto 0);
  sel: in std_logic_vector(3 downto 0);
  reset: in std_logic;
  result :out std_logic_vector(31 downto 0);
  carryEnable: out std_logic;
  carryOut: out std_logic;
  zeroFlag: out std_logic;
  negativeFlag: out std_logic
  );
  end component;

  --FU
component ForwardUnit is
    port(
        Rsrc1 : in std_logic_vector(2 downto 0);
        Rsrc2 : in std_logic_vector(2 downto 0);

        CU_Signal1 : in std_logic_vector(1 downto 0); --ReadData1 or ALU result or WB value or ReadData2
        CU_Signal2 : in std_logic_vector(1 downto 0); --ReadData2 or Immediate or ALU result or WB value

        AddressRdstInEx : in std_logic_vector(2 downto 0);
        WBEnableInEx : in std_logic;

        AddressRdstInMem: in std_logic_vector(2 downto 0);
        WBEnableInMem : in std_logic;

        --mux selectors before ALU
        mux1_selector : out std_logic_vector(1 downto 0); --first operand
        mux2_selector : out std_logic_vector(1 downto 0); --second operand
        First_Operand_Selector : out std_logic_vector(1 downto 0) --ReadData1 or ALU or WB 
    );
end component;

--jump cu
component jumpUnit IS
	PORT( zflag,cflag,nflag: in std_logic;
              JumpSignal: in std_logic_vector(1 downto 0);
              JumpEnable: in std_logic;
              JumpOrNot : out std_logic;
              zflag_new : out std_logic;
              nflag_new : out std_logic;
              cflag_new : out std_logic;
              Cond_jump:  out std_logic
);
end component;

--flag register
component FlagRegister is
  port(clk,rst,enable:in std_logic; 
  ZF_In: in std_logic;
  NF_In: in std_logic;
  CF_In: in std_logic;

  ZF_Out: Out std_logic;
  NF_Out: Out std_logic;
  CF_Out: Out std_logic);
end component;

--for flags
component MUX2x1_1bit is 
port(
    in0: in std_logic;
    in1: in std_logic;
    sel: in std_logic;
    output: out std_logic
);
end component;

--for outport
component DFF IS
generic ( n : integer := 32);
port( clk,rst,enable : IN std_logic; 
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

--------------------------------Memory STAGE--------------------------------
--EX/MEM buffer
component ExecuteMemory is
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
end component;

--stack cu
component stackControlUnit is
  port (
    rst : in std_logic;
    clk : in std_logic;
    StackOldNew : in std_logic; -- select the old value (0)of the stack or the newly pushed or poped value (1)
    StackAction : in std_logic; -- pop (minus 1)(0) or push (plus 1)(1) control signal
    StackEnable: in std_logic; -- the stack enable(control signal to turn tack writing on)
    SP : out std_logic_vector(31 downto 0) -- the stack output
  ) ;
end component ;

--stack register
component SpecialStackRegister_32 is
  port(
      enable,clk,rst: in std_logic;
      d: in std_logic_vector(31 downto 0);
      q: out std_logic_vector(31 downto 0)
  );
end component;

--MEM/WB buffer
component MemoryWB is
  port(
      -- inputs 69 bits
      Imm_OUT_EX_MEM : in std_logic_vector(31 downto 0);
      Imm_OUT_MEM_WB : out std_logic_vector(31 downto 0);
      clk,flush,stall : in std_logic;
      MemoryData_in : in std_logic_vector(31 downto 0);
      ALU_Result_in : in std_logic_vector(31 downto 0);
      WBAddress_in : in std_logic_vector(2 downto 0); --Rdst address
      RegWB_enable_in : in std_logic;

      MemoryData_out : out std_logic_vector(31 downto 0);
      ALU_Result_out : out std_logic_vector(31 downto 0);
      WBAddress_out : out std_logic_vector(2 downto 0); --Rdst address
      RegWB_enable_out : out std_logic;
      WBValue_ALU_OR_Memory_in : in std_logic_vector(1 downto 0);
      WBValue_ALU_OR_Memory_out : out std_logic_vector(1 downto 0)
  );
end component;

--------------------------------WB STAGE--------------------------------
component HazardDetectionUnit is
  port(
      --Rdst: in std_logic_vector(2 downto 0); --address of rdst
      Rsrc1: in std_logic_vector(2 downto 0); --address of rsrc1
      Rsrc2: in std_logic_vector(2 downto 0); --address of rsrc2
      EXRdst : in std_logic_vector(2 downto 0); --address of rdst in execute
      ExMemRead: in std_logic; --signal indicating that we are currently reading from memory
      StallSignal : out std_logic;
      --jumps
      JumpOrNot : in std_logic;
      RetSignal : in std_logic; --from memory
      PCSelector : out std_logic_vector(1 downto 0);
      FlushSignal : out std_logic
  );
end component;

--------------------------------------------------------------------SIGNALS---------------------------------------------------
-------------------------signals for Fetch stage-------------------------------
signal PC_in : std_logic_vector(31 downto 0);
signal PC_STALL : std_logic;
signal PC_out : std_logic_vector(31 downto 0);
signal PC_Added : std_logic_vector(31 downto 0);
signal memoryIN : std_logic_vector(31 downto 0);
signal memoryOUT : std_logic_vector(31 downto 0);
signal resetAddress : std_logic_vector(31 downto 0);
signal PC_From_Selector : std_logic_vector(31 downto 0);
-------------------------------------------------------------------------------
-------------------------signals for Decode stage------------------------------
signal IF_ID_Stall : std_logic;
signal IF_ID_Flush : std_logic;
signal Instruction : std_logic_vector(31 downto 0);
signal PC_ADDED_OUT : std_logic_vector(31 downto 0);
signal inport_decode : std_logic_vector(31 downto 0);
signal ReadData1 : std_logic_vector(31 downto 0);
signal ReadData2 : std_logic_vector(31 downto 0);
--signal WriteBackEnableCU : std_logic;
signal WriteBackEnableRegFile : std_logic;
signal WriteBackAddressRegFile : std_logic_vector(2 downto 0);
--signal WriteData_From_RegFile : std_logic_vector(31 downto 0);
signal ExtendedImm_Or_Offset : std_logic_vector(31 downto 0);
--control unit signals
Signal CU_ALUOpCode: std_logic_vector(3 downto 0);
Signal CU_MemWriteEn ,CU_SPen ,CU_SP_add_sub , CU_SP_new_old, CU_SP_ALU :std_logic;
Signal CU_PC_selector :std_logic_vector(1 downto 0);
Signal CU_RegWriteEn : std_logic;
signal CU_WBvalue :std_logic_vector(1 downto 0);
Signal CU_readData1_readData2 , CU_readData2_Imm   :std_logic_vector (1 downto 0);
Signal CU_OutEn, CU_IN_ALU, CU_mem_read :std_logic;
Signal CU_JmpSig :std_logic_vector(1 downto 0);
Signal CU_JmpEn ,CU_retSig : std_logic;
---------------------Decode Excute buffer output signals----------------------------
Signal ID_IE_OutEn :std_logic;
Signal ID_IE_PC_added ,ID_IE_inport,ID_IE_ReadData1,ID_IE_ReadData2,ID_IE_extendedImmORoffset: std_logic_vector (31 downto 0);
Signal ID_IE_ALUOpCode: std_logic_vector(3 downto 0);
Signal ID_IE_readData2_Imm: std_logic_vector(1 downto 0);
Signal ID_IE_WBaddress: std_logic_vector(2 downto 0);
Signal ID_IE_RegWriteEn ,ID_IE_IN_ALU: std_logic;

Signal ID_IE_MemWriteEn ,ID_IE_SPen,ID_IE_SP_add_sub,ID_IE_SP_new_old,ID_IE_SP_ALU : std_logic;
Signal ID_IE_PC_selector :std_logic_vector(1 downto 0);
Signal ID_IE_WBvalue: std_logic_vector(1 downto 0);
Signal ID_IE_readData1_readData2: std_logic_vector(1 downto 0);

Signal ID_IE_Rsrc1: std_logic_vector( 2 downto 0);
signal ID_IE_Rsrc2: std_logic_vector( 2 downto 0);
Signal ID_IE_mem_read: std_logic;

Signal ID_IE_JmpSig :std_logic_vector(1 downto 0);
Signal ID_IE_JmpEn ,ID_IE_retSig : std_logic;
signal ID_EX_Flush : std_logic;
signal ID_EX_Stall : std_logic;
---------------------Execute Stage signals------------------------------
--ALU signals
--Signal dummy:std_logic_vector (31 downto 0);
Signal MUX_ALU1stOperand: std_logic_vector(31 downto 0);
Signal MUX_ALU2ndOperand:std_logic_vector (31 downto 0);
signal MUX_Outport : std_logic_vector(31 downto 0);
Signal result : std_logic_vector(31 downto 0);
Signal fe,cf,zf,nf  : std_logic; --flags out of ALU
signal ReadData1_OUT_EX_MEM : std_logic_vector(31 downto 0);
--flags for jumpunit
signal condJumpFromJumpCU : std_logic;
signal fe_new,cf_new,zf_new,nf_new : std_logic; --from jump cu
signal cf_new_mux,zf_new_mux,nf_new_mux : std_logic; --from mux of each flag
signal CF_Reg,ZF_Reg,NF_Reg : std_logic; --from flag register
signal JumpOrNot : std_logic;

--FU signals
signal FU_WB_Address_EX_MEM : std_logic_vector(2 downto 0);
signal FU_WB_Enable_EX_MEM : std_logic;
--signal FU_WB_Address_MEM_WB : std_logic_vector(2 downto 0);
--signal FU_WB_Enable_MEM_WB : std_logic;
signal First_ALU_MUX_Selector : std_logic_vector(1 downto 0);
signal Second_ALU_MUX_Selector : std_logic_vector(1 downto 0);
signal outport_MUX_Selector : std_logic_vector(1 downto 0);
signal ALU_Result_EX_MEM : std_logic_vector(31 downto 0);
signal WriteBackData : std_logic_vector(31 downto 0);

signal ALU_Result_Out_To_EX_MEM_Buffer : std_logic_vector(31 downto 0);

---------------------Memory Stage signals------------------------------
signal EX_MEM_Stall : std_logic;
signal PC_Added_For_Ret_Mem : std_logic_vector(31 downto 0);
signal Imm_EX_MEM : std_logic_vector(31 downto 0);
signal MemoryWriteEnable_MEM : std_logic;
signal SPEnable_MEM : std_logic;
signal SP_NEW_Or_Old_MEM : std_logic;
signal SP_Selector_MEM : std_logic;
signal SP_Or_ALU_Result_MEM : std_logic;
signal ReadPC_Added_Or_Imm_MEM : std_logic_vector(1 downto 0);
signal WBValue_ALU_Or_Memory_MEM : std_logic_vector(1 downto 0);
signal Memory_READ_MEM : std_logic;
signal ReturnSignal_EX_MEM : std_logic;
signal Imm_MEM_WB_OUT : std_logic_vector(31 downto 0);

--stack
signal StackPointer : std_logic_vector(31 downto 0);
signal AddressInMemory : std_logic_vector(31 downto 0);
signal WriteDataInMemory : std_logic_vector(31 downto 0);
signal DataOutFromMemory : std_logic_vector(31 downto 0); --data memory :D


signal MEM_WB_Stall : std_logic;
signal DataOutFromMemory_WB : std_logic_vector(31 downto 0);
signal ALU_Result_WB : std_logic_vector(31 downto 0);
signal WBAdress_WB : std_logic_vector(2 downto 0);
signal WBEnable_WB : std_logic;
signal WBValue_ALU_Or_Memory_WB : std_logic_vector(1 downto 0);


--hazard signals
signal Stall_From_Hazard_To_CU : std_logic;
signal PC_SELECTOR : std_logic_vector(1 downto 0);
signal ID_Flush_From_Hazard : std_logic;




begin
  -----------------------------------------Fetch stage-------------------------------------------
  PC_SELECTOR_MUX : MUX4x1 port map(PC_Added,ID_IE_extendedImmORoffset,DataOutFromMemory,PC_Added,PC_SELECTOR,PC_From_Selector); --TODO: change mux inputs and selector
  resetAddress <= std_logic_vector(unsigned(DataOutFromMemory));
  PC_RESET_MUX : MUX2x1 port map(PC_From_Selector,resetAddress,rst,PC_in);
  PC_Reg: PC_Register port map(clk,PC_STALL,PC_in,PC_out); 
  Input_To_Mem: MUX2x1 port map(PC_out,(Others=>'0'),rst,memoryIN);
  MEM_MUX : MUX2x1 port map(memoryIn,AddressInMemory,MemoryWriteEnable_MEM,memoryOUT);
  MEM: Memory port map(clk,MemoryWriteEnable_MEM,memoryOUT,WriteDataInMemory,DataOutFromMemory);
  PC_Add: PC_Adder port map(memoryIN,PC_Added);
  IF_ID : FetchDecode port map(clk,IF_ID_Stall,IF_ID_Flush,PC_Added,DataOutFromMemory,Processor_INPORT,PC_ADDED_OUT,Instruction,inport_decode);
  -----------------------------------------Decode stage-------------------------------------------
  regfile : registerFile1 port map('1',WriteBackEnableRegFile,Instruction(23 downto 21),Instruction(20 downto 18),WriteBackAddressRegFile,ReadData1,ReadData2,WriteBackData,clk,rst); --TODO: distEnable and writeBack address
  CU  : ControlUnit port MAP(Instruction(31 downto 27),Stall_From_Hazard_To_CU,CU_ALUOpCode,CU_MemWriteEn,CU_SPen,CU_SP_add_sub,CU_SP_new_old,CU_SP_ALU,CU_PC_selector
  ,CU_RegWriteEn,CU_WBvalue,CU_readData2_Imm,CU_readData1_readData2,CU_OutEn,CU_IN_ALU,CU_mem_read,CU_JmpSig,CU_JmpEn,CU_retSig); --TODO: stall signal from hdu
  ExtendedImm_Or_Offset <= std_logic_vector(resize(unsigned(Instruction(15 downto 0)),32));

  ID_IE_Buffer: DecodeExecute port MAP(Instruction(20 downto 18),ID_IE_Rsrc2,clk,ID_EX_Flush,ID_EX_Stall,PC_ADDED_OUT,inport_decode,ReadData1,ReadData2,
  ExtendedImm_Or_Offset, CU_ALUOpCode,CU_readData2_Imm,Instruction(26 downto 24),CU_RegWriteEn,CU_IN_ALU,CU_OutEn,
   ID_IE_OutEn,ID_IE_PC_added,ID_IE_inport,ID_IE_ReadData1,ID_IE_ReadData2,ID_IE_extendedImmORoffset,ID_IE_ALUOpCode,
   ID_IE_readData2_Imm,ID_IE_WBaddress,ID_IE_RegWriteEn,ID_IE_IN_ALU,
   CU_MemWriteEn,CU_SPen,CU_SP_add_sub,CU_SP_new_old,CU_SP_ALU,CU_PC_selector,CU_WBvalue,CU_readData1_readData2,
   ID_IE_MemWriteEn,ID_IE_SPen,ID_IE_SP_add_sub,ID_IE_SP_new_old,ID_IE_SP_ALU,ID_IE_PC_selector,ID_IE_WBvalue,ID_IE_readData1_readData2,
   Instruction(23 downto 21),ID_IE_Rsrc1,
   CU_mem_read,ID_IE_mem_read,
   CU_JmpSig,CU_JmpEn,CU_retSig,
   ID_IE_JmpSig,ID_IE_JmpEn,ID_IE_retSig
); --TODO: flush,stall signals (check writeback address)

  -----------------------------------------Execution stage-------------------------------------------
  FU : ForwardUnit port map(ID_IE_Rsrc1,ID_IE_Rsrc2,ID_IE_readData1_readData2,ID_IE_readData2_Imm,FU_WB_Address_EX_MEM,FU_WB_Enable_EX_MEM,WBAdress_WB,WBEnable_WB,
  First_ALU_MUX_Selector,Second_ALU_MUX_Selector,outport_MUX_Selector);
  ALU_MUX_1 : MUX4x1 port map(ID_IE_ReadData1,ALU_Result_EX_MEM,WriteBackData,ID_IE_ReadData2,First_ALU_MUX_Selector,MUX_ALU1stOperand);
  ALU_MUX_2 : MUX4x1 port Map(ID_IE_ReadData2,ID_IE_extendedImmORoffset,ALU_Result_EX_MEM,WriteBackData,Second_ALU_MUX_Selector,MUX_ALU2ndOperand);
  outport_MUX : MUX4x1 port map(ID_IE_ReadData1,ALU_Result_EX_MEM,WriteBackData,ID_IE_ReadData2,outport_MUX_Selector,MUX_Outport);
  ALU : ALU1 port Map(MUX_ALU1stOperand,MUX_ALU2ndOperand,ID_IE_ALUOpCode,rst,result,fe,cf,zf,nf);
  flag_enable_mux : MUX2x1_1bit port map(fe,condJumpFromJumpCU,condJumpFromJumpCU,fe_new);
  zf_mux : MUX2x1_1bit port map(zf,zf_new,condJumpFromJumpCU,zf_new_mux);
  cf_mux : MUX2x1_1bit port map(cf,cf_new,condJumpFromJumpCU,cf_new_mux);
  nf_mux : MUX2x1_1bit port map(nf,nf_new,condJumpFromJumpCU,nf_new_mux);
  flags : FlagRegister port map(clk,rst,fe_new,zf_new_mux,nf_new_mux,cf_new_mux,ZF_Reg,NF_Reg,CF_Reg);
  FlagsCU : jumpUnit port map(ZF_Reg,CF_Reg,NF_Reg,ID_IE_JmpSig,ID_IE_JmpEn,JumpOrNot,zf_new,nf_new,cf_new,condJumpFromJumpCU);

  ALUResult_Inport_MUX : Mux2x1 port map (result,ID_IE_inport,ID_IE_IN_ALU,ALU_Result_Out_To_EX_MEM_Buffer);
  outport_reg : DFF port map(clk,rst,ID_IE_OutEn,MUX_Outport,Processor_OUTPORT);

  EX_MEM_Buffer: ExecuteMemory port map(MUX_Outport,ReadData1_OUT_EX_MEM,clk,rst,EX_MEM_Stall,ID_IE_PC_added,ALU_Result_Out_To_EX_MEM_Buffer,ID_IE_extendedImmORoffset,
  ID_IE_WBaddress,ID_IE_RegWriteEn,PC_Added_For_Ret_Mem,ALU_Result_EX_MEM,Imm_EX_MEM,FU_WB_Address_EX_MEM,FU_WB_Enable_EX_MEM,
  ID_IE_MemWriteEn,ID_IE_SPen,ID_IE_SP_add_sub,ID_IE_SP_new_old,ID_IE_SP_ALU,ID_IE_PC_selector,ID_IE_WBvalue,
  MemoryWriteEnable_MEM,SPEnable_MEM,SP_Selector_MEM,SP_NEW_Or_Old_MEM,SP_Or_ALU_Result_MEM,
  ReadPC_Added_Or_Imm_MEM,WBValue_ALU_Or_Memory_MEM,ID_IE_mem_read,Memory_READ_MEM,
  ID_IE_retSig,ReturnSignal_EX_MEM);

  -----------------------------------------Memory stage-------------------------------------------

  stack: stackControlUnit port map(rst,clk,SP_NEW_Or_Old_MEM,SP_Selector_MEM,SPEnable_MEM,StackPointer);
  Memory_Address_Mux : MUX2x1 port map(StackPointer,ALU_Result_EX_MEM,SP_Or_ALU_Result_MEM,AddressInMemory);
  Memory_DataIN_Mux : Mux4x1 port map(PC_Added_For_Ret_Mem,PC_Added_For_Ret_Mem,ReadData1_OUT_EX_MEM,ReadData1_OUT_EX_MEM,ReadPC_Added_Or_Imm_MEM,WriteDataInMemory);

  --mem2: Memory port map(clk,MemoryWriteEnable_MEM,AddressInMemory,WriteDataInMemory,DataOutFromMemory);


  MEM_WB_Buffer : MemoryWB port map(Imm_EX_MEM,Imm_MEM_WB_OUT,clk,rst,MEM_WB_Stall,DataOutFromMemory,ALU_Result_EX_MEM,FU_WB_Address_EX_MEM,FU_WB_Enable_EX_MEM,
  DataOutFromMemory_WB,ALU_Result_WB,WBAdress_WB,WBEnable_WB,WBValue_ALU_Or_Memory_MEM,WBValue_ALU_Or_Memory_WB);

  -----------------------------------------WriteBack stage-------------------------------------------
  WBValue_MUX : Mux4x1 port map(DataOutFromMemory_WB,Imm_MEM_WB_OUT,ALU_Result_WB,ALU_Result_WB,WBValue_ALU_Or_Memory_WB,WriteBackData);
  WriteBackEnableRegFile <= WBEnable_WB;
  WriteBackAddressRegFile <= WBAdress_WB;

  hazard : HazardDetectionUnit port map(Instruction(23 downto 21),Instruction(20 downto 18),ID_IE_WBaddress,ID_IE_mem_read,
  Stall_From_Hazard_To_CU,JumpOrNot,ReturnSignal_EX_MEM,PC_SELECTOR,ID_Flush_From_Hazard);

  IF_ID_Flush <= ID_Flush_From_Hazard or rst;
  ID_EX_Flush <= rst;
  IF_ID_Stall <= Stall_From_Hazard_To_CU;
  PC_STALL <= Stall_From_Hazard_To_CU;

end arch_processor;
