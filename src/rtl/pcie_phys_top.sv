/**/

module pcie_phys_top #(
  parameter int MAC_FRAME_WIDTH = 32,
  parameter int NUM_LANES = 4
) (
  input logic clk_i,
  input logic rst_i,

  // Transactions from our Data Link Layer
  input logic [MAC_FRAME_WIDTH-1:0] mac_data_frame_i,
  input logic                       mac_data_frame_valid_i,
  output logic                      mac_data_frame_ready_o,

  // Electrical RX
  input logic [$clog2(NUM_LANES)-1 : 0] electrical_sub_load_detect_o, // Electrical sub block load indicator

  // Serialised bits to Electrical Lanes
  output logic [$clog2(NUM_LANES)-1 : 0] electrical_sub_out_bits_o // Electrical sub block serilised bits out

);


  //======================================================================================================
  // logic
  //======================================================================================================

  logic phy_lane_detected;
  logic [7:0] data_frame;
  logic [9:0] encoded_symbol;

  // TODO: Fix temp assigns
  assign data_frame = mac_data_frame_i[7:0];

  //======================================================================================================
  // pcie_controller
  //======================================================================================================

  pcie_controller #(
    .NUM_LANES(NUM_LANES)
  ) pcie_controller_dut (
    .clk_i                   (clk_i),
    .rst_i                   (rst_i),

    .phy_layer_lane_detect_i (phy_lane_detected),

    .en_8b10b_encoder_o      (en8b10b),
    .en_128b130b_encoder_o   (en128b130b)
  );


  //======================================================================================================
  // Multi Lane Controller
  //======================================================================================================
  /*
    On a multi-lane link, the scrambling function can be implemented with one or many LFSRs
     Where there is more than one transmit LFSR per Link

     - When Payload is a data stream of (Framing tokens, TLPS and DLLPs), lane controller will lane stripe the symbols
       onto the lanes
  */
  multi_lane_controller #(
    .NUM_LANES(NUM_LANES)
  ) multi_lane_controller_inst (
    .clk_i            (clk_i),
    .rst_i            (rst_i),
    .lane_enable_i    (),
    .data_frame_i     (),
    .lane_bit_o       (),
    .lane_bit_valid_o ()
  );

  //======================================================================================================
  // pcie_encoders
  //======================================================================================================

  /* PCIe implementation can have multiple encoders based on the number of supported lanes */

  /*
    encoder_8b10b has a output latency of 2 cycles
      - 1 Flop after 5b6b Encoder
        - 1 Flop after 3b6b Encoder
  */
  encoder_8b10b dut_encoder_8b10b (
    .clk_i                  (clk_i),
    .rst_i                  (rst_i),
    .data_i                 (data_frame),
    .encoded_8b10b_symbol_o (encoded_symbol),
    .is_special_k_i         (1'b0)
  );




  //======================================================================================================
  // pcie_electrical_frontend
  //======================================================================================================


  //------------------------------------------------------------------------------------------------------
  // RX
  //------------------------------------------------------------------------------------------------------


  //======================================================================================================
  // RX Elastic Buffer
  //======================================================================================================


endmodule
