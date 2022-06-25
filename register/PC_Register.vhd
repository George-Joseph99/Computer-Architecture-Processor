
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity PC_Register is 
	port (
    clk: in std_logic;
    stall: in std_logic;
    In_PC: in std_logic_vector (31 downto 0);
    Out_PC: out std_logic_vector (31 downto 0));
end PC_Register;     


architecture arch1 of PC_Register is

component DFF IS
	GENERIC ( n : integer := 32);
	PORT( clk,rst,enable : IN std_logic; 
	d : IN std_logic_vector(n-1 DOWNTO 0);
	q : OUT std_logic_vector(n-1 DOWNTO 0));
	END component;


signal DataIN: std_logic_vector (31 downto 0);
signal DataOut: std_logic_vector (31 downto 0);
signal Enable: std_logic;

begin

PC_Register: DFF generic map (32) Port map (clk,'0',Enable,DataIN,DataOut);
Enable <= '0' when (stall = '1') 
else      '1';

DataIN <= In_PC;
Out_PC <= DataOut;



end arch1; 




