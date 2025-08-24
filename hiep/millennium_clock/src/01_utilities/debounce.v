/*
* sử dụng để khử nhiễu khi ấn 
*/
module debounce #(
    parameter CLK_FREQ_KHZ = 1, 
    parameter DEBOUNCE_TIME_MS = 10 
) (
    input           clk, 
    input           rst_n,      // Thêm reset active-low
    input           button_in,
    output          button_out
);
    localparam COUNTER_MAX = CLK_FREQ_KHZ * DEBOUNCE_TIME_MS; // cần đếm 10 chu kỳ đồng hồ 
    
    reg [$clog2(COUNTER_MAX)-1:0] counter;  // biến đếm có độ rộng đủ 
    reg int_button_out;
    assign button_out = int_button_out;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            int_button_out <= 1'b1; // push dạng active_low, nên ở trạng thái nhỉ tín hiệu luôn là 1
        end else begin
            if (button_in == int_button_out) begin
                counter <= 0;
            end else begin
                if (counter == COUNTER_MAX - 1) begin
                    int_button_out <= ~int_button_out;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
