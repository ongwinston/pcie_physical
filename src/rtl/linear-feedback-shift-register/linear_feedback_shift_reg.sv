/*
Linear Feedback shift register Implementing a Galois style LFSR

Polynomial implemented : G(x) = x^16 + x^5 + x^4 + x^3 + 1

Used for data scrambling before data encoding

*/


module linear_feedback_shift_reg (
    input logic clk_i,
    input logic rst_i,
    input logic data_i,
    output logic data_o
);

    // localparam COM = 8'hFF;

    logic [15:0] lfsr_r = 16'hFFFF;
    logic [7:0] data_shift_r = 8'h00;
    logic [7:0] bit_cnt = 8'h00;
    logic byte_indicator;

    always_ff @(posedge clk_i) begin
        if(rst_i) begin
            lfsr_r <= 16'hFFFF;
        end else begin
            lfsr_r <= { lfsr_r[14],
                        lfsr_r[13],
                        lfsr_r[12],
                        lfsr_r[11],
                        lfsr_r[10],
                        lfsr_r[9],
                        lfsr_r[8],
                        lfsr_r[7],
                        lfsr_r[6],
                        lfsr_r[5], // TAP
                        (lfsr_r[4] ^ lfsr_r[15]), // TAP
                        (lfsr_r[3] ^ lfsr_r[15]), // TAP
                        (lfsr_r[2] ^ lfsr_r[15]),
                        lfsr_r[1],
                        lfsr_r[0],
                        lfsr_r[15]
            };
        end
    end

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            data_shift_r <= 8'h00;
        end else begin
            // Data shifts in from the MSB -> LSB
            data_shift_r <= {data_i, data_shift_r[6:0]};
        end
    end


    always_ff @(posedge clk_i) begin
        if(rst_i) begin
            bit_cnt <= 8'h00;
        end else begin
            if(bit_cnt == 8'h08) begin
                bit_cnt <= 8'h01;
            end else begin
                bit_cnt <= bit_cnt + 1'h1;
            end
        end
    end

    assign byte_indicator = (bit_cnt == 8'h08) ? 1'b1 : 1'b0;


    assign data_o = data_shift_r[0] ^ lfsr_r[15];



endmodule
