library ieee;
use ieee.std_logic_1164.all;

entity MemoryWB is
    port(
        -- inputs 69 bits
        clk,flush,stall : in std_logic;
        MemoryData_in : in std_logic_vector(31 downto 0);
        ALU_Result_in : in std_logic_vector(31 downto 0);
        WBAddress_in : in std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_in : in std_logic;

        MemoryData_out : out std_logic_vector(31 downto 0);
        ALU_Result_out : out std_logic_vector(31 downto 0);
        WBAddress_out : out std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_out : out std_logic;
        WBValue_ALU_OR_Memory_in : in std_logic;
        WBValue_ALU_OR_Memory_out : out std_logic
    );
end MemoryWB;

architecture arch_MemoryWB of MemoryWB is
component mynDFF is
generic (n : integer:= 69);
    port(
        clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0)
    );
end component;

signal dataIN : std_logic_vector(68 downto 0);
signal dataOUT : std_logic_vector(68 downto 0);
signal En : std_logic;

begin
dataIN <= MemoryData_in & ALU_Result_in & WBAddress_in & RegWB_enable_in
& WBValue_ALU_OR_Memory_in;
En <= '0' when stall = '1' else '1';

reg: mynDFF port map(clk,flush,En,dataIN,dataOUT);

MemoryData_out <= dataOUT(68 downto 37);
ALU_Result_out <= dataOUT(36 downto 5);
WBAddress_out <= dataOUT(4 downto 2);
RegWB_enable_out <= dataOUT(1);
WBValue_ALU_OR_Memory_out <= dataOUT(0);
end arch_MemoryWB;
