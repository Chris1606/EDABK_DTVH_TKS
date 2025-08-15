// parameter
// localparam
//addrer
// module thamSoHoa (a, b, cin, sum, cout);

// parameter WIDTH = 8;

// input[WIDTH-1:0] a, b;
// input cin;
// output[WIDTH-1:0] sum;
// output cout;

// assign {cout, sum} = a + b + cin;
// endmodule




// module thamSoHoa #(parameter SIZE = 8) (
//     input [SIZE-1:0] d,
//     input clk, rst_n,
//     output reg [SIZE-1:0] q
// );
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             q <= 0;
//         end else begin
//             q <= d; 
//         end
//     end
// endmodule

