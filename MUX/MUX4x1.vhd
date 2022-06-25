--------------MUX4x1 -------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity MUX4x1 is 
	port (
    in0: in std_logic_vector (31 downto 0);
    in1: in std_logic_vector (31 downto 0);
    in2: in std_logic_vector (31 downto 0);
    in3: in std_logic_vector (31 downto 0);
    sel: in std_logic_vector (1 downto 0);
    output: out std_logic_vector (31 downto 0));
end MUX4x1;     


architecture arch1 of MUX4x1 is
begin

 output <= in0 when sel = "00" 
        else in1 when sel = "01"
        else in2 when sel = "10"
        else in3 when sel = "11";

end arch1; 







