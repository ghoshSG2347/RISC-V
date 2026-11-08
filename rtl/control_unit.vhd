library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        Opcode   : in  STD_LOGIC_VECTOR(6 downto 0);

        RegWrite : out STD_LOGIC;
        ALUSrc   : out STD_LOGIC;
        MemRead  : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        Branch   : out STD_LOGIC;
        ALU_Sel  : out STD_LOGIC_VECTOR(1 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is

begin

    process(Opcode)
    begin

        -- Default control signals
        RegWrite <= '0';
        ALUSrc   <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        Branch   <= '0';
        ALU_Sel  <= "00";

        case Opcode is

            -- R-type: ADD
            when "0110011" =>
                RegWrite <= '1';
                ALU_Sel  <= "00";

            -- I-type: LW
            when "0000011" =>
                RegWrite <= '1';
                ALUSrc   <= '1';
                MemRead  <= '1';
                MemtoReg <= '1';
                ALU_Sel  <= "00";

            -- S-type: SW
            when "0100011" =>
                ALUSrc   <= '1';
                MemWrite <= '1';
                ALU_Sel  <= "00";

            -- B-type: BEQ
            when "1100011" =>
                Branch  <= '1';
                ALU_Sel <= "01";

            -- Unsupported instruction
            when others =>
                null;

        end case;

    end process;

end Behavioral;