/*
 * Basic clocking block for driving testbench clocking
 */

// Clocking frequency 200Mhz = 5ns(p)
//

`define CLK_FREQ_HZ 5

module tb_clocking_block #(
  // parameter CLK_FREQ_HZ = 5ns //200 MHz
 ) (
  input rst_i,
  output clk_o,
  output rst_sync_o
);

  logic clk;
  logic [1:0] rst_sync;

  always begin
    #`CLK_FREQ_HZ clk = ~clk;
  end

  always_ff @(posedge clk or posedge rst_i) begin
    if(rst_i) begin
      rst_sync <= 2'b11;
    end else begin
      rst_sync <= {rst_sync[0], 1'b0};
    end
  end

  assign clk_o = clk;
  assign rst_sync_o = rst_sync[1];

endmodule
