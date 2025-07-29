// `timescale 1ns/1ps


module tb_encoder_8b10b #(
    parameter      Encoder_5b6bInitFile   = ""
  ) (

);


  logic clk;
  logic reset;

  // Debug data_in
  logic [7:0] data_frame;
  logic [9:0] encoded_symbol;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    #20 reset = 1'b0;
  end

  always begin
    #10 clk = ~clk;
  end


  // Counter as the data frame driver
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      data_frame <= 8'h00;
    end else begin
      data_frame <= data_frame + 1'b1;
    end
  end

  encoder_8b10b dut_encoder_8b10b (
    .clk_i             (clk),
    .reset_i           (reset),
    .data_i            (data_frame),
    .encoded_8b10b_o   (encoded_symbol),
    .is_special_k_i    (1'b0)
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
    #1ms $finish();
  end
endmodule