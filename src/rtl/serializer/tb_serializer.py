
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Join, ClockCycles, Timer
from cocotb.types import LogicArray
from cocotb.queue import Queue


class Serializer:
    def __init__(self,dut):
        self.dut = dut

    async def end_test(self,test_pass, error_str="ERROR: Test not properly defined"):
        """
        Provide some clock cycles before checking test pass
        """
        await ClockCycles(self.dut.clk_i,3)
        await RisingEdge(self.dut.clk_i)
        assert (test_pass), f"{error_str}"

    async def reset(self):
        self.dut.rst_i.value = 0
        await RisingEdge(self.dut.clk_i)


@cocotb.test(timeout_time=10, timeout_unit="us")
async def test_simple(dut):
    '''
    Simple test
    '''

    # Clock period 10ns = 100Mhz
    clock = Clock(dut.clk_i, 10, units="ns")
    tx_clk = Clock(dut.analag_tx_clk_i, 5, units="ns")
    cocotb.start_soon(clock.start())
    cocotb.start_soon(tx_clk.start())


    serializer = Serializer(dut)

    await serializer.reset()

    await ClockCycles(dut.clk_i,50)

    await serializer.end_test(0)
