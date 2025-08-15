module boDem (
    input clk, 
    input rst_n, 
    input en,
    output reg [7:0] cnt 
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            cnt <= 8'b0; 
        end else begin 
            if (en) begin
                cnt <= cnt + 1; 
            end
        end
    end

endmodule