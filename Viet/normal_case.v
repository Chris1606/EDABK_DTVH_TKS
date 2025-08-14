module alu(
    input wire      [1:0]alu_op,
    input wire      [31:0]src1,
    input wire      [31:0]src2,
    output reg      [31:0]res
);

parameter AND =     2'b00 ;
parameter OR  =     2'b01 ;
parameter XOR =     2'b10 ;
parameter ADD =     2'b11 ;

always @(alu_op,src1,src2) begin
    case(alu_op) 
        AND: begin 
            res = src1 & src2;
        end
        OR: begin 
            res = src1 | src2;
        end
        XOR: begin 
            res = src1 ^ src2;
        end
        default: begin 
            res = src1 + src2;
        end
    endcase
end

endmodule