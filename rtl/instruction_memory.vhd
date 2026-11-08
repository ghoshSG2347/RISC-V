library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    Port (
        Address     : in  STD_LOGIC_VECTOR(31 downto 0);
        Instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is

    type memory_array is array (0 to 255)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal ROM : memory_array := (
        0 => x"002081B3", -- ADD x3, x1, x2
        1 => x"00322023", -- SW x3, 0(x4)
        2 => x"00022283", -- LW x5, 0(x4)
        3 => x"00518463", -- BEQ x3, x5, +8
        others => x"00000013"
    );

begin

    process(Address)
        variable index : integer;
    begin

        -- Handle undefined addresses
        if Is_X(Address) then
            Instruction <= x"00000013";

        -- Check address range and alignment
        elsif Address(31 downto 10) = (31 downto 10 => '0')
          and Address(1 downto 0) = "00" then

            index := to_integer(unsigned(Address(9 downto 2)));
            Instruction <= ROM(index);

        else
            Instruction <= x"00000013";
        end if;

    end process;

end Behavioral;