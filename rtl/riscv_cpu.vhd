
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv_cpu is
    Port (
        clk               : in  STD_LOGIC;
        reset             : in  STD_LOGIC;

        PC_Debug          : out STD_LOGIC_VECTOR(31 downto 0);
        Instruction_Debug : out STD_LOGIC_VECTOR(31 downto 0);
        ALU_Debug         : out STD_LOGIC_VECTOR(31 downto 0);

        ReadData1_Debug   : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData2_Debug   : out STD_LOGIC_VECTOR(31 downto 0);
        MemoryData_Debug  : out STD_LOGIC_VECTOR(31 downto 0);

        MemWrite_Debug    : out STD_LOGIC;
        MemRead_Debug     : out STD_LOGIC;
        BranchTaken_Debug : out STD_LOGIC
    );
end riscv_cpu;

architecture Structural of riscv_cpu is

    -- Program Counter signals
    signal PC_Current   : STD_LOGIC_VECTOR(31 downto 0);
    signal PC_Next      : STD_LOGIC_VECTOR(31 downto 0);
    signal PC_Plus4     : STD_LOGIC_VECTOR(31 downto 0);
    signal BranchTarget : STD_LOGIC_VECTOR(31 downto 0);

    -- Instruction signals
    signal Instruction : STD_LOGIC_VECTOR(31 downto 0);

    -- Register File signals
    signal ReadData1 : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData2 : STD_LOGIC_VECTOR(31 downto 0);
    signal WriteData : STD_LOGIC_VECTOR(31 downto 0);

    -- Immediate Generator
    signal Imm_Ext : STD_LOGIC_VECTOR(31 downto 0);

    -- Control Unit signals
    signal RegWrite : STD_LOGIC;
    signal ALUSrc   : STD_LOGIC;
    signal MemRead  : STD_LOGIC;
    signal MemWrite : STD_LOGIC;
    signal MemtoReg : STD_LOGIC;
    signal Branch   : STD_LOGIC;
    signal ALU_Sel  : STD_LOGIC_VECTOR(1 downto 0);

    -- ALU signals
    signal ALU_B      : STD_LOGIC_VECTOR(31 downto 0);
    signal ALU_Result : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero       : STD_LOGIC;

    -- Data Memory
    signal MemoryData : STD_LOGIC_VECTOR(31 downto 0);

    -- Branch decision
    signal BranchTaken : STD_LOGIC;

begin

    -- 1. Program Counter
    PC: entity work.program_counter
        port map (
            clk        => clk,
            reset      => reset,
            PC_Enable  => '1',
            PC_Next    => PC_Next,
            PC_Current => PC_Current
        );

    -- 2. Instruction Memory
    IM: entity work.instruction_memory
        port map (
            Address     => PC_Current,
            Instruction => Instruction
        );

    -- 3. Control Unit
    CU: entity work.control_unit
        port map (
            Opcode   => Instruction(6 downto 0),
            RegWrite => RegWrite,
            ALUSrc   => ALUSrc,
            MemRead  => MemRead,
            MemWrite => MemWrite,
            MemtoReg => MemtoReg,
            Branch   => Branch,
            ALU_Sel  => ALU_Sel
        );

    -- 4. Register File
    RF: entity work.register_file
        port map (
            clk       => clk,
            RegWrite  => RegWrite,
            ReadReg1  => Instruction(19 downto 15),
            ReadReg2  => Instruction(24 downto 20),
            WriteReg  => Instruction(11 downto 7),
            WriteData => WriteData,
            ReadData1 => ReadData1,
            ReadData2 => ReadData2
        );

    -- 5. Immediate Generator
    IG: entity work.immediate_generator
        port map (
            Instruction => Instruction,
            Imm_Ext     => Imm_Ext
        );

    -- 6. ALU input selection
    ALU_B <= Imm_Ext when ALUSrc = '1'
             else ReadData2;

    -- 7. ALU
    ALU: entity work.alu
        port map (
            A       => ReadData1,
            B       => ALU_B,
            ALU_Sel => ALU_Sel,
            Result  => ALU_Result,
            Zero    => Zero
        );

    -- 8. Data Memory
    DM: entity work.data_memory
        port map (
            clk       => clk,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            Address   => ALU_Result,
            WriteData => ReadData2,
            ReadData  => MemoryData
        );

    -- 9. Write-back selection
    WriteData <= MemoryData when MemtoReg = '1'
                 else ALU_Result;

    -- 10. Calculate next PC
    PC_Plus4 <= STD_LOGIC_VECTOR(unsigned(PC_Current) + 4);

    BranchTarget <= STD_LOGIC_VECTOR(
        signed(PC_Current) + signed(Imm_Ext)
    );

    BranchTaken <= Branch AND Zero;

    PC_Next <= BranchTarget when BranchTaken = '1'
               else PC_Plus4;

    -- Debug outputs
    PC_Debug          <= PC_Current;
    Instruction_Debug <= Instruction;
    ALU_Debug         <= ALU_Result;

    ReadData1_Debug   <= ReadData1;
    ReadData2_Debug   <= ReadData2;
    MemoryData_Debug  <= MemoryData;

    MemWrite_Debug    <= MemWrite;
    MemRead_Debug     <= MemRead;
    BranchTaken_Debug <= BranchTaken;

end Structural;
