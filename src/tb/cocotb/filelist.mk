
#
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/pcie_phys_top.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/capabilities_pkg.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/ltssm_pkg.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/multi_lane_controller.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/packet_assembly.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/data_lane_striper.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/controller/control_detect.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/controller/control_polling.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/controller/control_status_regs.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/controller/pcie_controller.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/encoders/disparity_checker.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/encoders/encoder_3b4b.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/encoders/encoder_5b6b.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/encoders/encoder_8b10b.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/linear-feedback-shift-register/linear_feedback_shift_reg.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/scrambler/scrambler.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/timer/timer.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/bin_to_gray/bin_to_gray.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/fifo/fifo.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/serializer/serializer.sv
VERILOG_SOURCES += $(REPO_ROOT)/src/rtl/unary_to_binary/unary_to_binary.sv