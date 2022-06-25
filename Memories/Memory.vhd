library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Memory is
  port(clk                         : in std_logic;     
       WriteEnable                 : in std_logic;
       address                     : in std_logic_vector(31 downto 0);--address or PC
       datain                      : in std_logic_vector(31 downto 0); 
       dataout                     : out std_logic_vector(31 downto 0) --dataout or instruction fetched
      
      );
End Entity Memory;

Architecture arch1 of Memory IS
  type ram_data is array (0 to 1048575) of std_logic_vector(31 downto 0) ;   
  signal dataMemory       : ram_data;
  signal addressCorrected : std_logic_vector(31 downto 0);
  BEGIN
       process(clk) is
	     begin
		  addressCorrected <= "000000000000" & address(19 downto 0);
	          if falling_edge(clk) then
		           if (WriteEnable = '1') then
	              dataMemory(to_integer(unsigned(addressCorrected))) <= datain;
               end if;
            end if;
	end process;

dataout <=  dataMemory(to_integer(unsigned(addressCorrected)));
End arch1;    

