`timescale 1us / 1ns

module tb_top_century;

    reg clk;
    reg rst_n;

    reg [6:0] object_mode = 7'b000_0000; // clock mode cho tất cả
    reg manual_mode = 0;
    reg up = 0;
    reg down = 0;

    wire [3:0] seconds_tens, seconds_units;
    wire [3:0] minutes_tens, minutes_units;
    wire [3:0] hours_tens, hours_units;
    wire [3:0] day_tens, day_units;
    wire [3:0] month_tens, month_units;
    wire [3:0] year_thousands, year_hundreds, year_tens, year_units;

    wire [5:0] seconds = seconds_tens * 10 + seconds_units;
    wire [5:0] minutes = minutes_tens * 10 + minutes_units;
    wire [4:0] hours   = hours_tens * 10 + hours_units;
    wire [4:0] day     = day_tens * 10 + day_units;
    wire [4:0] month   = month_tens * 10 + month_units;
    wire [13:0] year   = year_thousands * 1000 + year_hundreds * 100 + year_tens * 10 + year_units;

    // DUT
    top_century uut (
        .clk(clk),
        .rst_n(rst_n),
        .object_mode(object_mode),
        .manual_mode(manual_mode),
        .up(up),
        .down(down),
        .seconds_tens(seconds_tens),
        .seconds_units(seconds_units),
        .minutes_tens(minutes_tens),
        .minutes_units(minutes_units),
        .hours_tens(hours_tens),
        .hours_units(hours_units),
        .day_tens(day_tens),
        .day_units(day_units),
        .month_tens(month_tens),
        .month_units(month_units),
        .year_thousands(year_thousands),
        .year_hundreds(year_hundreds),
        .year_tens(year_tens),
        .year_units(year_units)
    );

    // Clock: 250kHz → 4us chu kỳ
    always begin
        clk = 0; #2;
        clk = 1; #2;
    end

    initial begin
        $dumpfile("tb_top_century.vcd");
        $dumpvars(0, tb_top_century);

        $display("=== Simulating full year 2028 (leap year) ===");

        rst_n = 0;
        #20;
        rst_n = 1;



        // Tổng số giây của năm 2028 (năm nhuận): 366 * 24 * 60 * 60 = 31_622_400 giây
        // Mỗi giây = 1 tick → 31_622_400 chu kỳ đồng hồ
        // Mỗi tick = 4us → tổng thời gian mô phỏng = 126.4896 s

        #(4 * 2 * 63158400);  // mô phỏng đủ 366 ngày

        $display("✅ Simulation finished at time = %0t", $time);
        $stop;

    end

    // In log mỗi khi sang ngày mới (00:00:00)
    always @(posedge clk) begin
        if (seconds == 0 && minutes == 0 && hours == 0)
            $display("🕛 New Day: %02d/%02d/%04d", day, month, year);
    end

endmodule
