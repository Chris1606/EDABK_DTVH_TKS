module ex_3_6_16 (
    input clk, rst_n, up_en, down_en,
    output reg [3:0] counter
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0000; // Reset counter to 0
        end else if (up_en) begin
            counter <= counter + 1'b1; // Increment counter
        end else if (down_en) begin
            counter <= counter - 1'b1; // Decrement counter
        end else begin
            counter <= counter; // Hold current value
        end
    end     
endmodule