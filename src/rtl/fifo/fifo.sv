module fifo #(
  parameter int DATA_W = 8,
  parameter int DEPTH  = 16,
  parameter bit RESET_ACTIVE_LOW = 1'b0
) (
  input  logic                  wclk,
  input  logic                  rclk,
  input  logic                  reset,
  input  logic                  push_i,
  input  logic [DATA_W-1:0]     push_data_i,
  input  logic                  pop_i,
  output logic [DATA_W-1:0]     pop_data_o,
  output logic                  fifo_full_o,
  output logic                  fifo_empty_o
);

  // Local parameters
  localparam int ADDR_W = $clog2(DEPTH);

  // Internal signals
  logic [ADDR_W-1:0] write_ptr_r, read_ptr_r;
  logic [ADDR_W-1:0] write_ptr_next, read_ptr_next;
  logic [ADDR_W-1:0] write_gray_ptr, read_gray_ptr;
  logic [ADDR_W-1:0] full_read_addr, empty_write_addr;

  // Memory
  logic [DATA_W-1:0] mem [DEPTH];

  // Reset signal
  logic rst;
  assign rst = RESET_ACTIVE_LOW ? !reset : reset;

  // Pointer logic
  assign write_ptr_next = (write_ptr_r == ADDR_W'(DEPTH-1)) ? '0 : write_ptr_r + 1'd1;
  assign read_ptr_next  = (read_ptr_r  == ADDR_W'(DEPTH-1)) ? '0 : read_ptr_r  + 1'd1;

  // Write pointer
  always_ff @(posedge wclk) begin
    if (rst) begin
      write_ptr_r <= '0;
    end else if (push_i && !fifo_full_o) begin
      write_ptr_r <= write_ptr_next;
    end
  end

  // Read pointer
  always_ff @(posedge rclk) begin
    if (rst) begin
      read_ptr_r <= '0;
    end else if (pop_i && !fifo_empty_o) begin
      read_ptr_r <= read_ptr_next;
    end
  end

  // FIFO full logic
  always_ff @(posedge wclk) begin
    if (rst) begin
      fifo_full_o    <= 1'b0;
      full_read_addr <= '0;
    end else if (!fifo_full_o && write_ptr_next == read_ptr_r && push_i) begin
      fifo_full_o    <= 1'b1;
      full_read_addr <= read_ptr_r;
    end else if (read_ptr_r != full_read_addr) begin
      fifo_full_o    <= 1'b0;
    end
  end

  // FIFO empty logic
  always_ff @(posedge rclk) begin
    if (rst) begin
      fifo_empty_o     <= 1'b1;
      empty_write_addr <= '0;
    end else if (fifo_empty_o && read_ptr_r != write_ptr_r) begin
      fifo_empty_o     <= 1'b0;
    end else if (!fifo_empty_o && read_ptr_next == write_ptr_r && pop_i) begin
      fifo_empty_o     <= 1'b1;
      empty_write_addr <= write_ptr_r;
    end
  end

  // Gray code pointers
  bin_to_gray #(.CNTR_WIDTH(ADDR_W)) write_gray_ptr_encoder (
    .clk(wclk), .reset(rst), .binary_i(write_ptr_r), .gray_code_o(write_gray_ptr)
  );

  bin_to_gray #(.CNTR_WIDTH(ADDR_W)) read_gray_ptr_encoder (
    .clk(rclk), .reset(rst), .binary_i(read_ptr_r), .gray_code_o(read_gray_ptr)
  );

  // Memory write
  always_ff @(posedge wclk) begin
    if (push_i && !fifo_full_o) begin
      mem[write_gray_ptr] <= push_data_i;
    end
  end

  // Output
  assign pop_data_o = mem[read_gray_ptr];

  // Assertions

  logic [$clog2(DEPTH):0] asrt_write_count;
  logic asrt_was_empty;


`ifndef SYNTHESIS
  always_ff @(posedge wclk) begin
    if (!reset) begin
      asrt_write_count <= '0;
      asrt_was_empty <= 1'b1;
    end else begin
      if (push_i && !pop_i && !fifo_full_o) begin
        asrt_write_count <= asrt_write_count + 1;
      end else if (!push_i && pop_i && !fifo_empty_o) begin
        asrt_write_count <= asrt_write_count - 1;
      end
      asrt_was_empty <= fifo_empty_o;
    end
  end

  always_ff @(posedge wclk) begin
    if (reset) begin
      // 1. Assert that we don't write to a full FIFO
      assert(!fifo_full_o || !push_i) else $error("Attempting to write to a full FIFO");

      // 2. Assert that we don't read from an empty FIFO
      assert(!fifo_empty_o || !pop_i) else $error("Attempting to read from an empty FIFO");

      // 3. Assert that the FIFO becomes full after DEPTH consecutive writes
      assert(!(asrt_write_count == $clog2(DEPTH+1)'(DEPTH) && !fifo_full_o)) else $error("FIFO did not become full after DEPTH writes");

      // 4. Assert that full and empty are never true simultaneously
      assert(!(fifo_full_o && fifo_empty_o)) else $error("FIFO cannot be both full and empty");
    end
  end

  // Cover property replacement
  always_ff @(posedge wclk) begin
    if (reset) begin
      if (asrt_was_empty && fifo_full_o) begin
        $display("Cover: FIFO transitioned from empty to full");
      end
    end
  end
`endif

endmodule
