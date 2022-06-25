
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
-- Mark
entity stackControlUnit is
    port (
      rst : in std_logic;
      clk : in std_logic;
      StackOldNew : in std_logic; -- select the old value (0)of the stack or the newly pushed or poped value (1)
      StackAction : in std_logic; -- pop (minus 1)(0) or push (plus 1)(1) control signal
      StackEnable: in std_logic; -- the stack enable(control signal to turn tack writing on)
      SP : out std_logic_vector(31 downto 0) -- the stack output
    ) ;
  end stackControlUnit ;

  architecture archSP of stackControlUnit is

    component SpecialStackRegister_32 is
        port(
            enable,clk,rst: in std_logic;
            d: in std_logic_vector(31 downto 0);
            q: out std_logic_vector(31 downto 0)
        );
    end component;

    Signal toStack : std_logic_vector(31 downto 0);
    Signal outStack : std_logic_vector(31 downto 0);

    -- we can either push or pop from a stack 
    -- recall that stack that the stack is down up 
    -- so pushing is minus and poping is adding
    -- push SP - 1 pop SP + 1

    begin
        toStack <= std_logic_vector(to_signed(to_integer(signed(outStack))+1 , 32)) when (StackAction = '1') -- pop the stack
        else (std_logic_vector(to_signed(to_integer(signed(outStack))-1 , 32))) when (StackAction = '0'); --push the stack

        tmpStackRegister : SpecialStackRegister_32 port map (StackEnable , clk , rst , toStack , outStack);

        SP <= (toStack)     when(StackOldNew = '1') else
              (outStack)     when(StackOldNew = '0');
    end architecture;
