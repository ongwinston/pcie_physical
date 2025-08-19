
`define SIM_TIMEOUT 100us


module tb_controller (

);

  //=================================================================================
  // Configurable Params
  //=================================================================================

  // verilator lint_off UNUSEDPARAM
  parameter int NUM_OF_LANES = 1;
  // verilator lint_on UNUSEDPARAM

  // verilator lint_off UNOPTFLAT
  logic clk;
  logic rst, rst_sync;
  // verilator lint_on UNOPTFLAT

  // verilator lint_off UNUSEDSIGNAL
  logic phy_lane_detected;
  logic en8b10b;
  logic en128b130b;
  // verilator lint_on UNUSEDSIGNAL


  //=================================================================================
  // Test tasks functions
  //=================================================================================
  task static drive_lane_detect(input logic clk, output logic lane_detect);
    begin
      lane_detect = 1'b1;
    end
  endtask

  function static void init_rst();
    rst = 1'b1;
    phy_lane_detected = 1'b0;
  endfunction


  //=================================================================================
  // Initial TB
  //=================================================================================

  initial begin
    init_rst();

    // Deassert reset
    #10ns rst = ~rst;

    drive_lane_detect(clk, phy_lane_detected);

    // Finish
    #`SIM_TIMEOUT $finish();
  end


  //=================================================================================
  // Module Instantaces
  //=================================================================================


  tb_clocking_block tb_clocking_block_inst (
    .rst_i       (rst),
    .clk_o       (clk),
    .rst_sync_o  (rst_sync)

  );

  pcie_controller  #(
    .NUM_LANES_SUPPORTED(NUM_OF_LANES)
  ) pcie_controller_dut (
    .clk_i                   (clk),
    .rst_i                   (rst_sync),

    .phy_layer_lane_detect_i (phy_lane_detected),

    .en_8b10b_encoder_o      (en8b10b),
    .en_128b130b_encoder_o   (en128b130b)
  );



  //---------------------
  // Waveform dump
  //---------------------

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule
