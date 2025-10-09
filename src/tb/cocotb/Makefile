

#
COCOTB_DIR = $(shell pwd)
ROOT_DIR = $(COCOTB_DIR)/../../..

#
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/register_pkg.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/pcie_phys_top.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/capabilities_pkg.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/ltssm_pkg.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/multi_lane_controller.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/packet_assembly.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/data_lane_striper.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/controller/control_detect.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/controller/control_polling.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/controller/control_status_regs.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/controller/pcie_controller.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/encoders/disparity_checker.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/encoders/encoder_3b4b.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/encoders/encoder_5b6b.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/encoders/encoder_8b10b.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/linear-feedback-shift-register/linear_feedback_shift_reg.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/scrambler/scrambler.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/timer/timer.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/bin_to_gray/bin_to_gray.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/fifo/fifo.sv
VERILOG_SOURCES += $(ROOT_DIR)/src/rtl/serializer/serializer.sv


TOPLEVEL = pcie_phys_top
MODULE = tb_pcie_phys_top


# Makefile
REPO_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)

TOPLEVEL_LANG = verilog

ICARUS ?= 0

ifeq ($(ICARUS), 1)
SIM := icarus
WAVES := 1

COMPILE_ARGS += -g2012
# COMPILE_ARGS += -Wall # Enable all warnings
COMPILE_ARGS += -DICARUS
COMPILE_ARGS += -DSIMULATION=1

VERILOG_SOURCES += $(COCOTB_REDUCED_LOG_FMT)
PLUSARGS += +dumpfile=sim_build/waves.vcd

else # Verilator

SIM := verilator


SIM_ARGS +=
EXTRA_ARGS += --coverage
EXTRA_ARGS += --trace --trace-fst --trace-structs --stats

# Enable warnings
# EXTRA_ARGS +=-Wall
# EXTRA_ARGS +=-Wwarn-IMPERFECTSCH

# COMPILE_ARGS += 
COMPILE_ARGS += -DSIMULATION=1

# Uncomment to enable Verilator checks with Assertions
# COMPILE_ARGS += -DASSERTIONS_ENABLED=1

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

# include $(REPO_ROOT)/filelist.mk

CURRENT_DIR_NAME := $(notdir $(CURDIR))
MAKEFILE_DIR_NAME := $(notdir $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

.PHONY: print_dirs
print_dirs:
	@echo "Current working directory: $(CURRENT_DIR_NAME)"
	@echo "Makefile directory: $(MAKEFILE_DIR_NAME)"


.PHONY: all
all: my_rule

.PHONY: my_rule
my_rule:
	@echo "Current PATH: $$PATH"
	@echo "Repository root: $(REPO_ROOT)"


