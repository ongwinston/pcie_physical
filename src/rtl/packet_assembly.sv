/*
 * Packet Assembly Module
 * Form the Ordered Set bits or Data start sets needed for Transmission


 * Input to Packet Assembly
 - Indicator for the type of Ordered Set or Token
 - valid_frame or valid_os
 - TS1
 - TS2
 - SKP
 - TLP frame
 - DLLP frame
 - EIEOS

 - valid OS or frame start

 * Output
 * - ready for frame or os to pcie_control
 * - To multi-lane-lane-link
 *  - Symbol to be scrambled or encoded


 * Packet assembly determines the scramble configuration to the lanes
 * - We take scramble enable by the pcie_control
 * - But will enable and disable the scramble based on OS symbol numbers and requirements



 * SKP Ordered Set for 8b/10b Encoder
 * - 1 COM symbol + SKP + SKP + SKP


 */

  import register_pkg::*;

module packet_assembly #(

) (
  input logic              clk_i,
  input logic              rst_i,

  //input logic //control package

  // Current data rate
  input active_data_rate_e active_data_rate_i,

  input logic              controller_bypass_scrambler_i,

  // 8 bit data to either be scrambled or encoded to the multi-lane controller
  // Data goes to Lane striper

  output logic [7:0]       data_pkt_o,
  output logic             data_pkt_valid_o
);


  /*
   * States possible for Set and Packet assembly

   */
  typedef enum logic [3:0] {
    IDLE,
    IDLE_LINKUP, // SEND IDL symbols
    TX_TS1,
    TX_TS1_MODIFIED,
    TX_TS2,
    TX_TS2_MODIFIED,
    TX_SKP_OS,
    TX_SDP,
    TX_STP,
    TX_EDP,
    TX_TX_SKP_128b130b,
    TX_EIOS,
    TX_EIEOS,
    TX_FTS
  } pkt_assembly_fsm_e;

  logic [7:0] data_pkt;
  logic data_pkt_valid;

  pkt_assembly_fsm_e pkt_state_d, pkt_state_q;

  //===========================================
  // Logic
  //===========================================

  // always_comb begin
  //   data_pkt = 8'h0;
  //   data_pkt_valid = 1'b0;
  // end


  // Registered state
  always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
      pkt_state_q <= IDLE;
    end else begin
      pkt_state_q <= pkt_state_d;
    end
  end

  // Packet/Symbol logic
  always_comb begin
    // Defaults
    pkt_state_d = IDLE;
    data_pkt = 8'h00;
    data_pkt_valid = 1'b0;

    // State Machine
    unique case (pkt_state_q)
      IDLE: begin
        // No link so we shouldnt be sending any thing out to the lanes
        pkt_state_d = TX_TS1;
      end
      IDLE_LINKUP: begin
        // IDLE but linkUp send IDL symbols
        // TODO: Remove, same as TX_EIOS
      end
      TX_TS1: begin
        /* Symbol 0, =  COM
         *  ..
         *  14-15
         */
        data_pkt = 8'hBC; // K28_5 COM
        data_pkt_valid = 1'b1;

        // TODO: State transition after sending the full TS1 OS
        pkt_state_d = TX_TS1;
      end
      TX_TS1_MODIFIED: begin
      end
      TX_TS2: begin
      end
      TX_TS2_MODIFIED: begin
      end
      TX_SKP_OS: begin
      end
      TX_SDP: begin
      end
      TX_STP: begin
      end
      TX_EDP: begin
      end
      TX_TX_SKP_128b130b: begin
      end
      TX_EIOS: begin
        /* Electrical Idle Ordered Set Sequence EIOSQ*/
        /* If data rate is 2.5, 8.0, 16.0, 32.0
         *  EIOSQ = 1 EIOS
         * If data rate is 5.0
         * EIOSQ = 2 Consecutive EIOS
         */


        // 2.5GT/s and 5.0GT/s
        // Symbol 0 = COM (K28.5)
        // Symbol 1 = IDL (K28.3)
        // Symbol 2 = IDL (K28.3)
        // SYMBOL 3 = IDL (K28.3)

        // 8.0GT/s
      end
      TX_EIEOS: begin
        // 5.0GT/s

        // 8.0GT/s

        // 16.0GT/s

        // 32.0GT/s

      end
      TX_FTS: begin
        // 2.5GT/s  5.0 GT/s
        // 8.0GT/s
      end

      default: begin
      end
    endcase
  end

  //--------------------------------------------
  // Output Assigns
  //--------------------------------------------

  assign data_pkt_o = data_pkt;
  assign data_pkt_valid_o = data_pkt_valid;

  //--------------------------------------------
  // Assertions
  //--------------------------------------------
`ifdef ASSERTIONS_ENABLED
  always_ff @(posedge clk_i) begin : assertions
      assert(data_pkt_valid_o == 1'b1) begin
      end else begin
        $display("======Test assert FAILED =======");
        $error("Test failed");
      end
  end
`endif

endmodule
