`timescale 1ns/1ps


module tb_encoder_8b10b();


  logic clk;
  logic reset;

  // Debug data_in
  logic [7:0] data_frame = 8'h01;
  logic [9:0] encoded_symbol;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    #20 reset = 1'b0;
  end

  always begin
    #10 clk = ~clk;
  end

  encoder_8b10b dut_encoder_8b10b (
    .clk      (clk),
    .reset    (reset),
    .data_i   (data_frame),
    .symbol_o (encoded_symbol)
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