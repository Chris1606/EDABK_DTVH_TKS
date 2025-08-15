module pulse_1s (
    input wire clk,
    input wire rst_n,
    input wire enable_pulse_1s,
    output reg pulse_1s
);
    localparam divider = 50_000_000;  // 50 MHz clock → 1 Hz pulse
    reg [$clog2(divider) : 0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin      
            counter <= 0;
            pulse_1s <= 0;
        end else if (enable_pulse_1s) begin 
            if (counter == divider - 1) begin
                pulse_1s <= 1'b1;   
                counter <= 0;
            end else begin
                pulse_1s <= 1'b0;
                counter <= counter + 1;
            end
        end else begin
            pulse_1s <= 1'b0;
        end
    end
endmodule
