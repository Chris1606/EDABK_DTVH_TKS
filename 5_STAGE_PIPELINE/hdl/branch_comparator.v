module branch_comparator (
    input  wire [31:0] dataA,         // RS1 từ regfile
    input  wire [31:0] dataB,         // RS2 từ regfile

    input  wire        is_Branch,     // lệnh branch?
    input  wire [2:0]  funct3,        // mã lệnh BEQ/BNE/BLT/BGE/BLTU/BGEU

    // forwarding selects
    input  wire [1:0]  Control_unit1, // chọn srcA
    input  wire [1:0]  Control_unit2, // chọn srcB

    // nguồn forwarding
    input  wire [31:0] ReadData_W,    // MEM/WB.MemData
    input  wire [31:0] ALUResultM,    // EX/MEM.ALUResult

    output reg         branchCmp      // =1 nếu điều kiện branch thỏa
);
    // localparam chọn nguồn
    localparam REGFILE_DATA = 2'b00;
    localparam EX_MEM_ALU   = 2'b01;
    localparam MEM_WB_DATA  = 2'b10;

    reg [31:0] srcA, srcB;
    reg BrEq, BrLT;

    // chọn srcA
    always @* begin
        case (Control_unit1)
            REGFILE_DATA: srcA = dataA;
            EX_MEM_ALU  : srcA = ALUResultM;
            MEM_WB_DATA : srcA = ReadData_W;
            default     : srcA = dataA;
        endcase
    end

    // chọn srcB
    always @* begin
        case (Control_unit2)
            REGFILE_DATA: srcB = dataB;
            EX_MEM_ALU  : srcB = ALUResultM;
            MEM_WB_DATA : srcB = ReadData_W;
            default     : srcB = dataB;
        endcase
    end

    // tính BrEq, BrLT
    always @* begin
        BrEq = (srcA == srcB);
        BrLT = ($signed(srcA) < $signed(srcB));
    end

    // quyết định branch
    always @* begin
        if (is_Branch) begin
            case (funct3)
                3'b000: branchCmp = BrEq;                                // BEQ
                3'b001: branchCmp = ~BrEq;                               // BNE
                3'b100: branchCmp = BrLT;                                // BLT
                3'b101: branchCmp = ~BrLT;                               // BGE
                3'b110: branchCmp = ($unsigned(srcA) < $unsigned(srcB)); // BLTU
                3'b111: branchCmp = ($unsigned(srcA) >= $unsigned(srcB));// BGEU
                default: branchCmp = 1'b0;
            endcase
        end else begin
            branchCmp = 1'b1; // không phải lệnh branch
        end
    end

endmodule
