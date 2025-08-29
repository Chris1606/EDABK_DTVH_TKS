module branch_comparator(
    input  wire        BrUn,   // 0 = signed, 1 = unsigned
    input  wire [31:0] DataA,
    input  wire [31:0] DataB,
    output reg         BrEq,
    output reg         BrLt
);

    always @* begin
        if (BrUn == 0) begin
            // unsigned compare
            BrEq = ($unsigned(DataA) == $unsigned(DataB));
            BrLt = ($unsigned(DataA) < $unsigned(DataB));
        end else begin
            // signed compare
            BrEq = ($signed(DataA) == $signed(DataB));
            BrLt = ($signed(DataA) <  $signed(DataB));
        end
    end

endmodule
