LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY decoder3x8 IS

PORT( enable : IN std_logic; 
address : IN std_logic_vector(2 DOWNTO 0);
output : OUT std_logic_vector(7 DOWNTO 0));
END ENTITY;


ARCHITECTURE arch1 OF decoder3x8 IS

BEGIN

PROCESS(address, enable)
BEGIN
IF(enable ='0') THEN
	output <=  (OTHERS=>'0');
ELSIF (enable = '1') THEN
	IF (address="000") THEN output<="00000001";
	ELSIF (address="001") THEN output<="00000010";
	ELSIF (address="010") THEN output<="00000100";
	ELSIF (address="011") THEN output<="00001000";
	ELSIF (address="100") THEN output<="00010000";
	ELSIF (address="101") THEN output<="00100000";
	ELSIF (address="110") THEN output<="01000000";
	ELSIF (address="111") THEN output<="10000000";
	END IF;
END IF;
END PROCESS;

END arch1;
