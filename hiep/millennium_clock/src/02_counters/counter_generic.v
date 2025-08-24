/*
* bộ sinh tín hiệu chuẩn cho giờ, phút, giây
*/
module counter_generic #(
    parameter MAX_VAL = 59
) (
    input           clk,
    input           rst_n,
    input           en,         // cho phép đếm
    input           load,       // cho phép nạp giá trị mới
    input [$clog2(MAX_VAL+1)-1:0] data_in, // data_in có độ rộng đủ biểu diễn giá trị max
    output reg [$clog2(MAX_VAL+1)-1:0] count_out,
    output reg      tick_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_out <= 0;
            tick_out <= 1'b0;
        end else begin
            tick_out <= 1'b0;
            if (load) begin
                count_out <= data_in; // hiển thị lên 7seg
            end else if (en) begin
                if (count_out == MAX_VAL) begin
                    count_out <= 0;
                    tick_out <= 1'b1;
                end else begin
                    count_out <= count_out + 1;
                end
            end
        end
    end
endmodule