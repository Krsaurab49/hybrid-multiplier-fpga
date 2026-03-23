timescale 1ns/1ps
module tb_hybrid_multiplier;
    reg  signed [7:0]  A, B;
    wire signed [15:0] Product;
    integer i, j, pass, fail;

    hybrid_multiplier #(.WIDTH(8)) uut (
        .A(A), .B(B), .Product(Product)
    );

    initial begin
        pass = 0; fail = 0;
        for (i=-128; i<=127; i=i+32) begin
            for (j=-128; j<=127; j=j+32) begin
                A=i; B=j; #10;
                if (Product===A*B) pass=pass+1;
                else begin
                    $display("FAIL:A=%0d B=%0d",A,B);
                    fail=fail+1;
                end
            end
        end
        $display("%0d PASSED | %0d FAILED",pass,fail);
        $finish;
    end
endmodule
