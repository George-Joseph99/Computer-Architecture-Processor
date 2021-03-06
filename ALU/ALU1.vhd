Library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ALU1 is
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
end entity;


architecture arch1 of ALU1 is
signal tempA : std_logic_vector (32 downto 0);
signal tempB : std_logic_vector (32 downto 0);
signal tempResult : std_logic_vector (31 downto 0);
signal incrementedA : std_logic_vector (32 downto 0);
Signal addingResult: std_logic_vector(32 downto 0);
Signal subtractingResult: std_logic_vector(32 downto 0);
Signal cf: std_logic;
Signal nf: std_logic;
Signal zf: std_logic;
begin

tempA <= '0' & A; --temp input variables with extra bit for overflow
tempB <= '0' & B;
incrementedA  <= std_logic_vector(signed(tempA(32 downto 0)) + 1);
addingResult  <= std_logic_vector(signed(tempA(32 downto 0)) + signed(tempB(32 downto 0)));
subtractingResult  <= std_logic_vector(signed(tempA(32 downto 0)) - signed(tempB(32 downto 0)));
--Not A ->0001
--Inc A-> 0010
-- setC-> 0111
--ADD A,B -> 1100
--SUB -> 1101
--AND -> 1110
--IADD -> 1111
-- zeros-> 0000 NOP
-- add for memory operation ->1011
-- A ->0011 (MOV)

tempResult <= (not A) when sel = "0001"
else      (incrementedA(31 downto 0)) when sel = "0010"
else      (addingResult(31 downto 0))   when sel = "1100" or sel = "1111" or sel ="1011"
else      (subtractingResult(31 downto 0))   when sel = "1101" 
else      (A and B) when sel = "1110"
else      (A)          when sel = "0011"
else      (others =>'0') when sel = "0000" or sel="0111" or sel = "1000";--NOP ,setC

result <= tempResult(31 downto 0);

cf <= addingResult(32) when sel="1100" or sel = "1111"  -- ADD/IADD
else        subtractingResult(32) when sel="1101" --SUB
else        incrementedA(32) when sel="0010" --INC
else	    ('1') when sel = "0111" --setC
else        ('0') when reset ='1'
else        (cf) when sel="1011" or sel="0000" or sel="0011"--add for memory operation,Nop,Mov
else        ('0');

carryEnable <= '0' when sel= "0000" or sel="0011" or sel="1011"  --MOV/NOP/add for memory operations
else           '1';


--carryEnable <= '1' when sel= "1100" or sel="0010" or sel="1111" or sel="0111" or sel="1101" --ADD/INC/IADD/setC/sub
--else           '0';

zf  <= '1' when (tempResult(31 downto 0) = x"00000000") and (sel /="0000" and sel /="0011" and sel /= "0111" and sel /="1011") --MOV ,setC,zeros output
else        (zf) when sel ="0000" or sel ="0011" or sel= "0111" or sel = "1011" ----MOV ,setC,zeros output,add for memory operations
else        ('0') when reset ='1'
else         '0' ;

nf    <= '1' when (tempResult(31) = '1') and (sel /="0000" and sel /="0011" and sel /= "0111" and sel /="1011") 
else     (nf) when sel ="0000" or sel ="0011" or sel= "0111" or sel = "1011"----MOV ,setC,zeros output,add for memory operations
else     ('0') when reset ='1'
else      '0' ;


CarryOut <=  cf;
zeroFlag <= zf;
negativeFlag <=nf;

end arch1;