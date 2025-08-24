/*
* bcd to 7seg converter
 */
module bcd_to_7seg (
    input [3:0]  bcd_in,
    output reg [7:0] seg_out // {dot, g, f, e, d, c, b, a}
);
    always @(bcd_in) begin
        case (bcd_in)
            4'h0:    seg_out = 8'b1_1000000;
            4'h1:    seg_out = 8'b1_1111001;
            4'h2:    seg_out = 8'b1_0100100;
            4'h3:    seg_out = 8'b1_0110000;
            4'h4:    seg_out = 8'b1_0011001;
            4'h5:    seg_out = 8'b1_0010010;
            4'h6:    seg_out = 8'b1_0000010;
            4'h7:    seg_out = 8'b1_1111000;
            4'h8:    seg_out = 8'b1_0000000;
            4'h9:    seg_out = 8'b1_0010000;
            default: seg_out = 8'b1_1111111; // tắt
        endcase
    end
endmodule