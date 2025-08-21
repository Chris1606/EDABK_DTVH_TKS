module up_down_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    output reg  [3:0] cnt
);

    // Tín hiệu up và down luôn bằng 1
    wire up   = 1'b1;
    wire down = 1'b1;

    reg [3:0] next_cnt;

    // Logic xác định next_cnt
    always @(*) begin
        if (en) begin
            if (up)
                next_cnt = cnt + 1;
            if (down)
                next_cnt = cnt - 1;  // ghi đè nếu cả hai cùng 1
        end
        else begin
            next_cnt = cnt;
        end
    end

    // Thanh ghi lưu giá trị cnt
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else
            cnt <= next_cnt;
    end

endmodule
