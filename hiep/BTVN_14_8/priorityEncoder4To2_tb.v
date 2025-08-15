// Testbench for priorityEncoder4To2 (Corrected Version)
`timescale 1ns / 1ps

module priorityEncoder4To2_tb;

    // Inputs
    reg [3:0] in_tb;

    // Outputs
    wire [1:0] out_tb;
    
    // Testbench internal variables
    integer i; // <-- SỬA LỖI: Di chuyển khai báo ra đây

    // Instantiate the Device Under Test (DUT)
    priorityEncoder4To2 dut (
        .in(in_tb),
        .out(out_tb)
    );

    // Stimulus process
    initial begin
        // Hiển thị tiêu đề
        $display("Starting Testbench for priorityEncoder4To2");
        $display("-------------------------------------------");
        $display("Time | Input in[3:0] | Output out[1:0]");
        $display("-------------------------------------------");

        // Sử dụng $monitor để tự động in ra kết quả mỗi khi có tín hiệu thay đổi
        $monitor("%4d | %4b        | %2b", $time, in_tb, out_tb);

        // Khởi tạo đầu vào
        in_tb = 4'b0000;
        #10;

        // Vòng lặp để kiểm tra tất cả 16 trường hợp
        for (i = 0; i < 16; i = i + 1) begin
            in_tb = i;
            #10; // Đợi 10ns
        end

        // Kết thúc simulation
        $display("-------------------------------------------");
        $display("Testbench simulation finished.");
        $finish;
    end

endmodule