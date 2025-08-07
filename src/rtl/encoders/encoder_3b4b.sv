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
  logic run_disparity_neg_post3b4b;

  always_comb begin
    encoded_symbol = 4'b0000; // default to prevent latch
    run_disparity_neg_post3b4b = 1'b0; // default to prevent latch
    unique case(data_i)
    3'b000: begin
      if(is_run_disparity_n_i) begin
        encoded_symbol = 4'b0100;
        run_disparity_neg_post3b4b = 1'b1;
      end else begin
        encoded_symbol = 4'b1011;
        run_disparity_neg_post3b4b = 1'b0;
      end
    end
    3'b001: begin
      encoded_symbol = 4'b1001;
      run_disparity_neg_post3b4b = is_run_disparity_n_i;
    end
    3'b010: begin
      encoded_symbol = 4'b0101;
      run_disparity_neg_post3b4b = is_run_disparity_n_i;
    end
    3'b011: begin
      if(is_run_disparity_n_i) begin
        encoded_symbol = 4'b1100;
        run_disparity_neg_post3b4b = is_run_disparity_n_i;
      end else begin
        encoded_symbol = 4'b0011;
        run_disparity_neg_post3b4b = is_run_disparity_n_i;
      end
    end
    3'b100: begin
      if(is_run_disparity_n_i) begin
        encoded_symbol = 4'b0010;
        run_disparity_neg_post3b4b = 1'b1;
      end else begin
        encoded_symbol = 4'b1101;
        run_disparity_neg_post3b4b = 1'b0;
      end
    end
    3'b101: begin
      encoded_symbol = 4'b1010;
      run_disparity_neg_post3b4b = is_run_disparity_n_i;
    end
    3'b110: begin
      encoded_symbol = 4'b0110;
      run_disparity_neg_post3b4b = is_run_disparity_n_i;
    end
    3'b111: begin
      if(is_run_disparity_n_i) begin
        encoded_symbol = 4'b1110;
        run_disparity_neg_post3b4b = 1'b0;
      end else begin
        encoded_symbol = 4'b0001;
        run_disparity_neg_post3b4b = 1'b1;
      end
    end
    default: begin
      encoded_symbol = 4'b0000;
      run_disparity_neg_post3b4b = is_run_disparity_n_i;
    end
    endcase

  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      data_o <= 4'd0;
      run_disparity_neg_post3b4b_o <= 1'b0;
    end else begin
      data_o <= encoded_symbol;
      run_disparity_neg_post3b4b_o <= run_disparity_neg_post3b4b;
    end
  end


endmodule
