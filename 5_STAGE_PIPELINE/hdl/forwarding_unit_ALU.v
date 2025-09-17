module forwarding_unit_ALU(
    input  wire [4:0] AddrA_E,   // ID/EX.rs1
    input  wire [4:0] AddrB_E,   // ID/EX.rs2

    input  wire [4:0] AddrD_M,   // EX/MEM.rd
    input  wire [4:0] AddrD_W,   // MEM/WB.rd

    input  wire       RegWen_M,  // EX/MEM.RegWrite
    input  wire       RegWen_W,  // MEM/WB.RegWrite

    output reg  [1:0] control_temp_srcA_unit, // MUX select for ALU srcA
    output reg  [1:0] control_temp_srcB_unit  // MUX select for ALU srcB
);

    localparam ID_EX_DATA  = 2'b00; // from Register File (không forward)
    localparam EX_MEM_DATA = 2'b01; // forward from EX/MEM (ALUResult)
    localparam WB_DATA     = 2'b10; // forward from MEM/WB (Writeback)

    // Combinational
    always @* begin

        control_temp_srcA_unit = ID_EX_DATA;
        control_temp_srcB_unit = ID_EX_DATA;

        // --------- SRC A (rs1) ----------
        // Prority EX/MEM 
        if (RegWen_M && (AddrD_M != 5'd0) && (AddrD_M == AddrA_E)) begin
            control_temp_srcA_unit = EX_MEM_DATA;
        end

        else if (RegWen_W && (AddrD_W != 5'd0) && (AddrD_W == AddrA_E)) begin
            control_temp_srcA_unit = WB_DATA;
        end

        // --------- SRC B (rs2) ----------
        if (RegWen_M && (AddrD_M != 5'd0) && (AddrD_M == AddrB_E)) begin
            control_temp_srcB_unit = EX_MEM_DATA;
        end
        else if (RegWen_W && (AddrD_W != 5'd0) && (AddrD_W == AddrB_E)) begin
            control_temp_srcB_unit = WB_DATA;
        end
    end
endmodule
