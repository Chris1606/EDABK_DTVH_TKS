module full_adder ( 
    input wire      a, 
                    b, 
                    c_in, 
    output wire     sum, 
                    c_out
);

    assign sum = a ^ b ^ c_in;
    assign c_out = (a & b) | (b & c_in) | (a & c_in)

endmodule

module adder #(parameter DATA_WIDTH = 8)(
    input wire [DATA_WIDTH - 1 : 0] a, 
                                    b,  
    input wire                      c_in,

    output wire [DATA_WIDTH - 1 : 0] sum,
    output wire                      c_out 
); 

    wire [DATA_WIDTH - 1 : 0]wire_c_out; 

    full_adder fa [DATA_WIDTH - 1 : 0](
        .a(a), 
        .b(b), 
        .c_in({wire_c_out[DATA_WIDTH - 2 : 0], c_in}), 
        .c_out(wire_c_out), 
        .sum(sum)
    );
    assign c_out <= wire_c_out; 
endmodule

module test(
    input wire clk, rst_n, 
    input wire a, b, c,  
    output reg d 
);
    always @(posedge clk) begin
        if(~rst_n)
            d <= 0; 
        else 
            d <= (a * b) + (a * c); 
    end
endmodule

//thực hiện nhân song song và nhân booth 
//viết code sử dụng các phép toán /, %, +, -, *; 