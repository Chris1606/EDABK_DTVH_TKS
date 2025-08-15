`timescale 1ns / 1ps
module delay_model_dut (
    input               start,
    input       [7:0]   d_in,
    input       [7:0]   f_in,
    output reg  [7:0]   c_out,
    output reg  [7:0]   e_out
);
    always @(posedge start) begin
        $display("[%0t ns] DUT: Tín hiệu 'start' được kích hoạt.", $time);

        c_out = #4 d_in; // Gán d_in cho c_out sau độ trễ 4ns
        $display("[%0t ns] DUT: Đã đọc d_in (%d) và lên lịch gán cho c_out sau 4ns.", $time, d_in);

        #8; // Chờ đợi trong 8ns

        e_out = f_in; // Gán f_in cho e_out
        $display("[%0t ns] DUT: Đã gán f_in (%d) cho e_out.", $time, f_in);
    end
endmodule