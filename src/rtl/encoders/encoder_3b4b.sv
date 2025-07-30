module encoder_3b4b (
  input               clk_i,
  input               rst_i,
  input  logic [2:0]  data_i,
  output logic [3:0]  data_o,
  input  logic        is_run_disparity_n_i,
  output logic        run_disparity_neg_post3b4b_o,
  input  logic        is_special_k_i
);

  logic [3:0] encoded_symbol;

  always_comb begin
    unique case(data_i)
    3'b000: begin
      if(is_run_disparity_n_i) encoded_symbol = 4'b0100;
      else encoded_symbol = 4'b1011;
    end
    3'b001: begin
      encoded_symbol = 4'b1001;
    end
    3'b010: begin
      encoded_symbol = 4'b0101;
    end
    3'b011: begin
      if(is_run_disparity_n_i) encoded_symbol = 4'b1100;
      else encoded_symbol = 4'b0011;
    end
    3'b100: begin
      if(is_run_disparity_n_i) encoded_symbol = 4'b0010;
      else encoded_symbol = 4'b1101;
    end
    3'b101: begin
      encoded_symbol = 4'b1010;
    end
    3'b110: begin
      encoded_symbol = 4'b0110;
    end
    3'b111: begin
      if(is_run_disparity_n_i) encoded_symbol = 4'b1110;
      else encoded_symbol = 4'b0001;
    end
    default: begin
      encoded_symbol = 4'b0000;
    end
    endcase

  end

  assign data_o = encoded_symbol;

  disparity_checker #(
    .BITWIDTH(4)
  ) disp_check_inst (
    .symbol_i      (encoded_symbol),
    .disparity_o   (run_disparity_neg_post3b4b_o)
  );


endmodule
