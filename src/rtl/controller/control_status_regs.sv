/*
 * Basic Register module implementation to build Control and Status Registers
 */

module control_status_regs #(
  parameter int REGISTER_WIDTH = 32
) (
  input logic                                 clk_i,
  input logic                                 rst_i,
  input logic [REGISTER_WIDTH-1 : 0]  data_i,
  output logic [REGISTER_WIDTH-1 : 0] data_o
);

  // localparam BIT_WIDTH = $clog2(REGISTER_WIDTH);

  logic [REGISTER_WIDTH-1: 0] csr_reg;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      csr_reg <= REGISTER_WIDTH'(0);
    end else begin
      csr_reg <= data_i;
    end
  end

  assign data_o = csr_reg;

endmodule
