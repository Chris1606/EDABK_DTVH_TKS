/*
* tạo xung 1hz dạng tick, sử dụng cho bộ đếm giây 
* 1khz dạng sáng vuông, sử dụng cho nhấp nháy led trong manual mode
*/
module clk_divider #( 
    parameter CLK_FREQ = 50_000_000
) (
    input           clk_in,
    input           rst_n,
    output reg      clk_1hz_tick_out, // dùng cho clock chính 
    output          clk_1khz_out // dùng để quét led 7 thanh
);
    // tạo tick 1hz
    // đếm hết 50_000_000 thì tính là 1 tick/1 giây
    reg [$clog2(CLK_FREQ)-1:0] counter_1hz;
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter_1hz <= 0;
            clk_1hz_tick_out <= 1'b0;
        end else begin
            if (counter_1hz == CLK_FREQ-1) begin
                counter_1hz <= 0;
                clk_1hz_tick_out <= 1'b1;
            end else begin
                counter_1hz <= counter_1hz+1;
                clk_1hz_tick_out <= 1'b0;
            end
        end
    end

    // tạo clock 1khz
    // chia tần số gốc thành 2, trong 1 giây 50% high, 50% low
    parameter DIV_1KHZ = CLK_FREQ / 1000 / 2;
    reg [$clog2(DIV_1KHZ)-1:0] counter_1khz;    // biến đếm cho chu kỳ sau chia 
    reg clk_1khz_reg;   // biến nhớ + gán cho output 
    assign clk_1khz_out = clk_1khz_reg; // clk = state of reg
    
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter_1khz <= 0;
            clk_1khz_reg <= 1'b0;
        end else begin
            if (counter_1khz == DIV_1KHZ - 1) begin
                counter_1khz <= 0;  // khi đếm đến giá trị max, counter về 0
                clk_1khz_reg <= ~clk_1khz_reg;  // đảo trạng thái 
            end else begin
                counter_1khz <= counter_1khz + 1;   // tăng biến counter mà trạng thái không thay đổi 
            end
        end
    end
endmodule