module forwarding_unit_branch (
    input  wire [4:0] AddrA,        // IF/ID.rs1
    input  wire [4:0] AddrB,        // IF/ID.rs2
    input  wire [4:0] AddrD_M,      // EX/MEM.rd
    input  wire [4:0] AddrD_WB,     // MEM/WB.rd
    input  wire [4:0] AddrD_E, 

    input  wire       RegWen_M,     // EX/MEM.RegWrite
    input  wire       RegWen_WB,    // MEM/WB.RegWrite
    input  wire       WBSel_M,      // 0=Mem, 1=ALU (EX/MEM stage)
    input  wire       is_JALR,      // JALR instruction flag
    input  wire       WBSel_E, 
       
    output reg        Forward_JALR, 
    output reg  [1:0] Control_unit1, // RS1: 00=RF, 01=EX/MEM, 10=MEM/WB
    output reg  [1:0] Control_unit2  // RS2: 00=RF, 01=EX/MEM, 10=MEM/WB
);

    // localparams để dễ đọc
    localparam [1:0] REGFILE_DATA = 2'b00;
    localparam [1:0] EX_MEM_DATA  = 2'b01;  // forward từ EX/MEM (ALU hoặc Mem)
    localparam [1:0] MEM_WB_DATA  = 2'b10;  // forward từ MEM/WB

    // forward cho RS1
    always @(*) begin
        Control_unit1 = REGFILE_DATA;

        if (RegWen_M && (AddrD_M != 0) && (AddrD_M == AddrA) && (WBSel_M == 1'b1)) begin
            // EX/MEM stage, ALU result
            Control_unit1 = EX_MEM_DATA;
        end
        else if (RegWen_WB && (AddrD_WB != 0) && (AddrD_WB == AddrA) &&
                 !(RegWen_M && (AddrD_M != 0) && (AddrD_M == AddrA))) begin
            // MEM/WB stage (ưu tiên thấp hơn EX/MEM)
            Control_unit1 = MEM_WB_DATA;
        end
    end

    // forward cho RS2
    always @(*) begin
        Control_unit2 = REGFILE_DATA;

        if (RegWen_M && (AddrD_M != 0) && (AddrD_M == AddrB) && (WBSel_M == 1'b1)) begin
            Control_unit2 = EX_MEM_DATA;
        end
        else if (RegWen_WB && (AddrD_WB != 0) && (AddrD_WB == AddrB) &&
                 !(RegWen_M && (AddrD_M != 0) && (AddrD_M == AddrB))) begin
            Control_unit2 = MEM_WB_DATA;
        end
    end

    always @(*) begin
        if (is_JALR && (AddrA == AddrD_M) && (AddrD_M != 0) && WBSel_M == 1'b1) begin
            Forward_JALR = 1'b1;  // forward từ EX/MEM ALU
        end else begin
            Forward_JALR = 1'b0;
        end
    end


endmodule