LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY jumpUnit IS
	PORT( zflag,cflag,nflag: in std_logic;
              JumpSignal: in std_logic_vector(1 downto 0);
              JumpEnable: in std_logic;
              JumpOrNot : out std_logic;
              zflag_new : out std_logic;
              nflag_new : out std_logic;
              cflag_new : out std_logic;
              Cond_jump:  out std_logic
);
end entity jumpUnit;
architecture My_Jump of jumpUnit IS

begin
JumpOrNot<='1' when ((zflag='1'  and JumpEnable='1' and JumpSignal="00")  
      or (nflag='1' and JumpEnable='1' and JumpSignal="01")
      or (cflag='1' and JumpEnable='1' and JumpSignal="10")
      or (JumpEnable='1' and JumpSignal="11"))
      else '0';

zflag_new<='0' when zflag='1' and JumpEnable='1' and JumpSignal="00"
else zflag;
nflag_new<='0' when nflag='1' and JumpEnable='1' and JumpSignal="01"
else nflag;
cflag_new<='0' when cflag='1' and JumpEnable='1' and JumpSignal="10"
else cflag;
Cond_jump<='1' when JumpEnable='1' and (JumpSignal="00" or JumpSignal="01" or JumpSignal="10")
else '0';


end My_Jump;
--------Inputs
----zflag 1 bit
----nflag 1 bit
----cflag 1 bit
-----jumpSignal 2 bits -> 00 jumpZero, 01 jumpNegative, 10 JumpCarry , 11 unconditional jump
-------jumpEnable 1 bit

--------Outputs:
-----jumpOrNot 1 bit
------zflag_new 1 bit
-----nflag_new 1 bit--
------cflag_new 1 bit------------