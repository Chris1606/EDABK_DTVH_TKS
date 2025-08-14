// ví dụ về cú pháp if-else trong Verilog
// không khuyến khích sử dụng latch
// nếu không có điều kiện nào được chọn
module ex_3_6_14(
    input [1:0] alu_func, 
    input [4:0] a, b,
    output reg [4:0] res
);
    parameter alu_add = 2'b00;
    parameter alu_and = 2'b01;

    always @(alu_func or a or b) begin
        // tranh latch khi khong co dieu kien
        // khong khuyen khich su dung
        res = 0 ;

        if( alu_add)
            res = a + b;
        else if(alu_func == alu_and)
            res = a & b;
    end

endmodule