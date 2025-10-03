
module bin_to_gray #(
  parameter CNTR_WIDTH = 8
)(
    input clk,
    input reset,
    input logic [CNTR_WIDTH-1:0] binary_i,
    output logic [CNTR_WIDTH-1:0] gray_code_o
);



  // genvar i;
  // generate
  //   for(i = 0; i < CNTR_WIDTH-1; i=i+1) begin
  //     assign gray_code_o[i] = binary_i[i] ^ binary_i[i-1];
  //   end
  // endgenerate

  // assign gray_code_o[CNTR_WIDTH-1] = binary_i[CNTR_WIDTH-1];


  // Implementation 2
  // More Area and power
  assign gray_code_o = binary_i ^ (binary_i>>1);

endmodule
