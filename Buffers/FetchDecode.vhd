library ieee;
use ieee.std_logic_1164.all;

entity FetchDecode is
    port(
        -- inputs
        clk,stall,flush : in std_logic;
        -- stall comes from hazard detection unit
        -- flush comes from control unit
        PC_Added_in : in std_logic_vector(31 downto 0);
        instruction_in : in std_logic_vector(31 downto 0);
        inport_in : in std_logic_vector(31 downto 0);
        -- outputs
        PC_Added_out : out std_logic_vector(31 downto 0);
        instruction_out : out std_logic_vector(31 downto 0);
        inport_out : out std_logic_vector(31 downto 0)
    );
end FetchDecode;

architecture arch_FetchDecode of FetchDecode is
component DFF is
generic (n : integer:= 96);
    port(
        clk,rst,enable : in std_logic;
        d : in std_logic_vector(n-1 downto 0);
        q : out std_logic_vector(n-1 downto 0)
    );
end component;

signal dataIn : std_logic_vector(95 downto 0);
signal dataOut : std_logic_vector(95 downto 0);
signal En : std_logic;

begin 
dataIn <= PC_Added_in & instruction_in & inport_in;
En <= '0' when stall = '1' else '1';

Reg: DFF port map(clk,flush,En,dataIn,dataOut);

PC_Added_out <= dataOut(95 downto 64);
instruction_out <= dataOut(63 downto 32);
inport_out <= dataOut(31 downto 0);
end arch_FetchDecode;
