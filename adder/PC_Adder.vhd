
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity PC_Adder is 

port (
    PC: in std_logic_vector (31 downto 0);
    PC_Added: out std_logic_vector (31 downto 0));

end PC_Adder;     


architecture arch1 of PC_Adder is

signal intPC: integer := 0;
signal afterAddition: integer := 0;

begin

  intPC <= to_integer((unsigned(PC)));
  afterAddition <= intPC + 1 ;

  PC_Added <= std_logic_vector(to_unsigned(afterAddition,32));


end arch1; 





