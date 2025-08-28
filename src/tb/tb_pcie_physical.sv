`define SIM_TIMEOUT 100us

module tb_pcie_physical ();


  //=================================================================================
  // Configurable Params
  //=================================================================================

  // verilator lint_off UNUSEDPARAM
  // verilator lint_off UNUSEDSIGNAL
  // verilator lint_off UNOPTFLAT
  parameter int NUM_OF_LANES = 4;

  logic clk;
  logic rst, rst_sync;

  logic phy_lane_detected;
  logic en8b10b;
  logic en128b130b;
  // verilator lint_on UNUSEDSIGNAL
  // verilator lint_on UNUSEDPARAM
  // verilator lint_on UNOPTFLAT


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

  pcie_phys_top  #(
    .NUM_LANES(NUM_OF_LANES),
    .MAC_FRAME_WIDTH(8)
  ) pcie_top_dut (
    .clk_i                        (clk),
    .rst_i                        (rst_sync),
    .mac_data_frame_i             (8'hab),
    .mac_data_frame_valid_i       (1'b1),
    .mac_data_frame_ready_o       (),

    .electrical_sub_load_detect_i ('1),
    .electrical_sub_out_symbol_o  ()
  );



  //---------------------
  // Waveform dump
  //---------------------

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
endmodule
