LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY DFF IS
GENERIC ( n : integer := 32);
PORT( clk,rst,enable : IN std_logic; 
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE arch1 OF DFF IS
BEGIN
PROCESS(clk,rst)
BEGIN
IF(rst = '1') THEN
	q <=  (OTHERS=>'0');
ELSIF rising_edge(clk) THEN
	IF(enable= '1')THEN
		q <= d;
	END IF;
END IF;
END PROCESS;
END arch1;
