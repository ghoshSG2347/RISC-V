
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu is
end tb_alu;

architecture Behavioral of tb_alu is

    signal A       : STD_LOGIC_VECTOR(31 downto 0);
    signal B       : STD_LOGIC_VECTOR(31 downto 0);
    signal ALU_Sel : STD_LOGIC_VECTOR(1 downto 0);
    signal Result  : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero    : STD_LOGIC;

begin

    DUT: entity work.alu
        port map (
            A       => A,
            B       => B,
            ALU_Sel => ALU_Sel,
            Result  => Result,
            Zero    => Zero
        );

    stimulus: process
    begin

        -- Test 1: ADD (10 + 5 = 15)
        A <= x"0000000A";
        B <= x"00000005";
        ALU_Sel <= "00";
        wait for 10 ns;

        assert Result = x"0000000F"
            report "ADD test failed"
            severity error;

        -- Test 2: SUB (10 - 5 = 5)
        ALU_Sel <= "01";
        wait for 10 ns;

        assert Result = x"00000005"
            report "SUB test failed"
            severity error;

        -- Test 3: AND
        A <= x"0000000F";
        B <= x"00000005";
        ALU_Sel <= "10";
        wait for 10 ns;

        assert Result = x"00000005"
            report "AND test failed"
            severity error;

        -- Test 4: OR
        ALU_Sel <= "11";
        wait for 10 ns;

        assert Result = x"0000000F"
            report "OR test failed"
            severity error;

        -- Test 5: Zero flag
        A <= x"00000005";
        B <= x"00000005";
        ALU_Sel <= "01";
        wait for 10 ns;

        assert Result = x"00000000" and Zero = '1'
            report "Zero flag test failed"
            severity error;

        report "ALL ALU TESTS PASSED!" severity note;

        wait;
    end process;

end Behavioral;
