module boDemVong (
    input clk,
    input enable,
    input rst_n,
    output reg [7:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'b0000_0001;    
        end
        else if (enable) begin
            count <= {count[6:0], count[7]}; 
        end
    end
endmodule