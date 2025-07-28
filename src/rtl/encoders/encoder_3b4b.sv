module encoder_3b4b (
  input              clk,
  input              reset,
  input logic [2:0]  data_in,
  output logic [3:0] data_out,
  input logic        run_disparity_neg,
  output logic       run_disparity_neg_post3b4b,
  input logic        is_special_k
);

  logic [3:0] encoded_symbol;

  always_comb begin
    case(data_in)
    3'b000: begin
      if(run_disparity_neg) encoded_symbol = 4'b0100;
      else encoded_symbol = 4'b1011;
    end
    3'b001: begin
      encoded_symbol = 4'b1001;
    end
    3'b010: begin
      encoded_symbol = 4'b0101;
    end
    3'b011: begin
      if(run_disparity_neg) encoded_symbol = 4'b1100;
      else encoded_symbol = 4'b0011;
    end
    3'b100: begin
      if(run_disparity_neg) encoded_symbol = 4'b0010;
      else encoded_symbol = 4'b1101;
    end
    3'b101: begin
      encoded_symbol = 4'b1010;
    end
    3'b110: begin
      encoded_symbol = 4'b0110;
    end
    3'b111: begin
      if(run_disparity_neg) encoded_symbol = 4'b1110;
      else encoded_symbol = 4'b0001;
    end
    default: begin
      encoded_symbol = 4'b0000;
    end
    endcase
    
  end

  assign data_out = encoded_symbol;

  disparity_checker #(
    .BITWIDTH(4)
  ) disp_check_inst (
    .symbol_in      (encoded_symbol),
    .disparity_out  (run_disparity_neg_post3b4b)
  );
                     

endmodule
