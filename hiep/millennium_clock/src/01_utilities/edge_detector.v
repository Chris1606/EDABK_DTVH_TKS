/*
* phát hiện sườn tín hiệu, tạo tín hiệu sạch
*/
module edge_detector (
    input           clk,
    input           rst_n,      // Thêm reset active-low
    input           level_in, 
    output          pulse_out
);
    reg temp;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 1'b0;
        end else begin
            temp <= level_in;
        end
    end
    
    assign pulse_out = level_in & ~temp;
endmodule