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
  input  logic       rst_i,
  input  logic [7:0] data_i,
  output logic [9:0] encoded_8b10b_symbol_o, // 1 cycle latency from input data_i
  input  logic       is_special_k_i
);


  ////////////////////////////////////////////////////////////
  // Wire and Reg declarations
  ///////////////////////////////////////////////////////////

  logic [2:0] encoder_3b4b_data_in_d, encoder_3b4b_data_in_q;
  logic [3:0] encoder_3b4b_symbol_out;
  logic       is_run_disparity_n;
  logic       post5b6b_run_disparity_n;
  logic       post3b6b_run_disparity_neg_d, post3b6b_run_disparity_neg_q;
  logic       is_special_k;

  logic [4:0] encoder_5b6b_data_in;
  logic [5:0] encoder_5b6b_symbol_d, encoder_5b6b_symbol_q;

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
    .rst_i                         (rst_i),
    .data_i                        (encoder_5b6b_data_in),
    .data_o                        (encoder_5b6b_symbol_d),
    .is_run_disparity_n_i          (is_run_disparity_n),
    .is_special_k_i                (is_special_k),
    .post5b6b_run_disparity_n_o    (post5b6b_run_disparity_n)

  );

  // Flop the 5b6b symbol out to align to allow the 3b4b encoder to catch up due to the 1 cycle latency of 5b6b
  always_ff @(posedge clk_i) begin
    encoder_5b6b_symbol_q <= encoder_5b6b_symbol_d;
  end


  ////////////////////////////////////
  // 3b/4b Encoder
  ////////////////////////////////////

  // [H,G,F]
  assign encoder_3b4b_data_in_d = { data_i[7],
                                 data_i[6],
                                 data_i[5]
                                 };

  // Register 3b4b data in due to 5b6b 1 cycle latency
  // Do we need this reset on this data path
  always_ff @(posedge clk_i) begin
    encoder_3b4b_data_in_q <= encoder_3b4b_data_in_d;
  end

  encoder_3b4b encoder3b4b_inst (
    .clk_i                         (clk_i),
    .rst_i                         (rst_i),
    .data_i                        (encoder_3b4b_data_in_q),
    .data_o                        (encoder_3b4b_symbol_out),
    .is_run_disparity_n_i          (post5b6b_run_disparity_n),
    .is_special_k_i                (is_special_k),
    .run_disparity_neg_post3b4b_o  (is_run_disparity_n)

  );

  // Finally assemble the final 8b10b decoded symbol to be flopped in the next step
  assign encoder8b10b_d = {encoder_5b6b_symbol_q, encoder_3b4b_symbol_out};

  // Output Flopped signal
  always_ff @( posedge clk_i or posedge rst_i ) begin
    if(rst_i) begin
      encoder8b10b_q <= 10'd0;
    end else begin
      encoder8b10b_q <= encoder8b10b_d;
    end
  end

  assign encoded_8b10b_symbol_o = encoder8b10b_q;

endmodule
