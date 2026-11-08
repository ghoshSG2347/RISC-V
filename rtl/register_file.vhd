library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        clk       : in  STD_LOGIC;
        RegWrite  : in  STD_LOGIC;
        ReadReg1  : in  STD_LOGIC_VECTOR(4 downto 0);
        ReadReg2  : in  STD_LOGIC_VECTOR(4 downto 0);
        WriteReg  : in  STD_LOGIC_VECTOR(4 downto 0);
        WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
        ReadData1 : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is

    type register_array is array (0 to 31)
        of STD_LOGIC_VECTOR(31 downto 0);

    signal registers : register_array := (
        1 => x"0000000A",
        2 => x"00000014",
        others => (others => '0')
    );

begin

    -- Register write operation
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite = '1' then
                if not Is_X(WriteReg) then
                    if WriteReg /= "00000" then
                        registers(to_integer(unsigned(WriteReg))) <= WriteData;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Register read operation
    process(ReadReg1, ReadReg2, registers)
    begin
        if Is_X(ReadReg1) then
            ReadData1 <= (others => '0');
        else
            ReadData1 <= registers(to_integer(unsigned(ReadReg1)));
        end if;

        if Is_X(ReadReg2) then
            ReadData2 <= (others => '0');
        else
            ReadData2 <= registers(to_integer(unsigned(ReadReg2)));
        end if;
    end process;

end Behavioral;