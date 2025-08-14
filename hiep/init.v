// hiep is here
module test (
    input [3:0] a,
    input [3:0] b,
    output y
);

    assign y = a[0] & b[0] | a[1] & b[1] | a[2] & b[2] | a[3] & b[3];

endmodule