module addtree(
    input wire [7 : 0] in1, in2, in3, in4,
    output reg [9 : 0] out
);
    reg [8 : 0] part1, part2; 
    
    always @(in1, in2, in3, in4) begin 
        part1 = in1 + in2; 
        part2 = in3 + in4; 
        out   = part1 + part2; 
    end

endmodule