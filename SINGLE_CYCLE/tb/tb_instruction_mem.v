`timescale 1ns / 1ps

module tb_instruction_memory;

    // Parameters
    localparam INSTRUCTION_WIDTH = 32;
    localparam MEM_DEPTH = 64;

    // DUT signals
    reg  [INSTRUCTION_WIDTH-1:0] A;   // Address input
    wire [INSTRUCTION_WIDTH-1:0] RD;  // Instruction output

    // Instantiate DUT
    instruction_memory #(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) dut (
        .A(A),
        .RD(RD)
    );

    // Stimulus
    initial begin
        $display("=== Instruction Memory Testbench ===");
        $display("Time\tAddress\tInstruction");

        // Start with 0
        A = 32'h0000; #10;
        $display("%0t\t%h\t%h", $time, A, RD);

        // Next word
        A = 32'h0004; #10;
        $display("%0t\t%h\t%h", $time, A, RD);

        A = 32'h0008; #10;
        $display("%0t\t%h\t%h", $time, A, RD);

        A = 32'h000C; #10;
        $display("%0t\t%h\t%h", $time, A, RD);

        // Test a few more (adjust depth if needed)
        A = 32'h0010; #10;
        $display("%0t\t%h\t%h", $time, A, RD);

        // End simulation
        #20;
        $finish;
    end

endmodule
