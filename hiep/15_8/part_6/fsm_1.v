module fsm_1 (
    input clk, rst, a, b,
    output reg Y, Z
);
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10;
    reg [1:0] state, nxt_state;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0; 
        end else begin
            state <= nxt_state; 
        end
    end
    always @(state or a or b) begin
        nxt_state = state;
        Y = 0;
        Z = 0;
        case (state)
            S0: begin
                if (a) begin
                    nxt_state = S1;
                    Z = 1; 
                end else begin
                    nxt_state = S0;
                end
            end
            S1: begin
                Y = 1; 
                if (b) begin
                    nxt_state = S2;
                    Z = 1; 
                end else begin
                    nxt_state = S1; 
                end
            end
            S2: begin
                nxt_state = S0;
            end
        endcase
    end

endmodule