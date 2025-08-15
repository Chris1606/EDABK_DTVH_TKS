module priorityEncoder4To2 (
    input [3:0] in,
    output reg [1:0] out
);
    always @(in) begin
        if (in[3]) begin
            out = 2'b11; 
        end else if (in[2]) begin
            out = 2'b10; 
        end else if (in[1]) begin
            out = 2'b01; 
        end else if (in[0]) begin
            out = 2'b00;
        end else begin
            out = 2'bxx; 
        end
    end
endmodule