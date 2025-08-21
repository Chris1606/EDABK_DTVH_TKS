module controller(
    input wire clk,
    input wire rst_n,
    input wire select_button,
    // input wire display_mode,
    output reg [5:0] object_mode,
    output reg blink_state
);

    reg [2:0] counter;
    localparam divider = 50_000_000;  // 50 MHz clock → 1 Hz pulse
    reg [$clog2(divider)-1:0] blink_counter;

    localparam SECOND = 3'b001;
    localparam MINUTES = 3'b010;
    localparam HOURS = 3'b011;
    localparam DAYS = 3'b100;
    localparam MONTHS = 3'b101;
    localparam YEARS = 3'b110;

    // Counter for mode selection
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 0;
        end
        else begin
            if (select_button) begin
                counter <= counter + 1'b1;
            end
            else begin
                counter <= counter;
            end
        end
    end

    // Object mode assignment
    always @(counter) begin
        object_mode = 6'd0;
        case (counter)
            SECOND:  object_mode = 6'b000001;
            MINUTES: object_mode = 6'b000010;
            HOURS:   object_mode = 6'b000100;
            DAYS:    object_mode = 6'b001000;
            MONTHS:  object_mode = 6'b010000;
            YEARS:   object_mode = 6'b100000;
            default: object_mode = 6'd0;
        endcase
    end

    // Blink state generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            blink_counter <= 0;
            blink_state <= 1'b1;
        end
        else begin
            blink_counter <= blink_counter + 1;
            if (blink_counter == divider - 1) begin
                blink_counter <= 0;
                blink_state <= ~blink_state;
            end
        end
    end

endmodule