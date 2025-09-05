/*
Polling Substate of LTSSM Link Training and Status State
*/

  import ltssm_pkg::*;
  import capabilities_pkg::*;

module control_polling #(
  // parameter int SUPPORT_5_0_GT = 1,
  // parameter int SUPPORT_8_0_GT = 1,
  // parameter int SUPPORT_16_0_GT = 1,
  // parameter int SUPPORT_32_0_GT = 1
  parameter int NUM_LANES = 4
) (
    input logic clk_i,
    input logic rst_i,

    input logic polling_en_i,

    input link_capabilities_2_reg_t link_cap_reg_i,

    input logic [NUM_LANES-1:0] lanes_w_detected_load_i, // Lanes to send PAD

    output logic polling_exit_detect_o,
    output logic polling_exit_configuration_o
);

  // import ltssm_pkg::*;
  // import capabilities_pkg::*;

  logic en_polling_active;
  logic timer_interrupt;
  polling_sm_e polling_state_d, polling_state_q;


  //====================================================
  // State Register
  //====================================================

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      polling_state_q <= POLLING_ACTIVE;
    end else begin
      if(polling_en_i) begin
        polling_state_q <= polling_state_d;
      end
    end
  end

  always_comb begin : polling_fsm
    polling_state_d = POLLING_ACTIVE;
    en_polling_active = 1'b0;
    polling_exit_detect_o = 1'b0;
    polling_exit_configuration_o = 1'b0;

    case(polling_state_q)


      POLLING_ACTIVE: begin
        en_polling_active = 1'b1;
        if(timer_interrupt) begin
          polling_state_d = POLLING_CONFIGURATION;
        end else begin
          polling_state_d = POLLING_ACTIVE;
        end
      end


      POLLING_CONFIGURATION: begin
        polling_state_d = POLLING_COMPLIANCE;
      end


      POLLING_COMPLIANCE: begin
        polling_state_d = POLLING_SPEED;
      end


      POLLING_SPEED: begin
        polling_state_d = POLLING_SPEED;
      end


      default: begin
      end
    endcase
  end


  //=============================================================
  // Timer 24ms to
  //=============================================================
  timer #(
    .INTERRUPT_TIME_MS(24)
  ) timer_24ms (
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .en_timer_i  (en_polling_active),
    .interrupt_o (timer_interrupt)
  );

endmodule
