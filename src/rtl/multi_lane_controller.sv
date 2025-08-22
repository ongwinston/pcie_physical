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

    // TX data to Physical Electrical layer
    output logic [NUM_LANES-1:0]        lane_bit_o,
    output logic [NUM_LANES-1:0]        lane_bit_valid_o
);

  //======================================================================================================
  // Wires
  //======================================================================================================

  logic [DATA_WIDTH-1 : 0] scrambled_data [1:NUM_LANES];
  logic scrambled_data_valid[1:NUM_LANES];

  //======================================================================================================
  // Scramblers
  // Bypass scrambler for Ordered sets
  //======================================================================================================

  generate
    for(genvar i=0; i < NUM_LANES; i++) begin : gen_scramblers
      scrambler #(
        .NUM_LANES(NUM_LANES),
        .DATA_WIDTH(DATA_WIDTH)
      ) scrambler_inst (
        .clk_i                  (clk_i),
        .rst_i                  (rst_i),
        .data_frame_i           (data_frame_i),
        .data_frame_valid_i     (data_frame_valid_i),
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
