library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture Test of tb_control_unit is

    signal Opcode   : STD_LOGIC_VECTOR(6 downto 0);

    signal RegWrite : STD_LOGIC;
    signal ALUSrc   : STD_LOGIC;
    signal MemRead  : STD_LOGIC;
    signal MemWrite : STD_LOGIC;
    signal MemtoReg : STD_LOGIC;
    signal Branch   : STD_LOGIC;
    signal ALU_Sel  : STD_LOGIC_VECTOR(1 downto 0);

begin

    DUT: entity work.control_unit
        port map (
            Opcode   => Opcode,
            RegWrite => RegWrite,
            ALUSrc   => ALUSrc,
            MemRead  => MemRead,
            MemWrite => MemWrite,
            MemtoReg => MemtoReg,
            Branch   => Branch,
            ALU_Sel  => ALU_Sel
        );

    process
    begin

        -- Test 1: ADD (R-type)
        Opcode <= "0110011";
        wait for 10 ns;

        assert RegWrite = '1' and
               ALUSrc = '0' and
               MemRead = '0' and
               MemWrite = '0' and
               MemtoReg = '0' and
               Branch = '0' and
               ALU_Sel = "00"
            report "ADD control test FAILED"
            severity error;

        -- Test 2: LW
        Opcode <= "0000011";
        wait for 10 ns;

        assert RegWrite = '1' and
               ALUSrc = '1' and
               MemRead = '1' and
               MemWrite = '0' and
               MemtoReg = '1' and
               Branch = '0' and
               ALU_Sel = "00"
            report "LW control test FAILED"
            severity error;

        -- Test 3: SW
        Opcode <= "0100011";
        wait for 10 ns;

        assert RegWrite = '0' and
               ALUSrc = '1' and
               MemRead = '0' and
               MemWrite = '1' and
               MemtoReg = '0' and
               Branch = '0' and
               ALU_Sel = "00"
            report "SW control test FAILED"
            severity error;

        -- Test 4: BEQ
        Opcode <= "1100011";
        wait for 10 ns;

        assert RegWrite = '0' and
               ALUSrc = '0' and
               MemRead = '0' and
               MemWrite = '0' and
               MemtoReg = '0' and
               Branch = '1' and
               ALU_Sel = "01"
            report "BEQ control test FAILED"
            severity error;

        -- Test 5: Unsupported instruction
        Opcode <= "1111111";
        wait for 10 ns;

        assert RegWrite = '0' and
               ALUSrc = '0' and
               MemRead = '0' and
               MemWrite = '0' and
               MemtoReg = '0' and
               Branch = '0' and
               ALU_Sel = "00"
            report "Default control test FAILED"
            severity error;

        report "ALL CONTROL UNIT TESTS PASSED!" severity note;

        wait;
    end process;

end Test;