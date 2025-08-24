/*
* chuyển đổi b về bcd 2 số
*/
module binary_to_bcd2 (
    input [6:0]  binary_in,
    output [3:0] tens,
    output [3:0] units
);
    assign tens  = binary_in / 10;
    assign units = binary_in % 10;
endmodule