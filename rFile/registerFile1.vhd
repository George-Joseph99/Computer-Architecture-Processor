LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY registerFile1 IS
GENERIC ( n : integer := 32);
PORT( srcEnable, distEnable : IN std_logic; 
readAddress1 ,readAddress2 : IN std_logic_vector(2 DOWNTO 0);
WriteAddress : IN std_logic_vector(2 DOWNTO 0);
dataOut1 ,dataOut2: OUT std_logic_vector(n-1 DOWNTO 0);
WriteData: IN std_logic_vector(n-1 DOWNTO 0);
clk : IN std_logic;
rst : IN std_logic);
END ENTITY;


ARCHITECTURE arch1 OF registerFile1 IS

COMPONENT DFF IS
GENERIC ( n : integer := 32);
PORT( clk,rst,enable : IN std_logic; 
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT triState IS
GENERIC ( n : integer := 32);
PORT( enable : IN std_logic; 
input : IN std_logic_vector(n-1 DOWNTO 0);
output : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT decoder3x8 IS
PORT( enable : IN std_logic; 
address : IN std_logic_vector(2 DOWNTO 0);
output : OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

signal d1Read,d2Read,d3Write : std_logic_vector(7 downto 0);
signal s0,s1,s2,s3,s4,s5,s6,s7 : std_logic_vector(n-1 downto 0);

BEGIN

dRead1: decoder3x8 PORT MAP(srcEnable,readAddress1,d1Read);
dRead2: decoder3x8 PORT MAP(srcEnable,readAddress2,d2Read);

dWrite: decoder3x8 PORT MAP(distEnable,WriteAddress,d3Write);


u0: DFF PORT MAP (clk,rst,d3Write(0),WriteData,s0);
u1: DFF PORT MAP (clk,rst,d3Write(1),WriteData,s1);
u2: DFF PORT MAP (clk,rst,d3Write(2),WriteData,s2);
u3: DFF PORT MAP (clk,rst,d3Write(3),WriteData,s3);
u4: DFF PORT MAP (clk,rst,d3Write(4),WriteData,s4);
u5: DFF PORT MAP (clk,rst,d3Write(5),WriteData,s5);
u6: DFF PORT MAP (clk,rst,d3Write(6),WriteData,s6);
u7: DFF PORT MAP (clk,rst,d3Write(7),WriteData,s7);




u8: triState PORT MAP (d1Read(0),s0,dataOut1);
u9: triState PORT MAP (d1Read(1),s1,dataOut1);
u10: triState PORT MAP (d1Read(2),s2,dataOut1);
u11: triState PORT MAP (d1Read(3),s3,dataOut1);
u12: triState PORT MAP (d1Read(4),s4,dataOut1);
u13: triState PORT MAP (d1Read(5),s5,dataOut1);
u14: triState PORT MAP (d1Read(6),s6,dataOut1);
u15: triState PORT MAP (d1Read(7),s7,dataOut1);

u16: triState PORT MAP (d2Read(0),s0,dataOut2);
u17: triState PORT MAP (d2Read(1),s1,dataOut2);
u18: triState PORT MAP (d2Read(2),s2,dataOut2);
u19: triState PORT MAP (d2Read(3),s3,dataOut2);
u20: triState PORT MAP (d2Read(4),s4,dataOut2);
u21: triState PORT MAP (d2Read(5),s5,dataOut2);
u22: triState PORT MAP (d2Read(6),s6,dataOut2);
u23: triState PORT MAP (d2Read(7),s7,dataOut2);
END arch1;
