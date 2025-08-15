`timescale 1ns / 1ps

module delay_model_tb;

    // Tín hiệu của testbench
    reg         start;
    reg [7:0]   d_in;
    reg [7:0]   f_in;
    wire [7:0]  c_out;
    wire [7:0]  e_out;

    // Khởi tạo DUT
    delay_model_dut dut (
        .start(start),
        .d_in(d_in),
        .f_in(f_in),
        .c_out(c_out),
        .e_out(e_out)
    );

    initial begin
        // Chỉ cần add wave trong QuestaSim, không cần $dumpfile như Icarus
        // Nhưng nếu muốn cũng có thể dùng $wlfdumpvars cho Questa
        $monitor("[%0t ns] start=%b d_in=%3d f_in=%3d | c_out=%3d e_out=%3d",
                 $time, start, d_in, f_in, c_out, e_out);
    end

    // Quy trình kiểm tra
    initial begin
        start = 0;
        d_in  = 10;
        f_in  = 20;
        $display("--- Bắt đầu Testbench ---");

        #10 start = 1;
        #1  start = 0;

        #2  d_in = 111;
        $display("[%0t ns] TB: Thay đổi d_in thành 111", $time);

        #4  f_in = 222;
        $display("[%0t ns] TB: Thay đổi f_in thành 222", $time);

        #10;
        $display("--- Kết thúc Testbench ---");
        $finish;
    end

endmodule
