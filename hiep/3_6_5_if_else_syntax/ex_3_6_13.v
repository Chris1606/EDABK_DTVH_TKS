// ví dụ về cú pháp if-else trong Verilog
module ex_3_6_13 #( parameter n = 8) (
    input [n-1:0] a, b,
    output reg [n-1:0] y,
    input [1:0] op
);
    always @(a or b or op) begin 
    if(op == 0)
        y = a + b;
    else if(op == 1)
        y = a & b;
    else 
        y = 8'h00; // default case
    end 
endmodule 