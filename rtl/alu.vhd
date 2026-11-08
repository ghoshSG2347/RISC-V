
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        B       : in  STD_LOGIC_VECTOR(31 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR(1 downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        Zero    : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is

    signal ALU_Result : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(A, B, ALU_Sel)
    begin

        case ALU_Sel is

            when "00" =>
                ALU_Result <= STD_LOGIC_VECTOR(
                    SIGNED(A) + SIGNED(B)
                );

            when "01" =>
                ALU_Result <= STD_LOGIC_VECTOR(
                    SIGNED(A) - SIGNED(B)
                );

            when "10" =>
                ALU_Result <= A AND B;

            when "11" =>
                ALU_Result <= A OR B;

            when others =>
                ALU_Result <= (others => '0');

        end case;

    end process;

    Result <= ALU_Result;

    Zero <= '1' when ALU_Result = x"00000000" else '0';

end Behavioral;
