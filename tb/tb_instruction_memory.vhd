library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_instruction_memory is
end tb_instruction_memory;

architecture Test of tb_instruction_memory is

    signal Address     : STD_LOGIC_VECTOR(31 downto 0);
    signal Instruction : STD_LOGIC_VECTOR(31 downto 0);

begin

    DUT: entity work.instruction_memory
        port map (
            Address     => Address,
            Instruction => Instruction
        );

    process
    begin
        -- Test 1: Fetch ADD x3, x1, x2
        Address <= x"00000000";
        wait for 10 ns;

        assert Instruction = x"002081B3"
            report "Test 1 FAILED: ADD instruction mismatch"
            severity error;

        -- Test 2: Fetch SW x3, 0(x4)
        Address <= x"00000004";
        wait for 10 ns;

        assert Instruction = x"00322023"
            report "Test 2 FAILED: SW instruction mismatch"
            severity error;

        -- Test 3: Fetch LW x5, 0(x4)
        Address <= x"00000008";
        wait for 10 ns;

        assert Instruction = x"00022283"
            report "Test 3 FAILED: LW instruction mismatch"
            severity error;

        -- Test 4: Fetch BEQ x3, x5, +8
        Address <= x"0000000C";
        wait for 10 ns;

        assert Instruction = x"00518463"
            report "Test 4 FAILED: BEQ instruction mismatch"
            severity error;

        -- Test 5: Fetch an unused location (NOP)
        Address <= x"00000010";
        wait for 10 ns;

        assert Instruction = x"00000013"
            report "Test 5 FAILED: NOP instruction mismatch"
            severity error;

        report "ALL INSTRUCTION MEMORY TESTS PASSED!" severity note;

        wait;
    end process;

end Test;