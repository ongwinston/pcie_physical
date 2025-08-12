module tb_controller (

);

  logic clk;
  logic rst, rst_sync;

  initial begin
    rst = 1'b1;
    #10ns rst = ~rst;

    #100us $finish();
  end

  tb_clocking_block tb_clocking_block_inst (
    .rst_i       (rst),
    .clk_o       (clk),
    .rst_sync_o  (rst_sync)

  );

  pcie_controller pcie_controller_dut (
    .clk_i (clk),
    .rst_i (rst_sync)
  );



  //---------------------
  // Waveform dump
  //---------------------

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end



endmodule
