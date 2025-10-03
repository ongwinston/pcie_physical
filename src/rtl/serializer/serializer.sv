/**
Serializer module which takes data symbol given to it from multiple lane controller
FIFO buffer instantiation to buffer different throughput rate of the analog phy side
Takes the phy reference clock for the analog differential signal
*/

module serializer #(
  parameter int DATA_WIDTH = 10
) (
  input clk_i,
  input rst_i,

  // symbol_data_in
  input logic [DATA_WIDTH -1:0] symbol_data_i,

  // Analog TX
  input logic analag_tx_clk_i,
  output logic symbol_bit_o,
  output logic symbol_bit_valid_o

);

  logic [DATA_WIDTH-1 : 0]pop_data;
  logic fifo_full;
  logic fifo_empty;

  //------------------------------------------------
  // FIFO buffer
  //------------------------------------------------
  fifo #(
    .DATA_W(DATA_WIDTH),
    .DEPTH(32),
    .RESET_ACTIVE_LOW(1'b0)
  ) fifo_inst(
    .wclk         (clk_i),
    .rclk         (analag_tx_clk_i),
    .reset        (rst_i),
    .push_i       (1'b0),
    .push_data_i  (DATA_WIDTH'('d0)),
    .pop_i        (1'b0),
    .pop_data_o   (pop_data),
    .fifo_full_o  (fifo_full),
    .fifo_empty_o (fifo_empty)

  );


  //================================================
  // Serializer out on analog clock domain
  //================================================

endmodule
