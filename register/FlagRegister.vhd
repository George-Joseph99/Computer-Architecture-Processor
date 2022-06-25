
library ieee;
use ieee.std_logic_1164.all;

entity FlagRegister is
    port(clk,rst,enable:in std_logic; 
    ZF_In: in std_logic;
    NF_In: in std_logic;
    CF_In: in std_logic;

    ZF_Out: Out std_logic;
    NF_Out: Out std_logic;
    CF_Out: Out std_logic);
end FlagRegister;

architecture arch1 of FlagRegister is
	component DFF IS
	GENERIC ( n : integer := 32);
	PORT( clk,rst,enable : IN std_logic; 
	d : IN std_logic_vector(n-1 DOWNTO 0);
	q : OUT std_logic_vector(n-1 DOWNTO 0));
	END component;

    
    Signal DataIn: std_logic_vector (2 downto 0);
    signal DataOut: std_logic_vector (2 downto 0);
begin
   DataIn <= ZF_In & NF_In & CF_In;
   Flags: DFF generic map (3) port map(clk,rst,enable,DataIn,DataOut);

   ZF_Out<= DataOut(2);
   NF_Out<= DataOut(1);
   CF_Out<= DataOut(0);

end arch1;


