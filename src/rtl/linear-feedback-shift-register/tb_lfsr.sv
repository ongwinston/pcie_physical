`timescale 1ns/1ps

module tb_lfsr;


  logic clk;
  logic reset;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    #20 reset = 1'b0;

  end

  always begin
    #10 clk = ~clk;
  end

  linear_feedback_shift_reg lfsr (
   .clk       (clk),
   .reset     (reset),
   .data_in   (1'b1),
   .data_out  (/*UNCONNECTED*/)
  );

  //---------------------
  // Waveform dump
  //---------------------

  /*
   * We dont run this testbench with the Ibex Verilator system so which has an option to dump the waveform
   * so lets declare our waveform here.
   * Found in build/lowrisc_ibex_demo_system_0/xilinx_sim-xsim
   */
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end


  initial begin
    #1000 $finish();
  end

endmodule