
# Makefile template

# Makefile

VERILOG_SOURCES += $(shell pwd)/unary_to_binary.sv
TOPLEVEL = unary_to_binary
MODULE = tb_unary_to_binary

include  $(shell pwd)/../Makefile

############################################################################

# Define the variables in the Makefile
REPLACE_STR = unary_to_binary

# Use a template YS file and substitute variables
ys_file.ys: $(REPO_ROOT)/template.ys
	sed 's/@VARIABLE1@/$(REPLACE_STR)/g' $(REPO_ROOT)/template.ys > ys_file.ys

# Uncomment the following for more in place changes
# sed 's/@VARIABLE2@/$(VARIABLE2)/g' ys_file.ys > ys_file.tmp
# mv ys_file.tmp ys_file.ys

.PHONY: synthesis
synthesis: ys_file.ys
	yosys -l yosys.log -s ys_file.ys

############################################################################

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
