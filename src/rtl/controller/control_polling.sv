/*
Polling Substate of LTSSM Link Training and Status State
*/


module control_polling #(
  // parameter int SUPPORT_5_0_GT = 1,
  // parameter int SUPPORT_8_0_GT = 1,
  // parameter int SUPPORT_16_0_GT = 1,
  // parameter int SUPPORT_32_0_GT = 1
) (
    input logic clk_i,
    input logic rst_i,

    input logic polling_en_i
);

  import ltssm_pkg::*;

  polling_sm_e polling_state_d, polling_state_q;


  assign polling_state_d = POLLING_CONFIGURATION;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      polling_state_q <= POLLING_ACTIVE;
    end else begin
      if(polling_en_i) begin
        polling_state_q <= polling_state_d;
      end
    end
  end


endmodule
