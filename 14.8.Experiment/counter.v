module counter(
    input wire          up, down, 
    input wire          clk, rst_n, 
    output reg [7 : 0]  cnt
);
    always @(posedge clk or negedge rst_n) begin 
        if(~rst_n) begin 
            cnt <= 0; 
        end
        else if (up) begin 
            cnt <= cnt + 1; 
        end
        else if (down) begin 
            cnt <= cnt - 1; 
        end 
        else 
            cnt <= cnt; 
    end 
endmodule