/*
* bộ sinh tín hiệu chuẩn cho ngày tháng năm và sử lý năm nhuận
 */
module date_counter (
    input           clk,
    input           rst_n,
    input           day_tick_in, // tín hiệu báo đã qua một ngày, nhận data từ giờ
    input           load,
    input [4:0]     day_in,
    input [3:0]     month_in,
    input [15:0]    year_in,
    output reg [4:0] day_out,
    output reg [3:0] month_out,
    output reg [15:0] year_out
);
    reg [4:0] days_in_month;
    wire is_leap_year;
    assign is_leap_year = ((year_out % 4 == 0) && (year_out % 100 != 0)) || (year_out % 400 == 0); // ktra năm nhuận

    always @(month_out) begin // gán ngày cho tháng
        case (month_out)
            4, 6, 9, 11: days_in_month = 30;
            2:           days_in_month = is_leap_year ? 29 : 28;
            default:     days_in_month = 31;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin // giá trị default
            day_out   <= 19;
            month_out <= 8;
            year_out  <= 2025;
        end else begin
            if (load) begin // nạp data 
                day_out   <= day_in; 
                month_out <= month_in;
                year_out  <= year_in;
            end else if (day_tick_in) begin // không nạp data
                if (day_out == days_in_month) begin
                    day_out <= 1; // lặp về đầu tháng
                    if (month_out == 12) begin
                        month_out <= 1; // lặp về đầu năm, tháng 1 
                        year_out <= year_out + 1; // tăng 1 năm khi 
                    end else begin
                        month_out <= month_out + 1; // nếu tháng không phải là 12 thì tháng tăng 1
                    end
                end else begin
                    day_out <= day_out + 1;
                end
            end
        end
    end
endmodule