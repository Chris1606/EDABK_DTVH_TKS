module boQuay (
    output reg [7:0] Data_out,
    input [7:0] Data_in,
    input load, clk, rst_n, en
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Data_out <= 8'b0; 
        end else if (load) begin
            Data_out <= Data_in; 
        end else if (en) begin
            Data_out <= {Data_out[6:0], Data_out[7]};         end
    end
endmodule