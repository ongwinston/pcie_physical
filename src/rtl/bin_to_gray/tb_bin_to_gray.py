
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Join, ClockCycles, Timer
from cocotb.types import LogicArray


@cocotb.test()
async def test_simple_bin_to_gray(dut):
    '''
    Test of bin_to_gray module
    '''

    # Printing toplevel elements
    # await get_elements(dut)

    # Set initial input value to prevent it from
    

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    # Synchronize with the clock.
    await RisingEdge(dut.clk)

    # Reset the system
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    
    await ClockCycles(dut.clk,3)
    dut.reset.value = 0

    test_pass = 1

    ####################################
    # Insert Test code here
    ####################################

    for i in range (0,20):
        dut.binary_i.value = i
        await ClockCycles(dut.clk,2)


    ####################################
    # End of Test code
    ####################################

    # Check the final input on the next clock
    await ClockCycles(dut.clk,5)
    await RisingEdge(dut.clk)
    assert (test_pass), "Test failed a pass case"

#-------------------------------------------------------------------------------------------
