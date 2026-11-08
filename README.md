# Single-Cycle RISC-V Processor in VHDL

A basic 32-bit single-cycle RISC-V processor implemented using **VHDL** and simulated with **GHDL**. GTKWave is used to visualize and inspect the processor's internal signals and execution behaviour.

## 1. Project Overview

This project implements an educational RISC-V processor that supports a basic subset of instructions:

- **ADD** – Performs integer addition.
- **LW** – Loads a 32-bit word from data memory into a register.
- **SW** – Stores a 32-bit word from a register into data memory.
- **BEQ** – Performs a conditional branch if two registers are equal.

The processor follows a single-cycle architecture, meaning each supported instruction completes its execution in one clock cycle.

The project demonstrates the fundamental working principles of a processor, including instruction fetching, decoding, execution, memory access, register operations and branch handling.

> **Note:** This is an educational implementation of a subset of the RISC-V instruction set, not a complete RV32I processor.

## 2. Features

- 32-bit datapath.
- Single-cycle processor architecture.
- 32 general-purpose registers (x0–x31).
- x0 is hardwired to zero.
- Arithmetic and logical operations through the ALU.
- Instruction decoding through a Control Unit.
- Immediate generation for I-type, S-type and B-type instructions.
- Instruction Memory and Data Memory.
- Conditional branching using BEQ.
- Modular hardware design using separate VHDL entities.
- Individual component testbenches.
- Complete CPU integration testbench.
- Waveform generation and inspection using GTKWave.

## 3. Supported Instructions

| Instruction | Operation | Description |
|---|---|---|
| ADD | `rd = rs1 + rs2` | Adds two register values. |
| LW | `rd = Memory[rs1 + imm]` | Loads a word from memory. |
| SW | `Memory[rs1 + imm] = rs2` | Stores a word into memory. |
| BEQ | `if (rs1 == rs2)` | Branches when two register values are equal. |

## 4. Processor Architecture

The processor consists of the following major components:

| Component | Responsibility |
|---|---|
| Program Counter (PC) | Holds the address of the current instruction. |
| Instruction Memory | Stores and provides instructions. |
| Control Unit | Decodes instructions and generates control signals. |
| Register File | Provides source operands and stores register results. |
| Immediate Generator | Extracts and sign-extends instruction immediates. |
| ALU | Performs arithmetic and logical operations. |
| Data Memory | Handles load and store operations. |
| Branch Logic | Determines whether a conditional branch is taken. |

### Instruction Execution Flow

1. **Instruction Fetch:** The Program Counter provides the instruction address.
2. **Instruction Decode:** The Control Unit identifies the instruction and generates control signals.
3. **Operand Read:** The Register File provides the required source operands.
4. **Execution:** The ALU performs the required operation or calculates a memory/branch address.
5. **Memory Access:** LW reads from Data Memory; SW writes to Data Memory.
6. **Write Back:** The result is written into the destination register when required.
7. **PC Update:** The Program Counter selects the next sequential instruction or branch destination.

All these stages are designed to complete within a single clock cycle.

## 5. Project Structure

```text
RISC-V/
│
├── rtl/
│   ├── alu.vhd
│   ├── register_file.vhd
│   ├── program_counter.vhd
│   ├── instruction_memory.vhd
│   ├── data_memory.vhd
│   ├── immediate_generator.vhd
│   ├── control_unit.vhd
│   └── riscv_cpu.vhd
│
├── tb/
│   ├── tb_alu.vhd
│   ├── tb_register_file.vhd
│   ├── tb_program_counter.vhd
│   ├── tb_instruction_memory.vhd
│   ├── tb_data_memory.vhd
│   ├── tb_immediate_generator.vhd
│   ├── tb_control_unit.vhd
│   └── tb_riscv_cpu.vhd
│
├── build/
│   └── Generated simulation and compilation files
│
├── sim/
├── docs/
├── reports/
├── scripts/
│
├── Makefile
└── README.md
```

## 6. Tools and Technologies

| Tool | Purpose |
|---|---|
| VHDL | Hardware description language |
| GHDL | VHDL analysis, elaboration and simulation |
| GTKWave | Waveform visualization |
| GNU Make | Automating build and simulation commands |

### Prerequisites

Install the following tools on a Linux system:

- GHDL
- GTKWave
- GNU Make

Check their availability:

```bash
ghdl --version
gtkwave --version
make --version
```

## 7. Compilation and Simulation

Run the following commands from the project root directory.

### Compile the source files

```bash
make analyze
```

### Run all testbenches

```bash
make test
```

This command compiles and executes all eight testbenches, including the complete CPU integration testbench.

Expected final message:

```text
========== ALL TESTS PASSED ==========
```

### Run the CPU simulation

```bash
make sim
```

This generates the waveform file:

```text
build/riscv_cpu.vcd
```

### Open the waveform

```bash
gtkwave build/riscv_cpu.vcd
```

### Display available commands

```bash
make help
```

### Clean generated build files

```bash
make clean
```

## 8. Demonstration Program

The current instruction memory contains a predefined demonstration program.

Initial register values:

- x1 = 10
- x2 = 20
- x4 = 0

The program executes the following instructions:

| PC | Instruction | Expected Result |
|---|---|---|
| 0 | ADD x3, x1, x2 | x3 = 30 |
| 4 | SW x3, 0(x4) | Memory[0] = 30 |
| 8 | LW x5, 0(x4) | x5 = 30 |
| 12 | BEQ x3, x5, +8 | Branch taken |
| 20 | NOP | Execution reaches branch destination |

The BEQ instruction compares x3 and x5. Since both contain 30, the branch is taken and execution continues at PC = 20, skipping the instruction at PC = 16.

## 9. Verification and Testing

The project contains eight testbenches:

1. ALU testbench
2. Register File testbench
3. Program Counter testbench
4. Instruction Memory testbench
5. Data Memory testbench
6. Immediate Generator testbench
7. Control Unit testbench
8. Complete CPU integration testbench

The integration testbench checks the execution of the demonstration program, including arithmetic results, memory data, operand values and conditional branch behaviour.

**Verification status:** All eight testbenches passed in the current simulation run.

## 10. Waveform Inspection

GTKWave can be used to observe the processor's internal signals.

Important signals include:

- `PC_Debug`
- `Instruction_Debug`
- `ALU_Debug`
- `ReadData1_Debug`
- `ReadData2_Debug`
- `MemoryData_Debug`
- `MemWrite_Debug`
- `MemRead_Debug`
- `BranchTaken_Debug`

These signals help verify instruction execution, register operands, memory operations and branch decisions.

## 11. Project Limitations

This implementation is intended for educational purposes.

- It supports only the implemented instruction subset: ADD, LW, SW and BEQ.
- It does not implement the complete RV32I instruction set.
- The demonstration program is predefined in Instruction Memory.
- Register initialization is provided for simulation.
- The implementation does not include pipelining, interrupts or exception handling.
- Memory access is limited to the implemented memory design.

## 12. Conclusion

This project demonstrates the design and simulation of a basic single-cycle RISC-V processor using VHDL.

By implementing the major datapath and control components separately and integrating them into a complete processor, the project provides practical insight into processor architecture, instruction execution, memory operations and conditional branching.

GHDL and GTKWave are used to verify and visualize the processor's behaviour.