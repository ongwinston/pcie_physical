/*
 * Packet Assembly Module
 * Form the Ordered Set bits or Data start sets needed for Transmission
 */


module packet_assembly #(

) (
  input logic clk_i,
  input logic rst_i,

  //input logic //control package

  // 8 bit data to either be scrambled or encoded to the multi-lane controller
  // Data goes to Lane striper

  output logic [7:0] data_pkt_o,
  output logic       data_pkt_valid_o
);

  logic [7:0] data_pkt;
  logic data_pkt_valid;


  //===========================================
  // Logic
  //===========================================

  always_comb begin
    data_pkt = 8'h0;
    data_pkt_valid = 1'b0;
  end

  //--------------------------------------------
  // Output Assigns
  //--------------------------------------------

  assign data_pkt_o = data_pkt;
  assign data_pkt_valid_o = data_pkt_valid;

endmodule
