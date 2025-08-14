module traffic_light (
    input wire      [1:0]op,
    output reg      [2:0]light    
); 

always @(op) begin 
    case(op) 
        2'b00: begin 
            light = 3'b001; //GREEN
        end
        2'b01: begin 
            light = 3'b010; //YELLOW
        end
        2'b1z: begin 
            light = 3'b100; //RED
        end
        default: begin 
            light = 3'b000; //OFF
        end
    endcase
end

endmodule

//casez: trong case co nhung truong hop 01,00 -> 0z (z la don't care)