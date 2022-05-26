LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY triState IS
GENERIC ( n : integer := 32);
PORT( enable : IN std_logic; 
input : IN std_logic_vector(n-1 DOWNTO 0);
output : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY;


ARCHITECTURE arch1 OF triState IS
BEGIN
output<= input when enable='1'
else (OTHERS=>'Z');
END arch1;
