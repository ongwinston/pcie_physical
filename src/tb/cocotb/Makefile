

include $(REPO_ROOT)/src/tb/cocotb/filelist.mk

TOPLEVEL_LANG = verilog

ICARUS ?= 0

ifeq ($(ICARUS), 1)
SIM := icarus
WAVES := 1
COMPILE_ARGS += -g2012 # Use SystemVerilog-2012 standard
# COMPILE_ARGS += -Wall # Enable all warnings
COMPILE_ARGS += -DICARUS # Define ICARUS macro
COMPILE_ARGS += -DSIMULATION=1 # Define ICARUS macro
VERILOG_SOURCES += $(COCOTB_REDUCED_LOG_FMT)
PLUSARGS += +dumpfile=sim_build/waves.vcd

else # Verilator

EXTRA_ARGS += --coverage
SIM_ARGS += --trace --trace-structs
EXTRA_ARGS += --trace-fst --trace-structs

# Enable warnings
# EXTRA_ARGS +=-Wall
# EXTRA_ARGS +=-Wwarn-IMPERFECTSCH

# Default to using Verilator
SIM := verilator

# COMPILE_ARGS += 
COMPILE_ARGS += -DSIMULATION=1 # Define ICARUS macro

endif

# Set surfer to default waveviewer
ifeq ($(GTKWAVE), 1)
WAVEVIEWER=gtkwave
else
WAVEVIEWER=surfer
endif

# Adding python path
export PYTHONPATH=/home/winston/Projects/Digital-IC/pcie_physical

include $(shell cocotb-config --makefiles)/Makefile.sim

