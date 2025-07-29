/*
Takes the incoming data symbol and will determine If it is Positive disparity or
negative disparity

E.g
Symbol in {E,D,C,B,A} = {}
*/


module disparity_checker #(
  parameter int BITWIDTH = 5
) (
    input logic [BITWIDTH-1:0] symbol_i,
    output logic disparity_o
 );


 // XOR the data bits in to check disparity
 // if we are even in disparity then disparity doesnt change
 assign disparity_o = ^symbol_i;



endmodule
