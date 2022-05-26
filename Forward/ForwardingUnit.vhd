library ieee;
use ieee.std_logic_1164.all;

entity ForwardUnit is
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
end ForwardUnit;

architecture arch_ForwardUnit of ForwardUnit is 
--if rsrc in this stage needs data from rdst from previous stage (read after write)
--we take the value from ALU or memory to use in ALU
--else we choose another values (ReadData1 or ReadData2 or Immediate)
begin
mux1_selector <= "01" when (Rsrc1 = AddressRdstInEx and WBEnableInEx = '1')
-- if rsrc2 is not immediate then we may need to ReadData2 from first mux therefore we need to check the cu_signal2
or (Rsrc2 = AddressRdstInEx and WBEnableInEx = '1' and CU_Signal2 = "01") -- ALU result (execution to execution forwarding)
else "10" when (Rsrc1 = AddressRdstInMem and WBEnableInMem = '1')
-- if rsrc2 is not immediate then we may need to ReadData2 from first mux therefore we need to check the cu_signal2
or (Rsrc2 = AddressRdstInMem and WBEnableInMem = '1' and CU_Signal2 = "01") -- WB value (memory to execution forwarding)
else (CU_Signal1); -- ReadData1 or ALU result or WB value or ReadData2

--if rsrc2 is immediate then we can't forward
mux2_selector <= "10" when (Rsrc2 = AddressRdstInEx and WBEnableInEx = '1') and CU_Signal2 /= "01" -- ALU result (execution to execution forwarding)
else "11" when (Rsrc2 = AddressRdstInMem and WBEnableInMem = '1') and CU_Signal2 /= "01" -- WB value (memory to execution forwarding)
else (CU_Signal2); -- ReadData2 or Immediate or ALU result or WB value

First_Operand_Selector <= "01" when (Rsrc1 = AddressRdstInEx and WBEnableInEx = '1') -- ALU result (execution to execution forwarding)
else "10" when (Rsrc1 = AddressRdstInMem and WBEnableInMem = '1') -- WB value (memory to execution forwarding)
else "00";

end arch_ForwardUnit;
