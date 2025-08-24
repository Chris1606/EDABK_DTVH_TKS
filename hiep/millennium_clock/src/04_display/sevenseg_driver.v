/*
* điều khiển quét 8 LED, hỗ trợ mode 6/8 LED và nhấp nháy.
*/
module sevenseg_driver #(
    parameter BLINK_RATE_HZ = 2,    // tốc độ nhấp nháy 
    parameter CLK_FAST_KHZ = 1      // tốc độ quét 
) 
(
    input           clk_fast, // xung nhanh để quét led 
    input           rst_n,
    input           mode_8_leds,
    input           is_blinking, // flag, chế độ nhấp nháy 
    input [31:0]    data_in,     // 8 digit x 4 bit/digit
    output [7:0]    seg,         // điều khiển led
    output reg [7:0] an          // điều khiển anot
);
    // dùng để biết đang quét số mấy 
    // mode 8 = 1 thì quét từ 0 đến 7
    // mode 8 = 0 thì quyets từ 0 đến 5
    reg [2:0] scan_counter;
    
    // btaijộ đếm tạo tần số nhấp nháy
    localparam BLINK_COUNTER_MAX = (CLK_FAST_KHZ * 1000 / BLINK_RATE_HZ) / 2;
    reg [$clog2(BLINK_COUNTER_MAX)-1:0] blink_counter;
    reg blink_en; // xung bật tắt led, tần số cố định 

    // logic bộ đếm quét
    // mode 8 = 1 thì quét từ 0 đến 7
    // mode 8 = 0 thì quyets từ 0 đến 5
    always @(posedge clk_fast or negedge rst_n) begin
        if(!rst_n) 
            scan_counter <= 0;
        else if(mode_8_leds) 
            scan_counter <= (scan_counter == 7) ? 0 : scan_counter + 1; // vòng lặp liên tục
        else 
            scan_counter <= (scan_counter == 5) ? 0 : scan_counter + 1; // vòng lặp liên tục 
    end
    
    // logic tạo tín hiệu enable nhấp nháy
    always @(posedge clk_fast or negedge rst_n) begin
        if(!rst_n) begin
            blink_counter <= 0;
            blink_en <= 1'b1;
        end else begin
            if(blink_counter == BLINK_COUNTER_MAX - 1) begin
                blink_counter <= 0;
                blink_en <= ~blink_en;
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
    end

    //  mux chọn dữ liệu bcd cho digit hiện tại
    wire [3:0] current_digit_bcd;
    assign current_digit_bcd = data_in >> (scan_counter * 4); // chứa dữ liệu cho seg hiện tại

    // decoder anot 
    always @(scan_counter) begin
        an = 8'hFF; 
        
        if (!(is_blinking && !blink_en)) begin
            case (scan_counter)
                0: an = 8'b11111110;
                1: an = 8'b11111101;
                2: an = 8'b11111011;
                3: an = 8'b11110111;
                4: an = 8'b11101111;
                5: an = 8'b11011111;
                6: an = 8'b10111111;
                7: an = 8'b01111111;
                default: an = 8'hFF;
            endcase
        end
    end

    bcd_to_7seg i_decoder (
        .bcd_in(current_digit_bcd), 
        .seg_out(seg)
    );
endmodule