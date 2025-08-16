module boDich (
    input clk,
    input rst,
    input [1:0] select,
    input [3:0] Data_In,
    output reg [3:0] Data_Out
);
    always @(posedge clk) begin
        if (rst) begin
            Data_Out <= 4'b0; 
        end else begin
            case (select[1:0])
                2'b00: Data_Out <= Data_Out; 
                2'b01: Data_Out <= {Data_Out[3], Data_Out[3:1]}; 
                2'b10: Data_Out <= {Data_Out[2:0], 1'b0}; 
                2'b11: Data_Out <= Data_In; 
                default: Data_Out <= Data_Out; 
            endcase
        end
    end
endmodule