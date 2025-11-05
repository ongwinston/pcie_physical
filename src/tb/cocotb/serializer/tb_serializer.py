
import random
import math
import cocotb
import numpy
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer
from cocotb.types import LogicArray
from cocotb.queue import Queue
from cocotb.task import Join

async def reverse_bits(bits):
    '''
    Takes in symbol of bits and reverses their order
    '''
    reverse_bits = bits[::-1]
    return reverse_bits

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
        self.dut.rst_i.value = 1
        await RisingEdge(self.dut.clk_i)
        self.dut.rst_i.value = 0
        await RisingEdge(self.dut.clk_i)

    async def push_data(self, data):
        self.dut.symbol_data_i.value = data
        self.dut.symbol_valid_i.value = 1
        await RisingEdge(self.dut.clk_i)
        self.dut.symbol_data_i.value = 0
        self.dut.symbol_valid_i.value = 0

    async def push_skip_symbol(self):
        '''
        K28.0
        | HGF_EDCBA | RD- abcdei_fghj | RD+ abcdei_fghj |
        ----------------------------------------------
        | 000_11100 | 00_1111_0100    | 11_0000_1011    |

        re-order this to 
        jhgfiedcba
        to push LSB bit first
        '''
        symbol = "0011110100"
        symbol_reverse = await reverse_bits(symbol)

        # Check Running Disparity
        await self.push_data(int(symbol_reverse,2)) # RD-

    async def push_idle_symbol(self):
        '''K28.3'''
        symbol = "0011110011"
        symbol_reverse = await reverse_bits(symbol)
        await self.push_data(int(symbol_reverse,2)) # RD-

    async def push_com_symbol(self):
        ''' K28.5'''
        symbol = "0011111010"
        symbol_reverse = await reverse_bits(symbol)
        await self.push_data(int(symbol_reverse,2)) # RD-


@cocotb.test(timeout_time=10, timeout_unit="us")
async def test_simple(dut):
    '''
    Simple test
    '''

    # Clock period 10ns = 100Mhz
    clock = Clock(dut.clk_i, 10, unit="ns")
    tx_clk = Clock(dut.analog_tx_clk_i, 1, unit="ns")
    cocotb.start_soon(clock.start())
    cocotb.start_soon(tx_clk.start())


    serializer = Serializer(dut)

    await serializer.reset()

    await ClockCycles(dut.clk_i,5)


    # Push data into the serializer
    await serializer.push_data(0b1001110100) # D0.0
    # await RisingEdge(dut.clk_i)
    await serializer.push_data(0b0111010100) # D1.0
    # await RisingEdge(dut.clk_i)
    await serializer.push_data(0b1011010100) # D2.0
    # await RisingEdge(dut.clk_i)
    await serializer.push_data(0b1100011011) # D3.0
    # await RisingEdge(dut.clk_i)

    await serializer.push_skip_symbol()
    await serializer.push_idle_symbol()
    await serializer.push_com_symbol()


    await ClockCycles(dut.clk_i, 100) # Flush out the encoded data, 10 cycles + 2

    await serializer.end_test(1)
