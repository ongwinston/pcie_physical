// `ifndef LTSSM_PKG
//   `define LTSSM_PKG
//   `include "ltssm_pkg.svh"
// `endif

module control_detect #(

) (
  input  logic clk_i,
  input  logic rst_i,

  input  logic any_phy_lane_detect_i, // Physical Electrical layer notifiying load on the lane
  output logic active_o // Actively listening for Electrical layer lane detect

);

  import ltssm_pkg::*;

  detect_sm_e detect_st_q, detect_st_d; // State machine
  logic quiet_timer_en; // Start of quiet timer
  logic interrupt; // Interrupt signal from quiet timer

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      detect_st_q <= DETECT_QUIET;
    end else begin
      detect_st_q <= detect_st_d;
    end
  end


  /*
   * Exit DETECT QUIT after 12ms timeout or if Electrical Idle is broken on any lane
   */
  always_comb begin
    detect_st_d = DETECT_QUIET;
    quiet_timer_en = 1'b0;
    active_o = 1'b0;

    case(detect_st_q)

      DETECT_QUIET: begin
        // Start 12 ms quiet timer
        quiet_timer_en = 1'b1;
        if(interrupt) begin
          detect_st_d = DETECT_ACTIVE;
        end
      end

      DETECT_ACTIVE: begin
        active_o = 1'b1;

        /* Transmitter performs Receiver Detection Sequence on all unconfigured lanes 8.4.5.7*/
        if(any_phy_lane_detect_i) begin
          // active_o = 1'b0;
          detect_st_d = DETECT_QUIET;
        end
      end
      default: begin
      end
    endcase

  end

  timer timer_12ms (
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .en_timer_i  (quiet_timer_en),
    .interrupt_o (interrupt)

  );


endmodule
