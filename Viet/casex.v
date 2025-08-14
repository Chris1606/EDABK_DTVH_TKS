module casex_exam (
    input wire      [1:0] code,
    output reg      [7:0] control
);

    always @(code) begin
        casex (code)
            2'b0x: begin 
                control = 1;
            end
            2'b10: begin 
                control = 2;
            end
            2'b11: begin 
                control = 3;
            end
            default: begin 
                control = 0;
            end
        endcase
    end
endmodule
