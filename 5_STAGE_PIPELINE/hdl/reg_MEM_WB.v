module reg_MEM_WB(
    input wire      clk, 
    input wire      rst_n, 
 
    input wire      WBSel_M, 
    input wire      RegWen_M, 
    input [31 : 0]  ReadData_M, 
    input [31 : 0]  ALU_res_M, 
    input wire [4 :0] AddrD_M,
    output reg [4 : 0]     AddrD_W,
    output reg      WBSel_W, 
    output reg      RegWen_W, 

    output reg [31 : 0] ReadData_W,
    output reg [31 : 0] ALU_res_W
); 
    always @(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            WBSel_W     <= 0;
            RegWen_W    <= 0;
            ReadData_W  <= 0;
            ALU_res_W   <= 0;
            AddrD_W  <= 0; 
        end
        else begin 
            AddrD_W     <= AddrD_M; 
            WBSel_W     <= WBSel_M;
            RegWen_W    <= RegWen_M;
            ReadData_W  <= ReadData_M;
            ALU_res_W   <= ALU_res_M;
        end 
    end


endmodule