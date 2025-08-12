`include "ltssm_pkg.svh"

module pcie_controller (
  input clk_i,
  input rst_i
);

  ltssm_e controller_st_d, controller_st_q;

  assign controller_st_d = DETECT;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      controller_st_q <= DETECT;
    end else begin
      controller_st_q <= controller_st_d;
    end
  end

endmodule
