module reg_IF_ID #(
    parameter [31:0] NOP = 32'h00000013   // RISC-V NOP: addi x0, x0, 0
)(
    input  wire        clk,
    input  wire        rst_n, 
    input  wire        IF_flush, 
    input  wire        Stall, 
    input  wire [31:0] Instruction, 
    input  wire [31:0] PC, 

    output reg  [31:0] PC_D,            // PC at Decode stage
    output reg  [31:0] Instruction_D    // Instruction at Decode stage
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC_D          <= 32'b0;
            Instruction_D <= NOP;   
        end else if (Stall) begin
            PC_D          <= PC_D;
            Instruction_D <= Instruction_D;    
        end else if (IF_flush) begin
            PC_D          <= 32'b0;    
            Instruction_D <= NOP;
        end else begin
            PC_D          <= PC;
            Instruction_D <= Instruction;
        end
    end

endmodule
