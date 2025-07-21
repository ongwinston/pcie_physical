/*
8b to 10b Encoder

Converts a 8-bit data stream to a 10-bit symbol line code

Given 8 bit data in [A,B,C,D,E,F,G,H]

Encoder will insert two Running Disparity bits and rearrange the inputs bit stream to the following

[H,G,F],[E,D,C,B,A]

* Running Disparity Inserted
[a,b,c,d,e,i,f,g,h,j]

* Running Disparity +

*/


module encoder_8b10b (
  input logic clk,
  input logic reset,
  input logic [7:0] data_i,
  output logic [9:0] symbol_o
);

  logic [2:0] encoder_3b4b_data_in;
  logic [3:0] encoder_3b4b_symbol_out;

  logic [4:0] encoder_5b6b_data_in;
  logic [5:0] encoder_5b6b_symbol_out;


  ////////////////////////////////////
  // 5b/6b Encoder
  ////////////////////////////////////

  // [E,D,C,B,A]
  assign encoder_5b6b_data_in = { data_i[4],
                                  data_i[3],
                                  data_i[2],
                                  data_i[1],
                                  data_i[0]
                                  };

  encoder_5b6b encoder_5b6b_inst (
    .clk       (clk),
    .reset     (reset),
    .data_in   (encoder_5b6b_data_in),
    .data_out  (encoder_5b6b_symbol_out)

  );


  ////////////////////////////////////
  // 3b/4b Encoder
  ////////////////////////////////////

  // [H,G,F]
  assign encoder3b4b_data_in = { data_i[7],
                                 data_i[6],
                                 data_i[5]
                                 };

  encoder_3b4b encoder3b4b_inst (
    .clk       (clk),
    .reset     (reset),
    .data_in   (encoder_3b4b_data_in),
    .data_out  (encoder_3b4b_symbol_out)

  );

  assign symbol_o = {encoder_3b4b_symbol_out, encoder_5b6b_symbol_out};

endmodule