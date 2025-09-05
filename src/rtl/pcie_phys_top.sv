/**/

module pcie_phys_top #(
  parameter int MAC_FRAME_WIDTH = 32,
  parameter int NUM_LANES = 4
) (
  input logic                       clk_i,
  input logic                       rst_i,

  // Transactions from our Data Link Layer
  input logic [MAC_FRAME_WIDTH-1:0] mac_data_frame_i,
  input logic                       mac_data_frame_valid_i,
  output logic                      mac_data_frame_ready_o,

  // Electrical RX
  input logic [NUM_LANES-1 : 0]     electrical_sub_load_detect_i, // Electrical sub block load indicator

  // Symbols out to Electrical Lanes
  output logic [NUM_LANES-1 : 0]    electrical_sub_out_symbol_o // Electrical sub block serilised bits out

);


  //======================================================================================================
  // logic
  //======================================================================================================

  logic phy_lane_detected;
  logic [7:0] data_frame;
  logic [9:0] encoded_symbol;
  logic en8b10b;
  logic en128b130b;
  logic bypass_scrambler;

  // TODO: Fix temp assigns
  assign data_frame = mac_data_frame_i[7:0];
  assign mac_data_frame_ready_o = 1'b1;

  //======================================================================================================
  // pcie_controller
  //======================================================================================================

  pcie_controller #(
    .NUM_LANES(NUM_LANES)
  ) pcie_controller_dut (
    .clk_i                   (clk_i),
    .rst_i                   (rst_i),

    .phy_layer_lane_detect_i (electrical_sub_load_detect_i),

    .bypass_scrambler_o      (bypass_scrambler),

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

     - Instantiate Encoders per lane
  */

  // TODO
  logic [NUM_LANES-1: 0] lane_en; // Enable lanes from the Controller detection of lane load
  assign lane_en = 4'd7; // Enable all lanes

  multi_lane_controller #(
    .NUM_LANES(NUM_LANES)
  ) multi_lane_controller_inst (
    .clk_i               (clk_i),
    .rst_i               (rst_i),
    .lane_enable_i       (lane_en),
    .data_frame_i        (8'hf), // TODO
    .data_frame_valid_i  (1'b1),
    .bypass_scrambler_i  (bypass_scrambler),

    .lane_symbol_o       (electrical_sub_out_symbol_o),
    .lane_symbol_valid_o ()
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
