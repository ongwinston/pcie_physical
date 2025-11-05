/*
 * Data Striping module
 * Will allocate the data symbol to the different enabled lanes
 */

module data_lane_striper #(
  parameter int NUM_LANES = 4,
  parameter int DATA_WIDTH = 8

) (
  input logic                         clk_i,
  input logic                         rst_i,

  input logic [7:0]                   pre_striped_data_i,
  input logic                         pre_striped_data_valid_i,
  output logic                        pre_striped_data_ready_o,

  // data_id indicator for lane

  input logic                         num_lanes_enabled_i [NUM_LANES],

  // Out
  output logic [DATA_WIDTH-1 : 0]     post_striped_data_o [NUM_LANES],
  output logic                        post_striped_data_valid_o [NUM_LANES],
  output logic                        stripe_tx_go_o

);


  logic [DATA_WIDTH-1 : 0]           post_striped_data [NUM_LANES];
  logic                              post_striped_data_valid [NUM_LANES];

  // Indicator that all lanes are loaded and ready to go
  logic                              tx_go;

  // Counter to increment on every valid pre_striped data in
  logic [$clog2(NUM_LANES)-1 : 0]    cntr_r, cntr_nxt;

  // cntr trigger number = number of enabled lanes
  // We buffer this much data to
  logic [$clog2(NUM_LANES)-1 : 0]    cntr_max;


  // Buffers for lanes
  logic [DATA_WIDTH-1:0]             lane_buffers[NUM_LANES];

  logic                              stripe_tx_go;
  logic                              lane_buffer_empty_r;


  //------------------------------------------------------------------
  // Logic
  //------------------------------------------------------------------

  unary_to_binary #(
    .UNARY_SIZE(NUM_LANES)
  ) convert_to_bin_inst (
    .unary_i  (num_lanes_enabled_i),
    .binary_o (cntr_max)
  );


  assign cntr_nxt = (cntr_r == cntr_max) ? 'd0 : cntr_r + 1'b1;
  assign stripe_tx_go = (cntr_r == cntr_max && !lane_buffer_empty_r) ? 1'b1 : 1'b0;

  always_ff @( posedge clk_i ) begin
    if(rst_i) begin
      cntr_r <= 'd0;
      lane_buffer_empty_r <= 1'b1;
    end else begin
      if(pre_striped_data_valid_i) begin
        cntr_r <= cntr_nxt;
        lane_buffers[cntr_r] <= pre_striped_data_i;

        if(cntr_r == cntr_max) begin
          lane_buffer_empty_r <= 1'b1;
        end else begin
          lane_buffer_empty_r <= 1'b0;
        end
      end

    end
  end

  always_comb begin
    post_striped_data = lane_buffers;
    post_striped_data_valid = num_lanes_enabled_i;
  end


  //------------------------------------------------------------------
  // Output assigns
  //------------------------------------------------------------------

  assign post_striped_data_o = post_striped_data;
  assign post_striped_data_valid_o = post_striped_data_valid;
  assign stripe_tx_go_o = stripe_tx_go;


endmodule
