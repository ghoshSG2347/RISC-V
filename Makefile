
GHDL = ghdl
GTKWAVE = gtkwave
STD = --std=08
WORKDIR = --workdir=build

RTL = \
	rtl/alu.vhd \
	rtl/register_file.vhd \
	rtl/program_counter.vhd \
	rtl/instruction_memory.vhd \
	rtl/data_memory.vhd \
	rtl/immediate_generator.vhd \
	rtl/control_unit.vhd \
	rtl/riscv_cpu.vhd

TESTBENCHES = \
	tb/tb_alu.vhd \
	tb/tb_register_file.vhd \
	tb/tb_program_counter.vhd \
	tb/tb_instruction_memory.vhd \
	tb/tb_data_memory.vhd \
	tb/tb_immediate_generator.vhd \
	tb/tb_control_unit.vhd \
	tb/tb_riscv_cpu.vhd

TESTS = \
	tb_alu \
	tb_register_file \
	tb_program_counter \
	tb_instruction_memory \
	tb_data_memory \
	tb_immediate_generator \
	tb_control_unit \
	tb_riscv_cpu

.PHONY: help build analyze test sim wave tools clean

help:
	@echo "RISC-V CPU Project Commands"
	@echo "  make tools    - Show installed tool versions"
	@echo "  make analyze  - Compile all source files"
	@echo "  make test     - Run all testbenches"
	@echo "  make sim      - Run CPU simulation and generate VCD"
	@echo "  make wave     - Open waveform in GTKWave"
	@echo "  make clean    - Remove generated build files"

build:
	mkdir -p build

analyze: build
	$(GHDL) -a $(STD) $(WORKDIR) $(RTL) $(TESTBENCHES)

test: analyze
	@for tb in $(TESTS); do \
		echo ""; \
		echo "========== Testing $$tb =========="; \
		$(GHDL) -e $(STD) $(WORKDIR) $$tb || exit 1; \
		$(GHDL) -r $(STD) $(WORKDIR) $$tb --stop-time=1us --assert-level=error || exit 1; \
	done
	@echo ""
	@echo "========== ALL TESTS PASSED =========="

sim: analyze
	$(GHDL) -e $(STD) $(WORKDIR) tb_riscv_cpu
	$(GHDL) -r $(STD) $(WORKDIR) tb_riscv_cpu --vcd=build/riscv_cpu.vcd

wave: sim
	$(GTKWAVE) build/riscv_cpu.vcd

tools:
	$(GHDL) --version
	$(GTKWAVE) --version
	$(MAKE) --version

clean:
	rm -rf build/*
	rm -f work-obj*.cf *.cf *.vcd *.ghw
