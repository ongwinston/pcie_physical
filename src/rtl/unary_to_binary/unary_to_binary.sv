
module unary_to_binary #(
    parameter UNARY_SIZE = 16
) (
    input  logic                          unary_i [UNARY_SIZE],
    output logic [$clog2(UNARY_SIZE)-1:0] binary_o
);

    localparam int OUT_BITS = $clog2(UNARY_SIZE);

    logic [OUT_BITS-1:0] tmp_sum[UNARY_SIZE];
    assign tmp_sum[0] = OUT_BITS'(unary_i[0]);

    generate
        for(genvar i = 1; i < UNARY_SIZE; i = i + 1) begin : gen_unary_adder
            assign tmp_sum[i] = OUT_BITS'(unary_i[i]) + tmp_sum[i-1];
        end
    endgenerate

    assign binary_o = tmp_sum[UNARY_SIZE-1];

endmodule
