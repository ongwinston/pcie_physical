
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Join, ClockCycles, Timer
from cocotb.types import LogicArray

# from helper_functions import get_elements, wait_n_clock_cycles, init_test, end_test

class PCIe:
    def __init__(self, dut):
        self.dut = dut
        clock = Clock(dut.clk_i, 10, units="ns")  # Create a 10us period clock on port clk
        cocotb.start_soon(clock.start(start_high=False))


    async def reset(self):
        self.dut.rst_i.value = 0
        await Timer(20, units='ns')
        self.dut.rst_i.value = 1
        await Timer(20, units='ns')

    async def en_load_lane(self):
        await RisingEdge(self.dut.clk_i)
        self.dut.electrical_sub_load_detect_i.value = 0xf


@cocotb.test(timeout_time=1, timeout_unit="ms")
async def test_pcie_phys_top(dut):
    '''
    Test of PCIe Top Module
    '''
    test_pass = 1
    # Initialize the test
    pcie_inst = PCIe(dut)


    await ClockCycles(dut.clk_i,100)


    # Write test here

    await pcie_inst.en_load_lane()


    await ClockCycles(dut.clk_i,10000)
 
    # End of Test code
    # await end_test(dut,test_pass)


#-------------------------------------------------------------------------------------------
