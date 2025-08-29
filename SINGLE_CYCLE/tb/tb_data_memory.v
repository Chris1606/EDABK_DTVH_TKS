`timescale 1ns/1ps
module tb_data_memory;

    reg clk;
    reg rst_n;
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;
    wire [31:0] RD;

    // Instantiate DUT
    data_memory uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .WD(WD),
        .WE(WE),
        .RD(RD)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0;
        rst_n = 0;
        WE = 0;
        A = 0;
        WD = 0;

        #10 rst_n = 1;  // release reset

        // ===========================
        // Test 1: Write vào RAM[0]
        // ===========================
        A = 32'h0000_0000;  // địa chỉ word 0
        WD = 32'hDEADBEEF;
        WE = 1;  
        #10; // 1 chu kỳ clock

        // ===========================
        // Test 2: Write vào RAM[4] (word index 1)
        // ===========================
        A = 32'h0000_0004;  // địa chỉ word 1
        WD = 32'hFACEFACE;
        WE = 1;  
        #10;

        // ===========================
        // Test 3: Read RAM[0]
        // ===========================
        WE = 0;  
        A = 32'h0000_0000;
        #1; // vì RD là combinational nên chỉ cần delay nhỏ
        $display("Read RAM[0] = %h (expect DEADBEEF)", RD);

        // ===========================
        // Test 4: Read RAM[4]
        // ===========================
        A = 32'h0000_0004;
        #1;
        $display("Read RAM[1] = %h (expect FACEFACE)", RD);

        // ===========================
        // Kết thúc mô phỏng
        // ===========================
        #20 $finish;
    end

endmodule
