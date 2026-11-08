library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity immediate_generator is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(31 downto 0);
        Imm_Ext      : out STD_LOGIC_VECTOR(31 downto 0)
    );
end immediate_generator;

architecture Behavioral of immediate_generator is

begin

    process(Instruction)
    begin

        case Instruction(6 downto 0) is

            -- I-type immediate (LW)
            when "0000011" =>
                Imm_Ext <= (31 downto 12 => Instruction(31)) &
                           Instruction(31 downto 20);

            -- S-type immediate (SW)
            when "0100011" =>
                Imm_Ext <= (31 downto 12 => Instruction(31)) &
                           Instruction(31 downto 25) &
                           Instruction(11 downto 7);

            -- B-type immediate (BEQ)
            when "1100011" =>
                Imm_Ext <= (31 downto 13 => Instruction(31)) &
                           Instruction(31) &
                           Instruction(7) &
                           Instruction(30 downto 25) &
                           Instruction(11 downto 8) &
                           '0';

            -- Unsupported instruction
            when others =>
                Imm_Ext <= (others => '0');

        end case;

    end process;

end Behavioral;