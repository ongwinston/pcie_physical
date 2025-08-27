// `ifndef LTSSM_PKG
//   `define LTSSM_PKG
//   `include "ltssm_pkg.svh"
// `endif

module pcie_controller #(
  parameter int NUM_LANES = 1
)
 (
  input  logic clk_i,
  input  logic rst_i,


  // Physical Layer Electrical
  input  logic [NUM_LANES-1 : 0] phy_layer_lane_detect_i, // Electrical Receiver Detection Sequence

  output logic en_8b10b_encoder_o,
  output logic en_128b130b_encoder_o
);

  import ltssm_pkg::*;
  import capabilities_pkg::*;

  //---------------------------------------------------------
  // Reg Wire declarations
  //---------------------------------------------------------

  ltssm_e controller_st_d, controller_st_q;
  logic linkUp_d, linkUp_q;
  logic any_lane_detected_load;
  logic [NUM_LANES-1 : 0] lanes_w_detected_load_d, lanes_w_detected_load_q;

  /* Status Registers*/
  // logic use_modified_TS1_TS2_Ordered_set;
  // logic directed_speed_change;
  // logic upconfigure_capable;
  // logic idle_to_rlock_transitioned;
  // logic select_deemphasis;
  // logic equalization_done_8GT_data_rate;
  // logic equalization_done_16GT_data_rate;
  // logic equalization_done_32GT_data_rate;

  // Detect status
  logic control_detect_active; // control_detect subblock actively in detect

  //---------------------------------------------------------
  // link capabilities reg
  //---------------------------------------------------------
  link_capabilities_2_reg_t link_reg;

  assign link_reg.drs_supported = 1'b1;
  assign link_reg.reserved2 = 6'd0;
  assign link_reg.two_retimers_presence_detected_supported = 1'b1;
  assign link_reg.retimer_presence_detected_supported = 1'b1;
  assign link_reg.lower_skp_os_reception_supported_speed_vec_rsvd = 2'b00;
  assign link_reg.lower_skp_os_reception_supported_speed_32_0_gt = 1'b1;
  assign link_reg.lower_skp_os_reception_supported_speed_16_0_gt = 1'b1;
  assign link_reg.lower_skp_os_reception_supported_speed_8_0_gt = 1'b1;
  assign link_reg.lower_skp_os_reception_supported_speed_5_0_gt = 1'b1;
  assign link_reg.lower_skp_os_reception_supported_speed_2_5_gt = 1'b1;
  assign link_reg.lower_skp_os_gen_supported_speed_vec_rsvd = 2'b00;
  assign link_reg.lower_skp_os_gen_supported_speed_32_0_gt = 1'b1;
  assign link_reg.lower_skp_os_gen_supported_speed_16_0_gt = 1'b1;
  assign link_reg.lower_skp_os_gen_supported_speed_8_0_gt = 1'b1;
  assign link_reg.lower_skp_os_gen_supported_speed_5_0_gt = 1'b1;
  assign link_reg.lower_skp_os_gen_supported_speed_2_5_gt = 1'b1;
  assign link_reg.crosslink_supported = 1'b0;
  assign link_reg.supported_link_speeds_vec_rsvd = 2'b00;
  assign link_reg.supported_link_speed_32_0_gt = 1'b1;
  assign link_reg.supported_link_speed_16_0_gt = 1'b1;
  assign link_reg.supported_link_speed_8_0_gt = 1'b1;
  assign link_reg.supported_link_speed_5_0_gt = 1'b1;
  assign link_reg.supported_link_speed_2_5_gt = 1'b1;
  assign link_reg.reserved = 1'b0;

  control_status_regs #(
    .REGISTER_WIDTH($bits(link_reg))
  ) link_capabilities_2_ff (
    .clk_i  (clk_i),
    .rst_i  (rst_i),
    .data_i (link_reg),
    .data_o ()
  );

  //---------------------------------------------------------
  // State machine transition
  //---------------------------------------------------------
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      controller_st_q <= DETECT;
    end else begin
      controller_st_q <= controller_st_d;
    end
  end



  //---------------------------------------------------------
  // State machine logic
  //---------------------------------------------------------

  assign any_lane_detected_load = |phy_layer_lane_detect_i;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      lanes_w_detected_load_q <= 'd0;
    end else begin
      lanes_w_detected_load_q <= lanes_w_detected_load_d;
    end
  end

  always_comb begin
    // Default assigns
    linkUp_d = 1'b0;
    en_8b10b_encoder_o = 1'b0; // TODO
    en_128b130b_encoder_o = 1'b0; // TODO
    controller_st_d = DETECT;
    lanes_w_detected_load_d = lanes_w_detected_load_q;

    case (controller_st_q)
      DETECT: begin
        controller_st_d = DETECT;

        // Enter polling when control_detect.active and phy_layer_lane_detect
        if(control_detect_active && any_lane_detected_load) begin
          controller_st_d = POLLING;
          lanes_w_detected_load_d = phy_layer_lane_detect_i;
        end
      end
      POLLING: begin
        /* Transmitter sends TS1 OS with lane and link numbers set to PAD on all lanes
        that detected a Receiver during Detect*/

        // lanes_w_detected_load_d  (send TS1)
          // - Data Rate Identifier symbol of the TS1 nust advertise all data rates that the port supports
          // - Transmitter must wait for its TX common mode to settle before exiting from Electrical Idle and transmitting the


        controller_st_d = POLLING;
      end
      CONFIGURATION: begin
        controller_st_d = RECOVERY;
      end
      RECOVERY: begin
        controller_st_d = L0;
      end
      L0: begin
        controller_st_d = L0S;
      end
      L0S: begin
        controller_st_d = L1;
      end
      L1: begin
        controller_st_d = L2;
      end
      L2: begin
        controller_st_d = DISABLED;
      end
      DISABLED: begin
        controller_st_d = LOOPBACK;
      end
      LOOPBACK: begin
        controller_st_d = LOOPBACK;
      end
      default: begin
        // controller_st_d = DETECT;
        // linkUp_d = 1'b0;
      end
    endcase
  end


  //---------------------------------------------------------
  // Detect Sub State Machine
  //---------------------------------------------------------
  control_detect control_detect_inst (
    .clk_i                   (clk_i),
    .rst_i                   (rst_i),
    .active_o                (control_detect_active),
    .any_phy_lane_detect_i   (any_lane_detection)
  );




  //---------------------------------------------------------
  always_ff @( posedge clk_i or posedge rst_i ) begin : status_regs
    if (rst_i) begin
      linkUp_q <= 1'b0;
    end else begin
      linkUp_q <= linkUp_d;
    end
  end

endmodule
