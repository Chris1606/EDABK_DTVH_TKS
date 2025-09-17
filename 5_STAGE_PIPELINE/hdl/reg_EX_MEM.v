module reg_EX_MEM(
    input wire          clk, 
    input wire          rst_n, 

    input wire          WBSEL_E,
    input wire          RegWen_E, 
    input wire          MemWriteEn_E,
    input wire          MemReadEn_E,
    input wire [31 : 0] ALU_res_E, 
    input wire [4 : 0]  AddrD_E,
    input wire [31 : 0] temp_srcB_E,
    input wire [31 : 0] Instruction_E,

    output reg [31 : 0] Instruction_M,
    output reg          WBSel_M,
    output reg          RegWen_M, 
    output reg          MemWriteEn_M,
    output reg          MemReadEn_M,
    output reg [31 : 0] ALU_res_M, 
    output reg [4 : 0]  AddrD_M,
    output reg [31 : 0] temp_srcB_M
    

); 
    always @(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            WBSel_M         <= 0; 
            RegWen_M        <= 0; 
            MemWriteEn_M    <= 0; 
            MemReadEn_M     <= 0; 
            ALU_res_M       <= 0; 
            AddrD_M         <= 0;
            temp_srcB_M     <= 0;  
            Instruction_M   <= 0; 
        end 
        else begin 
            Instruction_M   <= Instruction_E; 
            WBSel_M         <= WBSEL_E; 
            RegWen_M        <= RegWen_E; 
            MemWriteEn_M    <= MemWriteEn_E; 
            MemReadEn_M     <= MemReadEn_E; 
            ALU_res_M       <= ALU_res_E; 
            AddrD_M         <= AddrD_E;
            temp_srcB_M     <= temp_srcB_E;
        end 
    end 



endmodule