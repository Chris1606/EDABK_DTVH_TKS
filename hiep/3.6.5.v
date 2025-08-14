// mo ta ff voi reset khong dong bo
module ff(
    input clk, reset_n, d,
    output reg q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            q <= 1'b0;
        else
            q <= d;
    end 
endmodule