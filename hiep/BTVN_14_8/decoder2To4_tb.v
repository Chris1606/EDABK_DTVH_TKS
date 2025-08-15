// Testbench for decoder2To4 (Corrected Version)
`timescale 1ns / 1ps

module decoder2To4_tb;

    // Inputs
    reg [1:0] in_tb;

    // Outputs
    wire [3:0] out_tb;
    
    // Testbench internal variables
    integer i; // <-- SỬA LỖI: Di chuyển khai báo ra đây

    // Instantiate the Device Under Test (DUT)
    decoder2To4 dut (
        .in(in_tb),
        .out(out_tb)
    );

    // Stimulus process
    initial begin
        // Hiển thị tiêu đề cho kết quả
        $display("Starting Testbench for decoder2To4");
        $display("-----------------------------------");
        $display("Time | Input in[1:0] | Output out[3:0]");
        $display("-----------------------------------");

        // Sử dụng $monitor để tự động in ra kết quả mỗi khi tín hiệu thay đổi
        $monitor("%4d | %2b            | %4b", $time, in_tb, out_tb);

        // Khởi tạo đầu vào
        in_tb = 2'b00;
        #10;

        // Vòng lặp để kiểm tra tất cả 4 trường hợp
        for (i = 0; i < 4; i = i + 1) begin
            in_tb = i;
            #10; // Đợi 10ns
        end

        // Kết thúc simulation
        $display("-----------------------------------");
        $display("Testbench simulation finished.");
        $finish;
    end

endmodule