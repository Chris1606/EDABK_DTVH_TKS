module led_segment(
    input  wire [3 : 0] digits,       // BCD input 0–9
    output reg  [6 : 0] digits_seg    // {a,b,c,d,e,f,g}
);

    // Common cathode: 0 = ON, 1 = OFF
    always @(digits) begin
        case (digits)
            4'd0: digits_seg = 7'b0000001;
            4'd1: digits_seg = 7'b1001111;
            4'd2: digits_seg = 7'b0010010;
            4'd3: digits_seg = 7'b0000110;
            4'd4: digits_seg = 7'b1001100;
            4'd5: digits_seg = 7'b0100100;
            4'd6: digits_seg = 7'b0100000;
            4'd7: digits_seg = 7'b0001111;
            4'd8: digits_seg = 7'b0000000;
            4'd9: digits_seg = 7'b0000100;
            default: digits_seg = 7'b1111111;  // blank display
        endcase
    end

endmodule
