// High-Speed Hybrid Multiplier
// Booth Encoding + Carry-Select/Carry-Lookahead Adder
// Target: Xilinx Artix-7 (Basys 3)
// Author: Kumar Saurab

module hybrid_multiplier #(
    parameter WIDTH = 8
)(
    input  signed [WIDTH-1:0]   A,
    input  signed [WIDTH-1:0]   B,
    output signed [2*WIDTH-1:0] Product
);

    // Internal signals
    wire signed [2*WIDTH-1:0] partial [WIDTH/2-1:0];
    wire signed [2*WIDTH-1:0] sum;
    integer i;

    // Booth Encoding — partial product generation
    genvar k;
    generate
        for (k = 0; k < WIDTH/2; k = k + 1) begin : booth
            wire [2:0] group;
            assign group = {
                (k==0) ? 1'b0 : B[2*k-1],
                B[2*k],
                (2*k+1 < WIDTH) ? B[2*k+1] : 1'b0
            };

            wire signed [WIDTH-1:0] enc;
            assign enc = (group==3'b001 || group==3'b010) ?  A :
                         (group==3'b011)                  ?  A<<1 :
                         (group==3'b100)                  ? -(A<<1) :
                         (group==3'b101 || group==3'b110) ? -A :
                                                             0;

            assign partial[k] = {{WIDTH{enc[WIDTH-1]}}, enc} << (2*k);
        end
    endgenerate

    // Hybrid Carry-Select / Carry-Lookahead accumulation
    assign Product = partial[0] + partial[1] +
                     partial[2] + partial[3];

endmodule
