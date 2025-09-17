module reg_ID_EX (
    input  wire         clk, 
    input  wire         rst_n, 

    input  wire         ID_flush, 

    input  wire [31:0]  dataA, 
    input  wire [31:0]  dataB,
    input  wire [4:0]   AddrA, 
    input  wire [4:0]   AddrB, 
    input  wire [4:0]   AddrD, 
    input  wire [31:0]  Immext_D, 
    input  wire [31:0]  Instruction_D,
    input  wire [31:0]  PC, 

    // control sau ID (đã qua mux nếu bạn có Stall/Flush ở ngoài)
    input  wire         RegWen_D,
    input  wire         MemWriteEn_D, 
    input  wire         MemReadEn_D, 
    input  wire         WBSel_D,
    input  wire [1:0]   ASel_D,
    input  wire [1:0]   BSel_D,
    input  wire [3:0]   ALU_SEL_D,

    // control sau thanh ghi
    output reg  [31:0]  Instruction_E,
    output reg          RegWen_E, 
    output reg          MemWriteEn_E,  
    output reg          MemReadEn_E, 
    output reg          WBSel_E, 
    output reg  [1:0]   ASel_E, 
    output reg  [1:0]   BSel_E, 
    output reg  [3:0]   ALU_SEL_E, 

    // data sau thanh ghi 
    output reg  [31:0]  dataA_E, 
    output reg  [31:0]  dataB_E,
    output reg  [4:0]   AddrA_E, 
    output reg  [4:0]   AddrB_E,  
    output reg  [4:0]   AddrD_E, 
    output reg  [31:0]  Immext_E, 
    output reg  [31:0]  PC_E
); 

    // RISC-V NOP = ADDI x0, x0, 0
    localparam [31:0] NOP = 32'h00000013;

    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            RegWen_E        <= 1'b0;
            MemWriteEn_E    <= 1'b0;
            MemReadEn_E     <= 1'b0; 
            WBSel_E         <= 1'b0;
            ASel_E          <= 2'b00;
            BSel_E          <= 2'b00;
            ALU_SEL_E       <= 4'b0000;

            dataA_E         <= 32'b0;
            dataB_E         <= 32'b0;
            AddrA_E         <= 5'b0;
            AddrB_E         <= 5'b0;
            AddrD_E         <= 5'b0;
            Immext_E        <= 32'b0;
            PC_E            <= 32'b0;
            Instruction_E   <= 32'b0; 
        end 
        else if (ID_flush) begin 
            // Inject bubble/NOP vào EX
            RegWen_E        <= 1'b0;
            MemWriteEn_E    <= 1'b0;
            MemReadEn_E     <= 1'b0; 
            WBSel_E         <= 1'b0;
            ASel_E          <= 2'b00;
            BSel_E          <= 2'b00;
            ALU_SEL_E       <= 4'b0000;

            // Dọn sạch dữ liệu/địa chỉ để tránh forwarding nhầm
            dataA_E         <= 32'b0;
            dataB_E         <= 32'b0;
            AddrA_E         <= 5'b0;
            AddrB_E         <= 5'b0;
            AddrD_E         <= 5'b0;      // rất quan trọng để không forward từ x0
            Immext_E        <= 32'b0;
            PC_E            <= PC;        // có thể giữ PC để debug; không ảnh hưởng thực thi
            Instruction_E   <= NOP;       // đẩy NOP xuống EX
        end 
        else begin 
            // Truyền bình thường
            RegWen_E        <= RegWen_D;
            MemWriteEn_E    <= MemWriteEn_D;
            MemReadEn_E     <= MemReadEn_D; 
            WBSel_E         <= WBSel_D;
            ASel_E          <= ASel_D;
            BSel_E          <= BSel_D;
            ALU_SEL_E       <= ALU_SEL_D;

            dataA_E         <= dataA;
            dataB_E         <= dataB;
            AddrA_E         <= AddrA;
            AddrB_E         <= AddrB;
            AddrD_E         <= AddrD;
            Immext_E        <= Immext_D;
            PC_E            <= PC;
            Instruction_E   <= Instruction_D; 
        end 
    end 

endmodule
