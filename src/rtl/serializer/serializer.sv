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

  input logic  symbol_valid_i,

  // Analog TX
  input logic analog_tx_clk_i,
  output logic symbol_bit_o,
  output logic symbol_bit_valid_o

);

  localparam COUNTER_WIDTH = $clog2(DATA_WIDTH);

  logic [DATA_WIDTH-1 : 0] pop_data;
  logic fifo_full;
  logic fifo_empty;
  logic pop_fifo;

  logic [DATA_WIDTH-1 : 0] staged_data_d, staged_data_q;
  logic [COUNTER_WIDTH-1 : 0] staging_cntr_d, staging_cntr_q;
  logic                    serial_bit_out;


  //------------------------------------------------
  // FIFO buffer
  //------------------------------------------------
  fifo #(
    .DATA_W(DATA_WIDTH),
    .DEPTH(32),
    .RESET_ACTIVE_LOW(1'b0)
  ) fifo_inst(
    .wclk         (clk_i),
    .rclk         (analog_tx_clk_i),
    .reset        (rst_i),
    .push_i       (symbol_valid_i),
    .push_data_i  (symbol_data_i),
    .pop_i        (pop_fifo),
    .pop_data_o   (pop_data),
    .fifo_full_o  (fifo_full),
    .fifo_empty_o (fifo_empty)

  );

  //================================================
  // Serializer out on analog clock domain
  //================================================

  assign staged_data_d = (pop_fifo) ? pop_data : staged_data_q >> 1'b1;
  assign staging_cntr_d = (staging_cntr_q == (COUNTER_WIDTH)'(DATA_WIDTH-1)) ? 'd0 : staging_cntr_q + 1'b1;

  // Pop fifo when not empty and our staging_cntr_q hits the data width
  assign pop_fifo = (!fifo_empty && (staging_cntr_q == (COUNTER_WIDTH)'(DATA_WIDTH-1))) ? 1'b1 : 1'b0;

  always_ff @( posedge analog_tx_clk_i ) begin
    if(rst_i) begin
      staged_data_q <= 'd0;
      staging_cntr_q <= 'd0;
    end else begin
      staged_data_q <= staged_data_d;
      staging_cntr_q <= staging_cntr_d;
    end
  end

  assign serial_bit_out = staged_data_q[0];



  //================================================
  // Output assigns
  //================================================
  assign symbol_bit_o = serial_bit_out;
  assign symbol_bit_valid_o = 1'b1; // TODO

endmodule
