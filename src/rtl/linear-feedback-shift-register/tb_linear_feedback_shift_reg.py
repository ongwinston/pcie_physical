
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Join, ClockCycles, Timer
from cocotb.types import LogicArray

from helper_functions import get_elements, wait_n_clock_cycles, init_test, end_test

class LFSR:
    def __init__(self, dut):
        self.dut = dut
        clock = Clock(dut.clk, 10, units="ns")  # Create a 10us period clock on port clk
        cocotb.start_soon(clock.start(start_high=False))


    async def reset(self):
        self.dut.reset.value = 1
        await Timer(20, units='ns')
        self.dut.reset.value = 0
        await Timer(20, units='ns')


@cocotb.test(timeout_time=10, timeout_unit="us")
async def test_simple_linear_feedback_shift_reg(dut):
    '''
    Test of linear_feedback_shift_reg module
    '''
    test_pass = 1
    # Initialize the test
    linear_feedback_shift_reg = LFSR(dut)
    await linear_feedback_shift_reg.reset()


    # Write test here
    await ClockCycles(dut.clk,128)


    # End of Test code
    await end_test(dut,test_pass)


#-------------------------------------------------------------------------------------------
