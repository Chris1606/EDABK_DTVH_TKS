module instruction_memory #(
    parameter INSTRUCTION_WIDTH = 32,
    parameter MEM_DEPTH = 64
)(
    // input  wire                             read, 
    input  wire [INSTRUCTION_WIDTH - 1 : 0] A,   // Address (PC)
    
    output wire [INSTRUCTION_WIDTH - 1 : 0] RD   // Instruction at address
    // output wire                             ready
);

    // Instruction memory block
    reg [INSTRUCTION_WIDTH - 1 : 0] memory [0 : MEM_DEPTH - 1];

    initial begin
        $readmemh("/home/snappys/EDBAK/Thinh/DIGITAL_DESIGN/RISCV/SINGLE_CYCLE/data/instructions.txt", memory);
    end

    // Word-aligned access (A[1:0] are byte offsets, so drop them)
    assign RD    = memory[A[31 : 2]]; 
    
endmodule
