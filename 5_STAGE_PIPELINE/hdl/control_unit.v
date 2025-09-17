module control_unit (
    // Instruction fields (Ins[30], Ins[14:12], Ins[6:2])
    input  wire [4:0]   opcode, 
    input  wire [2:0]   funct3,
    input  wire         funct7_5,     

    output reg          is_Branch,   // detect B-type
    output reg          is_Jump,     // Jump for Branch/JAL/JALR (Cách 1)
    output reg          is_JALR,     // specific flag for JALR

    output reg          IF_flush, 
    output reg          ID_flush, 
    output reg          EX_flush,

    output reg  [2:0]   ImmSel, 
    output reg  [1:0]   ASel,        // 1: PC, 0: RS1/0
    output reg  [1:0]   BSel,        // 1: imm, 0: RS2
    output reg  [3:0]   ALUSel, 
    output reg          MemWriteEn,
    output reg          MemReadEn,   // Read enable (for loads)
    output reg          RegWen, 
    output reg          WBSel       
);
    // ========= Opcode (Ins[6:2]) =========
    localparam R_opcode       = 5'b0_1100; // 01100
    localparam I_math_opcode  = 5'b0_0100; // 00100
    localparam I_load_opcode  = 5'b0_0000; // 00000
    localparam S_opcode       = 5'b0_1000; // 01000
    localparam B_opcode       = 5'b1_1000; // 11000
    localparam J_opcode       = 5'b1_1011; // 11011 (JAL)
    localparam JALR_opcode    = 5'b1_1001; // 11001
    localparam LUI_opcode     = 5'b0_1101; // 01101
    localparam AUIPC_opcode   = 5'b0_0101; // 00101

    // ========= ALU ops =========
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b1000;
    localparam ALU_AND  = 4'b0111;
    localparam ALU_OR   = 4'b0110;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0001;
    localparam ALU_SRL  = 4'b0101;
    localparam ALU_SRA  = 4'b1101;
    localparam ALU_LT   = 4'b0010;
    localparam ALU_LTU  = 4'b0011;
    localparam ALU_ADD0 = 4'b1111; // 0 + imm (cho LUI kiểu đơn giản)

    // ========= Writeback select =========
    localparam WB_DataMem   = 1'b0;
    localparam WB_ALU       = 1'b1;

    // ========= ImmSel encodings =========
    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_J = 3'b011;
    localparam IMM_U = 3'b100;
    // ========= ASel Opcode  =========
    localparam PC_SRC   = 2'b00; 
    localparam TEMP_A   = 2'b01; 
    localparam ZERO     = 2'b10; 
    // ========= BSel Opcode  =========
    localparam IMMEDIATE   = 2'b00; 
    localparam TEMP_B   = 2'b01; 
    localparam FOUR     = 2'b10;

    // Decode
    always @(*) begin
        // ----- Defaults (NOP-like) -----
        ImmSel     = IMM_I;     
        is_Branch  = 1'b0; 
        is_JALR    = 1'b0;
        is_Jump    = 1'b0;          // Cách 1: sẽ set =1 cho B/J/JR
        ASel       = TEMP_A;
        BSel       = TEMP_B;
        ALUSel     = ALU_ADD;
        MemWriteEn = 1'b0;
        MemReadEn  = ~MemWriteEn;
        RegWen     = 1'b0;
        WBSel      = WB_ALU;

        case (opcode)
            // ========================== R-type ==========================
            R_opcode: begin
                RegWen = 1'b1;
                WBSel  = WB_ALU;
                ASel   = TEMP_A;
                BSel   = TEMP_B;
                MemReadEn  = 1'b0;
                case (funct3)
                    3'b000:  ALUSel = (funct7_5) ? ALU_SUB : ALU_ADD;
                    3'b100:  ALUSel = ALU_XOR;
                    3'b110:  ALUSel = ALU_OR;
                    3'b111:  ALUSel = ALU_AND;
                    3'b001:  ALUSel = ALU_SLL;
                    3'b101:  ALUSel = (funct7_5) ? ALU_SRA : ALU_SRL;
                    3'b010:  ALUSel = ALU_LT;
                    3'b011:  ALUSel = ALU_LTU;
                    default: ALUSel = ALU_ADD;
                endcase
            end

            // ====================== I-type arithmetic ====================
            I_math_opcode: begin
                ImmSel = IMM_I;
                RegWen = 1'b1;
                ASel   = TEMP_A;
                BSel   = IMMEDIATE;    // RS1 + imm
                WBSel  = WB_ALU;
                MemReadEn  = 1'b0;
                case (funct3)
                    3'b000: ALUSel = ALU_ADD;                    // addi
                    3'b100: ALUSel = ALU_XOR;                    // xori
                    3'b110: ALUSel = ALU_OR;                     // ori
                    3'b111: ALUSel = ALU_AND;                    // andi
                    3'b001: ALUSel = ALU_SLL;                    // slli
                    3'b101: ALUSel = (funct7_5) ? ALU_SRA : ALU_SRL; // srai/srli
                    3'b010: ALUSel = ALU_LT;                     // slti
                    3'b011: ALUSel = ALU_LTU;                    // sltiu
                    default: begin
                        RegWen = 1'b0;
                        BSel   = TEMP_B;
                        ALUSel = ALU_ADD;
                        WBSel  = WB_ALU;
                    end
                endcase
            end

            // ========================= I-type loads ======================
            I_load_opcode: begin
                ImmSel     = IMM_I;
                RegWen     = 1'b1;
                ASel       = TEMP_A;
                BSel       = IMMEDIATE;     // base + imm
                ALUSel     = ALU_ADD;  // tính địa chỉ
                MemReadEn  = ~MemWriteEn;     // <-- Quan trọng
                MemWriteEn = 1'b0;
                WBSel      = WB_DataMem; // ghi từ DMem
                // funct3 chọn kiểu load (lb/lh/lw/...) xử lý ở Load Unit
            end

            // ========================== S-type stores ====================
            S_opcode: begin
                ImmSel     = IMM_S;
                RegWen     = 1'b0;
                ASel       = TEMP_A;
                BSel       = IMMEDIATE;     // base + imm
                ALUSel     = ALU_ADD;  // tính địa chỉ
                MemReadEn  =  ~MemWriteEn;
                MemWriteEn = 1'b1;
                WBSel      = WB_ALU;   // không dùng, giữ mặc định
            end

            // =========================== B-type ==========================
            B_opcode: begin
                ImmSel     = IMM_B;
                ASel       = PC_SRC;     // PC
                BSel       = IMMEDIATE;     // imm (PC + imm<<1 ở stage nhảy)
                ALUSel     = ALU_ADD;  // dùng để tính target (PC + imm)
                MemWriteEn = 1'b0;
                MemReadEn  =  ~MemWriteEn;
                RegWen     = 1'b0;
                WBSel      = WB_ALU;

                is_Branch  = 1'b1; 
                is_JALR    = 1'b0;
                is_Jump    = 1'b1;     // Cách 1: Branch cũng set Jump
            end

            // ============================ JAL ============================
            J_opcode: begin
                ImmSel     = IMM_J;
                RegWen     = 1'b1;
                ASel       = PC_SRC;     // PC
                BSel       = FOUR;     // imm
                ALUSel     = ALU_ADD; 
                MemWriteEn = 1'b0;
                MemReadEn  = 1'b0;
                WBSel      = WB_ALU; // ghi PC+4

                is_Branch  = 1'b0; 
                is_JALR    = 1'b0;
                is_Jump    = 1'b1;
            end

            // =========================== JALR ============================
            JALR_opcode: begin
                if (funct3 == 3'b000) begin
                    ImmSel     = IMM_I;
                    RegWen     = 1'b1;
                    ASel       = PC_SRC;     // rs1
                    BSel       = FOUR;     // imm
                    ALUSel     = ALU_ADD; 
                    MemWriteEn = 1'b0;
                    MemReadEn  = 1'b0;
                    WBSel      = WB_ALU;  // ghi PC+4

                    is_Branch  = 1'b0; 
                    is_JALR    = 1'b1;
                    is_Jump    = 1'b1;      // Cách 1
                end
                else begin
                    // illegal JALR variant -> giữ NOP-like
                end
            end

            // ============================ LUI ============================
            LUI_opcode: begin
                ImmSel     = IMM_U;
                RegWen     = 1'b1;
                ASel       = ZERO;     // A:=0 (dùng ALU_ADD0)
                BSel       = IMMEDIATE;     // U-imm
                ALUSel     = ALU_ADD0; // 0 + imm
                MemWriteEn = 1'b0;
                MemReadEn  = 1'b0;
                WBSel      = WB_ALU;
            end

            // =========================== AUIPC ===========================
            AUIPC_opcode: begin
                ImmSel     = IMM_U;
                RegWen     = 1'b1;
                ASel       = PC_SRC;     // PC
                BSel       = IMMEDIATE;     // U-imm
                ALUSel     = ALU_ADD;
                MemWriteEn = 1'b0;
                MemReadEn  =  ~MemWriteEn;
                WBSel      = WB_ALU;
            end

            // =========================== DEFAULT =========================
            default: begin
                // giữ mặc định NOP-like đã set ở trên
            end
        endcase
    end

    always @(*) begin 
        case(opcode) 
            5'b1100: begin 
                IF_flush = 0; 
                ID_flush = 0; 
                EX_flush = 0; 
            end 
            5'b1_1001: begin 
                IF_flush = 1; 
                ID_flush = 0; 
                EX_flush = 0; 
            end 

            default: begin 
                IF_flush = 0; 
                ID_flush = 0; 
                EX_flush = 0; 
            end 
        endcase
    end 
endmodule
