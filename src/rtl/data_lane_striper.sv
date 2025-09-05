/*
 * Data Striping module
 * Will allocate the data symbol to the different enabled lanes
 */

module data_lane_striper #(

) (
  input logic clk_i,
  input logic rst_i,

  input logic [7:0] pre_striped_data_i,
  input logic pre_striped_data_valid_i,

  // Out
  output logic [7:0] post_striped_data_o,
  output logic       post_striped_data_valid_o
);


  logic [7:0] post_striped_data;
  logic post_striped_data_valid;

  //------------------------------------------------------------------
  // Logic
  //------------------------------------------------------------------

  always_comb begin
    post_striped_data = pre_striped_data_i;
    post_striped_data_valid = pre_striped_data_valid_i;
  end

  //------------------------------------------------------------------
  // Output assigns
  //------------------------------------------------------------------

  assign post_striped_data_o = post_striped_data;
  assign post_striped_data_valid_o = post_striped_data_valid;


endmodule
