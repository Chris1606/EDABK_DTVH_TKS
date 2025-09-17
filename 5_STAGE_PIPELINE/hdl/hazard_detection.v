module hazard_detection(
    input  wire [4:0]   AddrA,       // IF/ID.rs1
    input  wire [4:0]   AddrB,       // IF/ID.rs2
    input  wire [4:0]   AddrD_E,     // ID/EX.rd
    input  wire [4:0]   AddrD_M,     // EX/MEM.rd (không dùng nếu có forward cho comparator ID)
    
    input  wire         MemReadEn_E, // 1 = load ở EX
    input  wire         MemReadEn_M, // 1 = load ở MEM (không dùng nếu có forward cho comparator ID)

    input wire          is_JALR, 
    input wire          is_Branch, 

   
    output reg          ID_EX_control_unit_select, 

    output reg          Stall
);
    always @(*) begin
        if (MemReadEn_E &&  (AddrD_E != 0) && ((AddrD_E == AddrA) || (AddrD_E == AddrB))) begin // LW hazard detected
            ID_EX_control_unit_select = 1'b1;
            Stall = 1'b1;
        end else if(is_Branch && MemReadEn_M && (AddrD_M != 0) && ((AddrD_M == AddrA) || (AddrD_M == AddrB))) begin // LW hazard detected for branch
            ID_EX_control_unit_select = 1'b1;
            Stall = 1'b1; 
        end else if (is_JALR && (AddrD_E != 0) && (AddrD_E == AddrA)) begin // JALR hazard detected
            ID_EX_control_unit_select = 1'b1;
            Stall = 1'b1;
        end else if (is_Branch && (AddrD_E != 0) && ((AddrD_E == AddrA) || (AddrD_E == AddrB))) begin // Branch hazard detected
            ID_EX_control_unit_select = 1'b0;
            Stall = 1'b1;
        end else begin
            ID_EX_control_unit_select = 1'b0;
            Stall = 1'b0; 
        end
    end
    wire a = is_Branch; 
    wire [4 : 0] b = AddrD_E;
    wire [4 : 0] c = AddrA;
    wire [4 : 0] d = AddrB;
endmodule
