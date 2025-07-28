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


module encoder_8b10b #(
    parameter      Encoder_5b6bInitFile   = ""
 ) (
  input logic clk,
  input logic reset,
  input logic [7:0] data_i,
  output logic [9:0] encoded_8b10b,
  input logic is_special_k

);


  ////////////////////////////////////////////////////////////
  // Wire and Reg declarations
  ///////////////////////////////////////////////////////////

  logic [2:0] encoder_3b4b_data_in;
  logic [3:0] encoder_3b4b_symbol_out;
  logic run_disparity_neg;
  logic run_disparity_neg_post_5b6b;

  logic [4:0] encoder_5b6b_data_in;
  logic [5:0] encoder_5b6b_symbol_out;

  logic [9:0] encoder8b10b_d, encoder8b10b_q;

  /////////////////////////////////////////////////////////////

  // assign run_disparity_neg = 1'b1; // TODO: Fix the RD

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

  encoder_5b6b  #(
    .Encoder_5b6bInitFile (Encoder_5b6bInitFile)
  ) encoder_5b6b_inst (
    .clk                    (clk),
    .reset                  (reset),
    .data_in                (encoder_5b6b_data_in),
    .data_out               (encoder_5b6b_symbol_out),
    .run_disparity_neg      (run_disparity_neg),
    .is_special_k           (is_special_k),
    .run_disparity_neg_post_5b6b (run_disparity_neg_post_5b6b)

  );


  ////////////////////////////////////
  // 3b/4b Encoder
  ////////////////////////////////////

  // [H,G,F]
  assign encoder_3b4b_data_in = { data_i[7],
                                 data_i[6],
                                 data_i[5]
                                 };

  encoder_3b4b encoder3b4b_inst (
    .clk                        (clk),
    .reset                      (reset),
    .data_in                    (encoder_3b4b_data_in),
    .data_out                   (encoder_3b4b_symbol_out),
    .run_disparity_neg          (run_disparity_neg),
    .is_special_k               (is_special_k),
    .run_disparity_neg_post3b4b (run_disparity_neg)

  );

  assign encoder8b10b_d = {encoder_5b6b_symbol_out, encoder_3b4b_symbol_out};

  always_ff @( posedge clk or posedge reset ) begin
    if(reset) begin
      encoder8b10b_q <= 10'd0;
    end else begin
      encoder8b10b_q <= encoder8b10b_d;
    end
  end

  assign encoded_8b10b = encoder8b10b_q;

endmodule