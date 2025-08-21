module display(
    input wire [3:0]        seconds_tens,
    input wire [3:0]        seconds_units,
    input wire [3:0]        minutes_tens,
    input wire [3:0]        minutes_units,
    input wire [3:0]        hours_tens,
    input wire [3:0]        hours_units,
    input wire [3:0]        day_tens,
    input wire [3:0]        day_units,
    input wire [3:0]        month_tens,
    input wire [3:0]        month_units,
    input wire [3:0]        year_thousands,
    input wire [3:0]        year_hundreds,
    input wire [3:0]        year_tens,
    input wire [3:0]        year_units,

    input wire              display_mode,
    input wire [5:0]        object_mode,
    
    input wire              blink_state,

    output reg [6:0]        led_hex_0,
    output reg [6:0]        led_hex_1,
    output reg [6:0]        led_hex_2,
    output reg [6:0]        led_hex_3,
    output reg [6:0]        led_hex_4,
    output reg [6:0]        led_hex_5,
    output reg [6:0]        led_hex_6,
    output reg [6:0]        led_hex_7
);

    wire [6:0] seconds_tens_seg;
    wire [6:0] seconds_units_seg;
    wire [6:0] minutes_tens_seg;
    wire [6:0] minutes_units_seg;
    wire [6:0] hours_tens_seg;
    wire [6:0] hours_units_seg;
    wire [6:0] day_tens_seg;
    wire [6:0] day_units_seg;
    wire [6:0] month_tens_seg;
    wire [6:0] month_units_seg;
    wire [6:0] year_thousands_seg;
    wire [6:0] year_hundreds_seg;
    wire [6:0] year_tens_seg;
    wire [6:0] year_units_seg;

    // Seconds LEDs
    led_segment u1(.digits(seconds_tens), .digits_seg(seconds_tens_seg));
    led_segment u2(.digits(seconds_units), .digits_seg(seconds_units_seg));

    // Minutes LEDs
    led_segment u3(.digits(minutes_tens), .digits_seg(minutes_tens_seg));
    led_segment u4(.digits(minutes_units), .digits_seg(minutes_units_seg));

    // Hours LEDs
    led_segment u5(.digits(hours_tens), .digits_seg(hours_tens_seg));
    led_segment u6(.digits(hours_units), .digits_seg(hours_units_seg));

    // Day LEDs
    led_segment u7(.digits(day_tens), .digits_seg(day_tens_seg));
    led_segment u8(.digits(day_units), .digits_seg(day_units_seg));

    // Month LEDs
    led_segment u9(.digits(month_tens), .digits_seg(month_tens_seg));
    led_segment u10(.digits(month_units), .digits_seg(month_units_seg));

    // Year LEDs
    led_segment u11(.digits(year_thousands), .digits_seg(year_thousands_seg));
    led_segment u12(.digits(year_hundreds), .digits_seg(year_hundreds_seg));
    led_segment u13(.digits(year_tens), .digits_seg(year_tens_seg));
    led_segment u14(.digits(year_units), .digits_seg(year_units_seg));

    always @(*) begin
        if (display_mode) begin
            led_hex_0 = (object_mode == 6'b000001 && ~blink_state) ? 7'b1111111 : seconds_units_seg;
            led_hex_1 = (object_mode == 6'b000001 && ~blink_state) ? 7'b1111111 : seconds_tens_seg;
            led_hex_2 = (object_mode == 6'b000010 && ~blink_state) ? 7'b1111111 : minutes_units_seg;
            led_hex_3 = (object_mode == 6'b000010 && ~blink_state) ? 7'b1111111 : minutes_tens_seg;
            led_hex_4 = (object_mode == 6'b000100 && ~blink_state) ? 7'b1111111 : hours_units_seg;
            led_hex_5 = (object_mode == 6'b000100 && ~blink_state) ? 7'b1111111 : hours_tens_seg;
            led_hex_6 = 7'b1111111;
            led_hex_7 = 7'b1111111;
        end
        else begin
            led_hex_0 = (object_mode == 6'b100000 && ~blink_state) ? 7'b1111111 : year_units_seg;
            led_hex_1 = (object_mode == 6'b100000 && ~blink_state) ? 7'b1111111 : year_tens_seg;
            led_hex_2 = (object_mode == 6'b100000 && ~blink_state) ? 7'b1111111 : year_hundreds_seg;
            led_hex_3 = (object_mode == 6'b100000 && ~blink_state) ? 7'b1111111 : year_thousands_seg;
            led_hex_4 = (object_mode == 6'b010000 && ~blink_state) ? 7'b1111111 : month_units_seg;
            led_hex_5 = (object_mode == 6'b010000 && ~blink_state) ? 7'b1111111 : month_tens_seg;
            led_hex_6 = (object_mode == 6'b001000 && ~blink_state) ? 7'b1111111 : day_units_seg;
            led_hex_7 = (object_mode == 6'b001000 && ~blink_state) ? 7'b1111111 : day_tens_seg;
        end
    end

endmodule