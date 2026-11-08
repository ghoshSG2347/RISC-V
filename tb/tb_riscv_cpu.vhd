
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_riscv_cpu is
end tb_riscv_cpu;

architecture Test of tb_riscv_cpu is

    signal clk               : STD_LOGIC := '0';
    signal reset             : STD_LOGIC := '1';

    signal PC_Debug          : STD_LOGIC_VECTOR(31 downto 0);
    signal Instruction_Debug : STD_LOGIC_VECTOR(31 downto 0);
    signal ALU_Debug         : STD_LOGIC_VECTOR(31 downto 0);

    signal ReadData1_Debug   : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData2_Debug   : STD_LOGIC_VECTOR(31 downto 0);
    signal MemoryData_Debug  : STD_LOGIC_VECTOR(31 downto 0);

    signal MemWrite_Debug    : STD_LOGIC;
    signal MemRead_Debug     : STD_LOGIC;
    signal BranchTaken_Debug : STD_LOGIC;

begin

    DUT: entity work.riscv_cpu
        port map (
            clk               => clk,
            reset             => reset,

            PC_Debug          => PC_Debug,
            Instruction_Debug => Instruction_Debug,
            ALU_Debug         => ALU_Debug,

            ReadData1_Debug   => ReadData1_Debug,
            ReadData2_Debug   => ReadData2_Debug,
            MemoryData_Debug  => MemoryData_Debug,

            MemWrite_Debug    => MemWrite_Debug,
            MemRead_Debug     => MemRead_Debug,
            BranchTaken_Debug => BranchTaken_Debug
        );

    -- Generate clock
    clk <= not clk after 5 ns;

    process
    begin

        -- Keep processor in reset initially
        reset <= '1';
        wait for 12 ns;
        reset <= '0';

        -- Cycle 1: ADD x3, x1, x2
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Debug = x"00000004"
            report "ADD cycle FAILED"
            severity error;

        assert Instruction_Debug = x"00322023"
            report "SW instruction fetch FAILED"
            severity error;

        -- Verify x3 received the ADD result (10 + 20 = 30)
        assert ReadData2_Debug = x"0000001E"
            report "ADD register write FAILED: x3 is not 30"
            severity error;

        -- Cycle 2: SW x3, 0(x4)
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Debug = x"00000008"
            report "SW cycle FAILED"
            severity error;

        assert Instruction_Debug = x"00022283"
            report "LW instruction fetch FAILED"
            severity error;

        -- Verify memory read control and stored data
        assert MemoryData_Debug = x"0000001E"
            report "SW FAILED: memory does not contain 30"
            severity error;

        -- Cycle 3: LW x5, 0(x4)
        wait until rising_edge(clk);
        wait for 1 ns;

        assert PC_Debug = x"0000000C"
            report "LW cycle FAILED"
            severity error;

        assert Instruction_Debug = x"00518463"
            report "BEQ instruction fetch FAILED"
            severity error;

        -- Verify x3 and x5 both contain 30
        assert ReadData1_Debug = x"0000001E"
            report "Register x3 value FAILED"
            severity error;

        assert ReadData2_Debug = x"0000001E"
            report "LW FAILED: register x5 did not receive 30"
            severity error;

        -- Verify branch condition before the branch clock edge
        assert BranchTaken_Debug = '1'
            report "BEQ condition FAILED"
            severity error;

        -- Cycle 4: BEQ x3, x5, +8
        wait until rising_edge(clk);
        wait for 1 ns;

        -- Branch should jump from address 12 to address 20
        assert PC_Debug = x"00000014"
            report "BEQ branch FAILED"
            severity error;

        report "ALL CPU DATA AND CONTROL TESTS PASSED!"
            severity note;

        wait;
    end process;

end Test;
