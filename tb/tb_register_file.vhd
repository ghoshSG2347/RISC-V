
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_register_file is
end tb_register_file;

architecture Behavioral of tb_register_file is

    signal clk       : STD_LOGIC := '0';
    signal RegWrite  : STD_LOGIC := '0';

    signal ReadReg1  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal ReadReg2  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal WriteReg  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

    signal WriteData : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal ReadData1 : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData2 : STD_LOGIC_VECTOR(31 downto 0);

begin

    DUT: entity work.register_file
        port map (
            clk       => clk,
            RegWrite  => RegWrite,
            ReadReg1  => ReadReg1,
            ReadReg2  => ReadReg2,
            WriteReg  => WriteReg,
            WriteData => WriteData,
            ReadData1 => ReadData1,
            ReadData2 => ReadData2
        );

    -- Clock generation
    clk <= not clk after 5 ns;

    stimulus: process
    begin

        -- Test 1: Write 100 into register x1
        RegWrite  <= '1';
        WriteReg  <= "00001";
        WriteData <= x"00000064";

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Test 2: Read register x1
        RegWrite <= '0';
        ReadReg1 <= "00001";

        wait for 1 ns;

        assert ReadData1 = x"00000064"
            report "Register x1 read failed"
            severity error;

        -- Test 3: Write 200 into register x2
        RegWrite  <= '1';
        WriteReg  <= "00010";
        WriteData <= x"000000C8";

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Test 4: Read both registers
        RegWrite <= '0';
        ReadReg1 <= "00001";
        ReadReg2 <= "00010";

        wait for 1 ns;

        assert ReadData1 = x"00000064"
            report "Register x1 value incorrect"
            severity error;

        assert ReadData2 = x"000000C8"
            report "Register x2 value incorrect"
            severity error;

        -- Test 5: Attempt to write into x0
        RegWrite  <= '1';
        WriteReg  <= "00000";
        WriteData <= x"000003E8";

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Test 6: Verify x0 remains zero
        RegWrite <= '0';
        ReadReg1 <= "00000";

        wait for 1 ns;

        assert ReadData1 = x"00000000"
            report "Register x0 zero protection failed"
            severity error;

        report "ALL REGISTER FILE TESTS PASSED!"
            severity note;

        wait;
    end process;

end Behavioral;
