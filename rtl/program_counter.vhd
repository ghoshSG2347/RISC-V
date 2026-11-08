
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        PC_Enable : in  STD_LOGIC;
        PC_Next   : in  STD_LOGIC_VECTOR(31 downto 0);
        PC_Current: out STD_LOGIC_VECTOR(31 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is

    signal PC_Register : STD_LOGIC_VECTOR(31 downto 0)
        := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            PC_Register <= (others => '0');

        elsif rising_edge(clk) then
            if PC_Enable = '1' then
                PC_Register <= PC_Next;
            end if;
        end if;
    end process;

    PC_Current <= PC_Register;

end Behavioral;
