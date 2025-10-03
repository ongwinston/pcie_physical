
# Makefile template

# Define the variable FIFO to be excluded from the filelist.mk
FIFO_INCLUDED = 1

WAVEVIEWER = surfer

VERILOG_SOURCES += $(shell pwd)/fifo.sv
VERILOG_SOURCES += $(shell pwd)/../bin_to_gray/bin_to_gray.sv
TOPLEVEL = fifo
MODULE = tb_fifo

# Makefile
# include  $(shell pwd)/../Makefile

EXTRA_ARGS += --coverage
SIM_ARGS += --trace --trace-structs
EXTRA_ARGS += --trace-fst --trace-structs

# Enable warnings
EXTRA_ARGS +=-Wall
EXTRA_ARGS +=-Wwarn-IMPERFECTSCH

# Default to using Verilator
SIM = verilator

# Adding python path
export PYTHONPATH=/home/winston/Projects/Digital-IC/pcie_physical

# Include the Cocotb Library
include $(shell cocotb-config --makefiles)/Makefile.sim


# List available targets
options:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?$$' Makefile | cut -d':' -f1 | sort | uniq


############################################################################3

# Define the variables in the Makefile
REPLACE_STR = fifo

# Use a template YS file and substitute variables
ys_file.ys: $(REPO_ROOT)/template.ys
	sed 's/@VARIABLE1@/$(REPLACE_STR)/g' $(REPO_ROOT)/template.ys > ys_file.ys

# Uncomment the following for more in place changes
# sed 's/@VARIABLE2@/$(VARIABLE2)/g' ys_file.ys > ys_file.tmp
# mv ys_file.tmp ys_file.ys

.PHONY: synthesis
synthesis: ys_file.ys
	yosys -l yosys.log -s ys_file.ys

############################################################################3

# .PHONY run-qs-synth
run-qs-synth:
	yosys qs_synth.ys

# .PHONY waves
waves:
	$(WAVEVIEWER) dump.fst &

# .PHONY superclean
superclean:
	@rm -f *.xml || echo -c
	@rm -f *.dat || echo -c
	@rm -f *.v || echo -c
	@rm -f *.svg || echo -c
	@rm -f *.png || echo -c
	@rm -f *.json || echo -c
	@rm -f *.fst || echo -c
	@rm -f ys_file.ys || echo -c
	@rm -f yosys.log || echo -c
	@rm -rf sim_build || echo -c
	@rm -rf __pycache__ || echo -c
