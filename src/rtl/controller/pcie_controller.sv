`include "ltssm_pkg.svh"

module pcie_controller (
  input clk_i,
  input rst_i
);

  ltssm_e controller_st_d, controller_st_q;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      controller_st_q <= DETECT;
    end else begin
      controller_st_q <= controller_st_d;
    end
  end

  always_comb begin
    case (controller_st_q)
      DETECT: controller_st_d = POLLING;
      POLLING: controller_st_d = CONFIGURATION;
      CONFIGURATION: controller_st_d = RECOVERY;
      RECOVERY: controller_st_d = L0;
      L0: controller_st_d = L0S;
      L0S: controller_st_d = L1;
      L1: controller_st_d = L2;
      L2: controller_st_d = DISABLED;
      DISABLED: controller_st_d = LOOPBACK;
      LOOPBACK: controller_st_d = LOOPBACK;
      default: controller_st_d = DETECT;
    endcase
  end

endmodule
