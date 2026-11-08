library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port (
        clk       : in  STD_LOGIC;
        MemRead   : in  STD_LOGIC;
        MemWrite  : in  STD_LOGIC;
        Address   : in  STD_LOGIC_VECTOR(31 downto 0);
        WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
        ReadData  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end data_memory;

architecture Behavioral of data_memory is

    type memory_array is array (0 to 255)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal RAM : memory_array := (others => (others => '0'));

begin

    -- Read operation
    process(Address, MemRead, RAM)
        variable index : integer;
    begin
        ReadData <= (others => '0');

        if MemRead = '1' then
            if not Is_X(Address) and Address(1 downto 0) = "00" then
                index := to_integer(unsigned(Address(9 downto 2)));
                ReadData <= RAM(index);
            end if;
        end if;
    end process;

    -- Write operation
    process(clk)
        variable index : integer;
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                if not Is_X(Address) and Address(1 downto 0) = "00" then
                    index := to_integer(unsigned(Address(9 downto 2)));
                    RAM(index) <= WriteData;
                end if;
            end if;
        end if;
    end process;

end Behavioral;