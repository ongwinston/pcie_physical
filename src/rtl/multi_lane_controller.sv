/*
  Controller and wrapper for Multi Lanes links
  Instantiate multiple scramblers per lane
  and Encoders

  Input 8 bit Data from either the:
    - Data Link Layer in the form of DLL Packets (DLLP)
    - TL Packets (TLP)


  --> Scrambler (xN) --> Encoder 8b10b --> Serializer --> lane_bit_o
*/

module multi_lane_controller #(
  parameter int NUM_LANES = 16,
  parameter int DATA_WIDTH = 8
) (
    input logic                         clk_i,
    input logic                         rst_i,
    input logic                         lane_enable_i [NUM_LANES], // Lane Enable signal from the controller, with a load
    input logic [7:0]                   data_frame_i,
    input logic                         data_frame_valid_i,

    input logic                         bypass_scrambler_i,
    input logic                         is_ordered_set_i,

    // TX data to Physical Electrical layer
    input logic                         tx_analog_clk_i,
    output logic [NUM_LANES-1:0]        lane_symbol_o,
    output logic [NUM_LANES-1:0]        lane_symbol_valid_o
);

  localparam SYMBOL_WIDTH = 10;

  //======================================================================================================
  // Wires
  //======================================================================================================

  // TODO: rename following a convention
  logic [DATA_WIDTH-1 : 0]   post_stripe_lane_data       [NUM_LANES];
  logic                      post_stripe_lane_data_valid [NUM_LANES];

  logic [DATA_WIDTH-1 : 0]   data_scrambler_in           [NUM_LANES];
  logic                      scrambler_in_valid          [NUM_LANES];

  logic [DATA_WIDTH-1 : 0]   scrambled_data              [NUM_LANES];
  logic                      scrambled_data_valid        [NUM_LANES];

  logic [DATA_WIDTH-1 : 0]   encoder_data_in             [NUM_LANES];
  logic                      encoder_data_in_valid       [NUM_LANES];

  logic [SYMBOL_WIDTH-1 : 0] encoded_symbols             [NUM_LANES];

  logic                      stripe_data_go;


  //======================================================================================================
  // Data packet striping
  // Apply symbol striping on Data blocks (Framing Tokens, TLPs, DLLPs)
  // Bypass Lane striping when TX is Ordered Set block, OS sends same symbols on all lanes
  //======================================================================================================
  logic pre_striped_data_valid;

  assign pre_striped_data_valid = is_ordered_set_i ? 1'b0 : data_frame_valid_i;

  data_lane_striper #(
    .NUM_LANES(NUM_LANES),
    .DATA_WIDTH(DATA_WIDTH)
  ) data_striper_inst (
    .clk_i                     (clk_i),
    .rst_i                     (rst_i),

    .pre_striped_data_i        (data_frame_i),
    .pre_striped_data_valid_i  (pre_striped_data_valid),
    .pre_striped_data_ready_o  (),

    .num_lanes_enabled_i       (lane_enable_i),

    // Out
    .post_striped_data_o       (post_stripe_lane_data),
    .post_striped_data_valid_o (post_stripe_lane_data_valid),
    .stripe_tx_go_o            (stripe_data_go)
  );


  //======================================================================================================
  // Scramblers
  // Bypass scrambler for Ordered sets & K Symbols
  //======================================================================================================

  generate
    for(genvar i=0; i < NUM_LANES; i = i+1) begin : gen_scrambler_inputs
      assign data_scrambler_in[i] = bypass_scrambler_i ? 8'h0 : post_stripe_lane_data[i];
      assign scrambler_in_valid[i] = bypass_scrambler_i ? 1'b0 : post_stripe_lane_data_valid[i];
    end
  endgenerate


  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_scramblers
      scrambler #(
        .NUM_LANES(NUM_LANES),
        .DATA_WIDTH(DATA_WIDTH)
      ) scrambler_inst (
        .clk_i                  (clk_i),
        .rst_i                  (rst_i),
        .data_frame_i           (data_scrambler_in[i]),
        .data_frame_valid_i     (scrambler_in_valid[i]),
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
    for(genvar i=0; i < NUM_LANES; i = i+1) begin : gen_encoder_inputs
      assign encoder_data_in[i] = (bypass_scrambler_i) ? post_stripe_lane_data[i] : scrambled_data[i];
      assign encoder_data_in_valid[i] = (bypass_scrambler_i) ? post_stripe_lane_data_valid[i] : scrambled_data_valid[i];
    end
  endgenerate

  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_encoders
      encoder_8b10b dut_encoder_8b10b (
        .clk_i                  (clk_i),
        .rst_i                  (rst_i),
        .data_i                 (encoder_data_in[i]),
        //TODO: .encoder_data_in_valid(),
        .encoded_8b10b_symbol_o (encoded_symbols[i]),
        .is_special_k_i         (1'b0)
      );
    end
  endgenerate

  //======================================================================================================
  // Serializer
  // - Datawidth 10b or 130b
  //======================================================================================================

  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_serializers
      serializer #(
        .DATA_WIDTH(10)
      ) serializer_inst (
        .clk_i               (clk_i),
        .rst_i               (rst_i),
        .symbol_data_i       (encoded_symbols[i]),
        .symbol_valid_i      (1'b0), //TODO
        .analog_tx_clk_i     (tx_analog_clk_i),
        .symbol_bit_o        (lane_symbol_o[i]),
        .symbol_bit_valid_o  (lane_symbol_valid_o[i])
      );
    end
  endgenerate

  //======================================================================================================
  // Assigns
  //======================================================================================================


endmodule
