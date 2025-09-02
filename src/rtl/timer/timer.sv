/*
 Timer module to issue an interrupt given a specific timing in its parameter
 */

// 2,400,000
`define TIMEOUT_2_400_000 32'h249F00

`ifdef SIMULATION
  // If we are a simulation lets timeout early to save on sim time
  `define TIMEOUT 32'h100
`else
  `define TIMEOUT `TIMEOUT_2_400_000
`endif

module timer #(
  parameter int INTERRUPT_TIME_MS = 12
) (
  input clk_i,
  input rst_i,
  input en_timer_i,
  output interrupt_o
);

  logic [31:0] cnt_d, cnt_q; // Create a 32 bit counter register. We only need 21 bits for 12ms but alas.

  // Calculate the required number of cycles needed for the interrupt_time_ms
  localparam int CLOCK_FREQ_200MHZ = 200000000;
  localparam int TIMEOUT_CYCLES = CLOCK_FREQ_200MHZ * (INTERRUPT_TIME_MS/1000);



  /* Detect timer requires 12ms to pass before transitioning from Detect.Quiet ->  Detect.Active*/

  /*
   * At 200Mhz it takes 2,400,000 clock cycles to reach 12ms of time
   */

   assign cnt_d = cnt_q + 1'b1;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      cnt_q <= 32'd0;
    end else begin
      if( en_timer_i) cnt_q <= cnt_d;
      else cnt_q <= 32'd0;
    end
  end

  // Interrupt assignment
  assign interrupt_o = (cnt_q == `TIMEOUT) ? 1'b1 : 1'b0;

endmodule
