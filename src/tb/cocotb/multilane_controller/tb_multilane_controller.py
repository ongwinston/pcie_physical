
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer
from cocotb.types import LogicArray
from cocotb.task import Join

# from helper_functions import get_elements, wait_n_clock_cycles, init_test, end_test

class MultilaneController:
    def __init__(self, dut):
        self.dut = dut
        clock = Clock(dut.clk_i, 10, unit="ns")  # Create a 10us period clock on port clk
        cocotb.start_soon(clock.start(start_high=False))

        pll_tx_clk = Clock(dut.tx_analog_clk_i, 1, unit="ns")
        cocotb.start_soon(pll_tx_clk.start(start_high=False))

        # Define number of lanes supported


    async def reset(self):
        self.dut.rst_i.value = 1
        await Timer(20, unit='ns')
        self.dut.rst_i.value = 0
        await Timer(20, unit='ns')

    async def lane_enable(self, enables):
        # self.dut.lane_enable_i.value = enables
        for i in range(enables):
            self.dut.lane_enable_i[i].value = 1
    
    async def push_data(self, data):
        self.dut.data_frame_i.value = data
        self.dut.data_frame_valid_i.value = 1
        await RisingEdge(self.dut.clk_i)
        self.dut.data_frame_i.value = 0
        self.dut.data_frame_valid_i.value = 0

    async def disable_scrambler(self):
        self.dut.bypass_scrambler_i.value = 1
        await RisingEdge(self.dut.clk_i)
    
    async def is_ordered_set(self):
        self.dut.is_ordered_set_i.value = 1
        await RisingEdge(self.dut.clk_i)



@cocotb.test(timeout_time=1, timeout_unit="ms")
async def test_multilane_controller_simple(dut):
    '''
    Test of PCIe Multilane controller
    '''
    test_pass = 1
    # Initialize the test
    multilane_inst = MultilaneController(dut)

    await multilane_inst.reset()


    await ClockCycles(dut.clk_i,100)


    # Write test here
    await multilane_inst.disable_scrambler()

    await ClockCycles(dut.clk_i,5)


    #
    # Lets test two enabled lanes,
    # - push two valid data samples into the controller
    # - Should expect this to then be launched to the SERDES

    # Enable the lanes (x2)
    num_enabled_lanes = 4
    await multilane_inst.lane_enable(num_enabled_lanes)


    # Push data
    for _ in range(num_enabled_lanes*3):
        await multilane_inst.push_data(random.getrandbits(8))
    

    await ClockCycles(dut.clk_i, 20)



    await ClockCycles(dut.clk_i,10000)
 
    # End of Test code
    # await end_test(dut,test_pass)


#-------------------------------------------------------------------------------------------
