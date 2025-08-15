// nested if else statement
module decoder2To4 (
    input [1:0] in,
    output reg [3:0] out
);

always @(*) begin
    out = 4'b0000; 

    if (in[1] == 1'b0) begin
        if (in[0] == 1'b0) begin
            out[0] = 1'b1;
        end else begin
            out[1] = 1'b1;
        end
    end else begin
        if (in[0] == 1'b0) begin
            out[2] = 1'b1;
        end else begin
            out[3] = 1'b1;
        end
    end
end

endmodule