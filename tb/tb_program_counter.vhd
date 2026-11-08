
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_program_counter is
end tb_program_counter;

architecture Behavioral of tb_program_counter is

    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '0';
    signal PC_Enable  : STD_LOGIC := '1';
    signal PC_Next    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal PC_Current : STD_LOGIC_VECTOR(31 downto 0);

begin

    DUT: entity work.program_counter
        port map (
            clk        => clk,
            reset      => reset,
            PC_Enable  => PC_Enable,
            PC_Next    => PC_Next,
            PC_Current => PC_Current
        );

    -- Clock generation
    clk <= not clk after 5 ns;

    stimulus: process
    begin

        -- Test 1: Reset PC to zero
        reset <= '1';
        wait for 2 ns;

        assert PC_Current = x"00000000"
            report "PC reset failed"
            severity error;

        reset <= '0';

        -- Test 2: Load address 4
        PC_Next <= x"00000004";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Current = x"00000004"
            report "PC update to 4 failed"
            severity error;

        -- Test 3: Load address 8
        PC_Next <= x"00000008";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Current = x"00000008"
            report "PC update to 8 failed"
            severity error;

        -- Test 4: Disable PC update
        PC_Enable <= '0';
        PC_Next <= x"0000000C";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Current = x"00000008"
            report "PC enable control failed"
            severity error;

        -- Test 5: Re-enable PC update
        PC_Enable <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Current = x"0000000C"
            report "PC re-enable failed"
            severity error;

        report "ALL PROGRAM COUNTER TESTS PASSED!"
            severity note;

        wait;
    end process;

end Behavioral;
