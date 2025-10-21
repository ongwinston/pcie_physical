
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer
from cocotb.types import LogicArray
from cocotb.task import Join



@cocotb.test(timeout_time=10, timeout_unit="us")
async def test_simple_unary_to_binary(dut):
    '''
    Test of unary_to_binary module
    '''

    # unary_val=0

    await Timer(10, unit='ns')

    for input in range(10):
        # unary_val = (unary_val << 1) + 1
        dut.unary_i[input].value = 1
        await Timer(10, unit='ns')
        assert(int(dut.binary_o.value) == input+1) # +1 due to index[0]



#-------------------------------------------------------------------------------------------
