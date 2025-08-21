/* Scrambler module logic 
  Instance of LFSR
  */

module scrambler #(
  parameter int NUM_LANES = 4,
  parameter int DATA_WIDTH = 8
) (
  input  logic clk_i,
  input  logic rst_i,

  input  logic [DATA_WIDTH-1 : 0]  data_frame_i,
  input  logic                     data_frame_valid_i,
  output logic                     scrambler_ready_o,

  output logic [DATA_WIDTH-1 : 0] data_scrambled_o,
  output logic                    data_scrambled_valid_o

);


  // Wires
  logic [$clog2(DATA_WIDTH) : 0] cntr;
  logic [DATA_WIDTH-1 : 0] lfsr_data_in_d, lfsr_data_in_q;

  logic [DATA_WIDTH-1 : 0] lfsr_out_constructed;
  logic lfsr_out;

  assign lfsr_data_in_d = {lfsr_data_in_q[6:0], 1'b0};

  always_ff @(posedge clk_i) begin
    if(rst_i) begin
      lfsr_data_in_q <= data_frame_i;
    end else begin
      lfsr_data_in_q <= lfsr_data_in_d;
    end
  end

  // LFSR Instance
  linear_feedback_shift_reg lfsr_inst(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .data_i      (lfsr_data_in_q[7]),
    .data_o      (lfsr_out)
);


  //=======================================
  // Output assign
  //=======================================
  assign scrambler_ready_o = 1'b1; // TODO

endmodule

