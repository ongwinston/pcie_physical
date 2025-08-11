/*
Takes the incoming data symbol and will determine If it is Positive disparity or
negative disparity

E.g
Symbol in {E,D,C,B,A} = {}
*/


module disparity_checker #(
  parameter int BITWIDTH = 10
) (
    input logic [BITWIDTH-1:0] symbol_i,
    input logic  current_disparity_i,
    output logic disparity_negative_o
 );

  // Sum the bits and check if its greater than half the width
  logic [BITWIDTH:0] ones_cnt;
  assign ones_cnt = $countones(symbol_i);

  // If ones_cnt == 5, then we keep the current_disparity
  assign disparity_negative_o = (ones_cnt > 5) ? 1'b0 : (ones_cnt == 5) ? current_disparity_i : 1'b1;

endmodule
