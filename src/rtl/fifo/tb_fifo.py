
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Join, ClockCycles, Timer
from cocotb.types import LogicArray


@cocotb.test()
async def test_simple_fifo(dut):
    '''
    Test of fifo module
    '''

    wclock = Clock(dut.wclk, 10, units="us")  # Create a 10us period clock on port clk
    rclock = Clock(dut.wclk, 20, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(rclock.start(start_high=False))

    # Synchronize with the clock.
    await RisingEdge(dut.wclk)

    # Reset the system
    dut.reset.value = 1
    await RisingEdge(dut.wclk)
    await ClockCycles(dut.wclk,3)
    dut.reset.value = 0

    test_pass = 1

    ####################################
    # Insert Test code here
    ####################################


    ####################################
    # End of Test code
    ####################################


    # Check the final input on the next clock
    await ClockCycles(dut.wclk,3)
    await RisingEdge(dut.wclk)
    assert (test_pass), "Test failed a pass case"

#-------------------------------------------------------------------------------------------
