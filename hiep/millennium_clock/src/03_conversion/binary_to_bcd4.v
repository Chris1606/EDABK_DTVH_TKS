/*
* chuyển đổi b về bcd 4 số
*/
module binary_to_bcd4 (
    input [13:0] binary_in,
    output [3:0] thousands,
    output [3:0] hundreds,
    output [3:0] tens,
    output [3:0] units
);
    assign thousands = binary_in / 1000;
    assign hundreds  = (binary_in % 1000) / 100;
    assign tens      = (binary_in % 100) / 10;
    assign units     = binary_in % 10;
endmodule