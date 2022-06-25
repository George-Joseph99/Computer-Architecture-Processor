-- eng maheed told us that the stac register must 
-- be in the falling edge
library ieee;
use ieee.std_logic_1164.all;

Entity SpecialStackRegister_32 is
    port(
        enable,clk,rst: in std_logic;
        d: in std_logic_vector(31 downto 0);
        q: out std_logic_vector(31 downto 0)
    );
end SpecialStackRegister_32;


architecture a_register_sp_32 of SpecialStackRegister_32 is
    begin
        -- this all will be a process this time 
        -- a fallig edge

        process(clk, rst)
        begin
            if(rst = '1' ) then
                q<= (x"FFFFFFFF");
            elsif falling_edge(clk) then
                if(enable = '1') then
                    q<=d;
                end if;
            end if;
            end process;
    end a_register_sp_32;
