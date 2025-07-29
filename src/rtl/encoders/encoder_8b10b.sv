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
  input  logic       clk_i,
  input  logic       reset_i,
  input  logic [7:0] data_i,
  output logic [9:0] encoded_8b10b_o,
  input  logic       is_special_k_i

);


  ////////////////////////////////////////////////////////////
  // Wire and Reg declarations
  ///////////////////////////////////////////////////////////

  logic [2:0] encoder_3b4b_data_in;
  logic [3:0] encoder_3b4b_symbol_out;
  logic       is_run_disparity_n;
  logic       post5b6b_run_disparity_n;
  logic       post3b6b_run_disparity_neg_d, post3b6b_run_disparity_neg_q;
  logic       is_special_k;

  logic [4:0] encoder_5b6b_data_in;
  logic [5:0] encoder_5b6b_symbol_out;

  logic [9:0] encoder8b10b_d, encoder8b10b_q;

  /////////////////////////////////////////////////////////////

  assign is_special_k = is_special_k_i;

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
    .clk_i                         (clk_i),
    .reset_i                       (reset_i),
    .data_i                        (encoder_5b6b_data_in),
    .data_o                        (encoder_5b6b_symbol_out),
    .is_run_disparity_n_i          (is_run_disparity_n),
    .is_special_k_i                (is_special_k),
    .post5b6b_run_disparity_n_o    (post5b6b_run_disparity_n)

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
    .clk_i                         (clk_i),
    .reset_i                       (reset_i),
    .data_i                        (encoder_3b4b_data_in),
    .data_o                        (encoder_3b4b_symbol_out),
    .is_run_disparity_n_i          (post5b6b_run_disparity_n),
    .is_special_k_i                (is_special_k),
    .run_disparity_neg_post3b4b_o  (is_run_disparity_n)

  );

  assign encoder8b10b_d = {encoder_5b6b_symbol_out, encoder_3b4b_symbol_out};


  // Output Flopped signal
  always_ff @( posedge clk_i or posedge reset_i ) begin
    if(reset_i) begin
      encoder8b10b_q <= 10'd0;
    end else begin
      encoder8b10b_q <= encoder8b10b_d;
    end
  end

  assign encoded_8b10b = encoder8b10b_q;

endmodule
