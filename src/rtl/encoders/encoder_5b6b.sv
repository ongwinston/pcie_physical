module encoder_5b6b #(
    parameter      Encoder_5b6bInitFile   = ""
  ) (
    input clk,
    input reset,
    input logic [4:0] data_in,
    output logic [5:0] data_out,
    input logic run_disparity_neg,
    input logic is_special_k,
    output logic run_disparity_neg_post_5b6b
);

  logic [5:0] encoded_symbol;


`ifdef LUTRAM_8b6b
  // LUT Implementation
  logic [5:0] data_symbol_rom [31];

  // -----------------------------------------------
  // Altera style guide allows initial and $readmemb
  // -----------------------------------------------
  initial begin
    $display("Test: %s", Encoder_5b6bInitFile);
    $readmemh("data_symbols_5b6b.mem", data_symbol_rom);
    // $readmemh(Encoder_5b6bInitFile, data_symbol_rom);
  end

  assign data_out = data_symbol_rom[data_in];

`else


  //----------------------------------------------------
  // Work around with some simulators having issues with using readmem
  //----------------------------------------------------
  always_comb begin
    case(data_in)
    5'd0: begin
      if(run_disparity_neg) encoded_symbol = 6'b100111;
      else encoded_symbol = 6'b011000;
    end
    5'd1: begin
      if(run_disparity_neg) encoded_symbol = 6'b011101;
      else encoded_symbol = 6'b100010;
    end
    5'd2: begin
      encoded_symbol = 6'b101101;
    end
    5'd3: begin
      encoded_symbol = 6'b110001;
    end
    5'd4: begin
      if(run_disparity_neg) encoded_symbol = 6'b110101;
      else encoded_symbol = 6'b001010;
    end
    5'd5: begin
      encoded_symbol = 6'b101001;
    end
    5'd6: begin
      encoded_symbol = 6'b011001;
    end
    5'd7: begin
      if(run_disparity_neg) encoded_symbol = 6'b111000;
      else encoded_symbol = 6'b000111;
    end
    5'd8: begin
      if(run_disparity_neg) encoded_symbol = 6'b111001;
      else encoded_symbol = 6'b000110;
    end
    5'd9: begin
      encoded_symbol = 6'b100101;
    end
    5'd10: begin
      encoded_symbol = 6'b010101;
    end
    5'd11: begin
      encoded_symbol = 6'b110100;
    end
    5'd12: begin
      encoded_symbol = 6'b001101;
    end
    5'd13: begin
      encoded_symbol = 6'b101100;
    end
    5'd14: begin
      encoded_symbol = 6'b011100;
    end
    5'd15: begin
      if(run_disparity_neg) encoded_symbol = 6'b010111;
      else encoded_symbol = 6'b101000;
    end
    5'd16: begin
      if(run_disparity_neg) encoded_symbol = 6'b011011;
      else encoded_symbol = 6'b100100;
    end
    5'd17: begin
      encoded_symbol = 6'b100011;
    end
    5'd18: begin
      encoded_symbol = 6'b010011;
    end
    5'd19: begin
      encoded_symbol = 6'b110010;
    end
    5'd20: begin
      encoded_symbol = 6'b001011;
    end
    5'd21: begin
      encoded_symbol = 6'b101010;
    end
    5'd22: begin
      encoded_symbol = 6'b011010;
    end
    5'd23: begin
      if(run_disparity_neg) begin
        encoded_symbol = 6'b111010;
      end else begin
        encoded_symbol = 6'b000101;
      end
    end
    5'd24: begin
      if(run_disparity_neg) encoded_symbol = 6'b110011;
      else encoded_symbol = 6'b001100;
    end
    5'd25: begin
      encoded_symbol = 6'b100110;
    end
    5'd26: begin
      encoded_symbol = 6'b010110;
    end
    5'd27: begin
      if(run_disparity_neg) encoded_symbol = 6'b110110;
      else encoded_symbol = 6'b001001;
    end
    5'd28: begin
      encoded_symbol = 6'b001110;
    end
    5'd29: begin
      if(run_disparity_neg) encoded_symbol = 6'b101110;
      else encoded_symbol = 6'b010001;
    end
    5'd30: begin
      if(run_disparity_neg) encoded_symbol = 6'b011110;
      else encoded_symbol = 6'b100001;
    end
    5'd31: begin
      if(run_disparity_neg) encoded_symbol = 6'b101011;
      else encoded_symbol = 6'b010100;
    end
    default: begin
      encoded_symbol = 6'b000000;
    end
    endcase

  end

    assign data_out = encoded_symbol;
`endif

  disparity_checker  #(
    .BITWIDTH(6)
   ) disp_check_inst (
    .symbol_in     (encoded_symbol),
    .disparity_out (run_disparity_neg_post_5b6b)
  );


endmodule
