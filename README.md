# pcie_physical

# About
Implementation of Physical Logical layer PCI Express Base Specification Revision 5.0 Version 1.0


## Language SystemVerilog

# Simulator choice
- Icarus Verilog
- Xilinx Simulator
- Verilator

# Build Tool
- Fusesoc


# How to Simulate top level
```sh
poetry run fusesoc --cores-root=.  --verbose  run --target=xilinx_sim --setup --build --run pcie:physical:top:0.1
```