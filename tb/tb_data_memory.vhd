library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_data_memory is
end tb_data_memory;

architecture Test of tb_data_memory is

    signal clk       : STD_LOGIC := '0';
    signal MemRead   : STD_LOGIC := '0';
    signal MemWrite  : STD_LOGIC := '0';
    signal Address   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal WriteData : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ReadData  : STD_LOGIC_VECTOR(31 downto 0);

begin

    DUT: entity work.data_memory
        port map (
            clk       => clk,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            Address   => Address,
            WriteData => WriteData,
            ReadData  => ReadData
        );

    -- Clock generation
    clk <= not clk after 5 ns;

    process
    begin

        -- Test 1: Write 100 into memory address 0
        Address   <= x"00000000";
        WriteData <= x"00000064";
        MemWrite  <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Test 2: Read memory address 0
        MemWrite <= '0';
        MemRead  <= '1';

        wait for 1 ns;

        assert ReadData = x"00000064"
            report "Test 1 FAILED: Memory read mismatch"
            severity error;

        -- Test 3: Write 200 into memory address 4
        Address   <= x"00000004";
        WriteData <= x"000000C8";
        MemRead   <= '0';
        MemWrite  <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Test 4: Read memory address 4
        MemWrite <= '0';
        MemRead  <= '1';

        wait for 1 ns;

        assert ReadData = x"000000C8"
            report "Test 2 FAILED: Second memory read mismatch"
            severity error;

        -- Test 5: Verify first memory location remains unchanged
        Address <= x"00000000";

        wait for 1 ns;

        assert ReadData = x"00000064"
            report "Test 3 FAILED: First memory location changed"
            severity error;

        -- Test 6: Disable reading
        MemRead <= '0';

        wait for 1 ns;

        assert ReadData = x"00000000"
            report "Test 4 FAILED: Read disable mismatch"
            severity error;

        report "ALL DATA MEMORY TESTS PASSED!" severity note;

        wait;
    end process;

end Test;