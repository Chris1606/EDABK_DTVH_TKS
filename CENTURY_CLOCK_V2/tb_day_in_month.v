`timescale 1ns/1ps

module tb_day_in_month;
    // Inputs
    reg [3:0] month_tens;
    reg [3:0] month_units;

    reg [3:0] year_thousands;
    reg [3:0] year_hundreds;
    reg [3:0] year_tens;
    reg [3:0] year_units;

    reg rst_n;

    // Outputs
    wire [3:0] max_days_tens;
    wire [3:0] max_days_units;

    // DUT
    day_in_month uut (
        .month_tens(month_tens),
        .month_units(month_units),
        .year_thousands(year_thousands),
        .year_hundreds(year_hundreds),
        .year_tens(year_tens),
        .year_units(year_units),
        .rst_n(rst_n),
        .max_days_tens(max_days_tens),
        .max_days_units(max_days_units)
    );

    // Task hiển thị kết quả
    task show_result;
        begin
            $display("Year: %0d%0d%0d%0d  Month: %0d%0d  => Max days: %0d%0d",
                     year_thousands, year_hundreds, year_tens, year_units,
                     month_tens, month_units,
                     max_days_tens, max_days_units);
        end
    endtask

    integer m;

    initial begin
        $dumpfile("tb_day_in_month.vcd");
        $dumpvars(0, tb_day_in_month);

        rst_n = 0;
        #5 rst_n = 1;

        // Test năm nhuận 2024
        year_thousands = 4'd2;
        year_hundreds  = 4'd0;
        year_tens      = 4'd2;
        year_units     = 4'd4;

        for (m = 1; m <= 12; m = m + 1) begin
            month_tens = m / 10;
            month_units = m % 10;
            #1 show_result();
        end

        // Test năm không nhuận 2023
        year_thousands = 4'd2;
        year_hundreds  = 4'd0;
        year_tens      = 4'd2;
        year_units     = 4'd3;

        for (m = 1; m <= 12; m = m + 1) begin
            month_tens = m / 10;
            month_units = m % 10;
            #1 show_result();
        end

        // Test năm chia hết cho 100 nhưng không chia hết cho 400 (2100 -> không nhuận)
        year_thousands = 4'd2;
        year_hundreds  = 4'd1;
        year_tens      = 4'd0;
        year_units     = 4'd0;

        for (m = 1; m <= 12; m = m + 1) begin
            month_tens = m / 10;
            month_units = m % 10;
            #1 show_result();
        end

        // Test năm chia hết cho 400 (2400 -> nhuận)
        year_thousands = 4'd2;
        year_hundreds  = 4'd4;
        year_tens      = 4'd0;
        year_units     = 4'd0;

        for (m = 1; m <= 12; m = m + 1) begin
            month_tens = m / 10;
            month_units = m % 10;
            #1 show_result();
        end

        $finish;
    end

endmodule