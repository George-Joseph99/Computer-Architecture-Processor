library ieee;
use iee.std_logic_1164.all;

entity HazardDetectionUnit is
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
        FlushSignal : out std_logic;
    );
end HazardDetectionUnit;

architecture arch_HazardDetectionUnit of HazardDetectionUnit is
    -- if (EX.MemRead == 1)
    -- we check if either of the register sources we are using is being currently changed from
    -- a previous instruction (i.e. we are reading from memory)
    -- if (Ex.Rdst == IF/ID.Rsrc1) or (Ex.Rdst == IF/ID.Rsrc2)
    -- => stall the pipeline
begin 
StallSignal <= '1' when (ExMemRead = '1' and ((EXRdst = Rsrc1) or (EXRdst = Rsrc2))) else '0';

--for jumps

PCSelector <= '01' when (JumpOrNot = '1' and RetSignal = '0') 
    else '10' when RetSignal = '1'
    else '00';

FlushSignal <= '1' when (JumpOrNot = '1' and RetSignal = '1') -- we flush buffer at ID/EX stage
    else '0';

end arch_HazardDetectionUnit;
