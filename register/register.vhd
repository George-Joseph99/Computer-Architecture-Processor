library ieee;
use ieee.std_logic_1164.all;

entity mynDFF is
GENERIC ( n : integer := 32);
PORT (
clk,rst,enable : IN std_logic;
d : IN std_logic_vector (n-1 DOWNTO 0);
q : OUT std_logic_vector (n-1 DOWNTO 0)
);
end entity;

architecture arch of mynDFF is
begin
process (clk,rst)
	begin
	if rst = '1' then
		q <= (others => '0');
	elsif rising_edge(clk) and enable = '1' then
		q <= d;
	end if;
	end process;
end arch;