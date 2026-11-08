library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_immediate_generator is
end tb_immediate_generator;

architecture Test of tb_immediate_generator is

    signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
    signal Imm_Ext     : STD_LOGIC_VECTOR(31 downto 0);

begin

    DUT: entity work.immediate_generator
        port map (
            Instruction => Instruction,
            Imm_Ext      => Imm_Ext
        );

    process
    begin

        -- Test 1: LW x5, 0(x4)
        Instruction <= x"00022283";
        wait for 10 ns;

        assert Imm_Ext = x"00000000"
            report "Test 1 FAILED: LW immediate mismatch"
            severity error;

        -- Test 2: SW x3, 0(x4)
        Instruction <= x"00322023";
        wait for 10 ns;

        assert Imm_Ext = x"00000000"
            report "Test 2 FAILED: SW immediate mismatch"
            severity error;

        -- Test 3: BEQ x3, x5, +8
        Instruction <= x"00518463";
        wait for 10 ns;

        assert Imm_Ext = x"00000008"
            report "Test 3 FAILED: BEQ immediate mismatch"
            severity error;

        -- Test 4: LW with negative immediate (-4)
        Instruction <= x"FFC22283";
        wait for 10 ns;

        assert Imm_Ext = x"FFFFFFFC"
            report "Test 4 FAILED: Negative LW immediate mismatch"
            severity error;

        report "ALL IMMEDIATE GENERATOR TESTS PASSED!" severity note;

        wait;
    end process;

end Test;