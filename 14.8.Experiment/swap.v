// module swap (
//     input wire      clk,
//     input wire      rst_n, 
//     output reg       out0, 
//     output reg      out1
// );
//     always @(posedge clk or negedge rst_n) begin 
//         if (~rst_n) begin 
//             out0 <= 1'b0; 
//             out1 <= 1'b1; 
//         end 
//         else begin 
//             out0 <= out1; 
//             out1 <= out0;
//         end 
//     end  
// endmodule

module swap(
    input wire [15 : 0] int0, int1, 
    input wire          swap, 
    output reg [15 : 0] out0, out1
);
    reg [15 : 0] temp; 
    always @(*) begin 
        out0 = int0; 
        out1 = int1; 
        if (swap) begin 
            temp = out0;
            out0 = out1; 
            out1 = temp; 
        end
    end 
endmodule