library ieee;
use ieee.std_logic_1164.all;

entity MemoryWB is
    port(
        -- inputs 69 bits
        Imm_OUT_EX_MEM : in std_logic_vector(31 downto 0);
        Imm_OUT_MEM_WB : out std_logic_vector(31 downto 0);
        clk,flush,stall : in std_logic;
        MemoryData_in : in std_logic_vector(31 downto 0);
        ALU_Result_in : in std_logic_vector(31 downto 0);
        WBAddress_in : in std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_in : in std_logic;

        MemoryData_out : out std_logic_vector(31 downto 0);
        ALU_Result_out : out std_logic_vector(31 downto 0);
        WBAddress_out : out std_logic_vector(2 downto 0); --Rdst address
        RegWB_enable_out : out std_logic;
        WBValue_ALU_OR_Memory_in : in std_logic_vector(1 downto 0);
        WBValue_ALU_OR_Memory_out : out std_logic_vector(1 downto 0)
    );
end MemoryWB;

architecture arch_MemoryWB of MemoryWB is
component DFF is
generic (n : integer:= 102);
    port(
        clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0)
    );
end component;

signal dataIN : std_logic_vector(101 downto 0);
signal dataOUT : std_logic_vector(101 downto 0);
signal En : std_logic;

begin
dataIN <= Imm_OUT_EX_MEM & MemoryData_in & ALU_Result_in & WBAddress_in & RegWB_enable_in
& WBValue_ALU_OR_Memory_in;
En <= '0' when stall = '1' else '1';

reg: DFF port map(clk,flush,En,dataIN,dataOUT);

Imm_OUT_MEM_WB <= dataOUT(101 downto 70);
MemoryData_out <= dataOUT(69 downto 38);
ALU_Result_out <= dataOUT(37 downto 6);
WBAddress_out <= dataOUT(5 downto 3);
RegWB_enable_out <= dataOUT(2);
WBValue_ALU_OR_Memory_out <= dataOUT(1 downto 0);
end arch_MemoryWB;
