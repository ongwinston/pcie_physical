/*
  Controller and wrapper for Multi Lanes links
  Instantiate multiple scramblers per lane
  and Encoders

  Input 8 bit Data from either the:
    - Data Link Layer in the form of DLL Packets (DLLP)
    - TL Packets (TLP)


  --> Scrambler (xN) --> Encoder 8b10b --> Serialiser --> lane_bit_o
*/

module multi_lane_controller #(
  parameter int NUM_LANES = 4,
  parameter int DATA_WIDTH = 8
) (
    input logic                         clk_i,
    input logic                         rst_i,
    input logic [NUM_LANES-1:0]         lane_enable_i, // Lane Enable signal from the controller, with a load
    input logic [7:0]                   data_frame_i,
    input logic                         data_frame_valid_i,

    input logic                         bypass_scrambler_i,
    input logic                         is_ordered_set_i,

    // TX data to Physical Electrical layer
    output logic [NUM_LANES-1:0]        lane_symbol_o,
    output logic [NUM_LANES-1:0]        lane_symbol_valid_o
);

  //======================================================================================================
  // Wires
  //======================================================================================================

  logic [DATA_WIDTH-1 : 0] scrambled_data [0:NUM_LANES-1];
  logic scrambled_data_valid[0:NUM_LANES-1];

  logic [7:0] data_scrambler_in;
  logic       scrambler_in_valid;

  assign data_scrambler_in = bypass_scrambler_i ? 8'h0 : data_frame_i;
  assign scrambler_in_valid = bypass_scrambler_i ? 1'b0 : data_frame_valid_i;


  //======================================================================================================
  // Data packet striping
  // Apply symbol striping on Data blocks (Framing Tokens, TLPs, DLLPs)
  // Bypass Lane striping when TX is Ordered Set block, OS sends same symbols on all lanes
  //======================================================================================================
  logic pre_striped_data_valid;

  assign pre_striped_data_valid = is_ordered_set_i ? 1'b0 : data_frame_valid_i;

  data_lane_striper #(

  ) data_striper_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),

    .pre_striped_data_i(data_frame_i),
    .pre_striped_data_valid_i(pre_striped_data_valid),

    // Out
    .post_striped_data_o(),
    .post_striped_data_valid_o()
  );


  //======================================================================================================
  // Scramblers
  // Bypass scrambler for Ordered sets & K Symbols
  //======================================================================================================

  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_scramblers
      scrambler #(
        .NUM_LANES(NUM_LANES),
        .DATA_WIDTH(DATA_WIDTH)
      ) scrambler_inst (
        .clk_i                  (clk_i),
        .rst_i                  (rst_i),
        .data_frame_i           (data_scrambler_in),
        .data_frame_valid_i     (scrambler_in_valid),
        .scrambler_ready_o      (),
        .data_scrambled_o       (scrambled_data[i]),
        .data_scrambled_valid_o (scrambled_data_valid[i])
      );
    end
  endgenerate

  //======================================================================================================
  // Encoders
  //======================================================================================================
  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_encoders
      encoder_8b10b dut_encoder_8b10b (
        .clk_i                  (clk_i),
        .rst_i                  (rst_i),
        .data_i                 (),
        .encoded_8b10b_symbol_o (),
        .is_special_k_i         (1'b0)
      );
    end
  endgenerate
  //======================================================================================================
  // Assigns
  //======================================================================================================


endmodule
