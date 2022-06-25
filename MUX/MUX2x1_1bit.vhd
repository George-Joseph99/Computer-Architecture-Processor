library ieee;
use ieee.std_logic_1164.all;

entity MUX2x1_1bit is 
port(
    in0: in std_logic;
    in1: in std_logic;
    sel: in std_logic;
    output: out std_logic
);
end MUX2x1_1bit;

architecture arch_MUX2x1_1bit of MUX2x1_1bit is
begin
    output <= in0 when sel = '0' else in1;
end arch_MUX2x1_1bit;