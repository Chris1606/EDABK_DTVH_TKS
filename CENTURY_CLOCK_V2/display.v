module display(
    input  wire         clk,         // 50 MHz clock
    input  wire         rst_n, 
    input  wire         manual_mode,
    input  wire         display_mode,
    input  wire         select_button, 

    input  wire [3:0]   seconds_tens,
    input  wire [3:0]   seconds_units,
    input  wire [3:0]   minutes_tens,
    input  wire [3:0]   minutes_units,
    input  wire [3:0]   hours_tens,
    input  wire [3:0]   hours_units,
    input  wire [3:0]   day_tens,
    input  wire [3:0]   day_units,
    input  wire [3:0]   month_tens,
    input  wire [3:0]   month_units,
    input  wire [3:0]   year_thousands,
    input  wire [3:0]   year_hundreds,
    input  wire [3:0]   year_tens,
    input  wire [3:0]   year_units,

    output reg  [6:0]   led_hex_0,
    output reg  [6:0]   led_hex_1,
    output reg  [6:0]   led_hex_2,
    output reg  [6:0]   led_hex_3,
    output reg  [6:0]   led_hex_4,
    output reg  [6:0]   led_hex_5,
    output reg  [6:0]   led_hex_6,
    output reg  [6:0]   led_hex_7,
    // Object mode for adjusting values
    // 0: seconds, 1: minutes, 2: hours, 3: days, 4: months, 5: years
    output reg  [5:0]   object_mode
);

    // ------------------------------
    // LED segment decode
    // ------------------------------
    wire [6:0] seconds_tens_seg, seconds_units_seg;
    wire [6:0] minutes_tens_seg, minutes_units_seg;
    wire [6:0] hours_tens_seg,   hours_units_seg;
    wire [6:0] day_tens_seg,     day_units_seg;
    wire [6:0] month_tens_seg,   month_units_seg;
    wire [6:0] year_thousands_seg, year_hundreds_seg, year_tens_seg, year_units_seg;

    led_segment u1 (.digits(seconds_tens), .digits_seg(seconds_tens_seg));
    led_segment u2 (.digits(seconds_units), .digits_seg(seconds_units_seg));
    led_segment u3 (.digits(minutes_tens), .digits_seg(minutes_tens_seg));
    led_segment u4 (.digits(minutes_units), .digits_seg(minutes_units_seg));
    led_segment u5 (.digits(hours_tens),   .digits_seg(hours_tens_seg));
    led_segment u6 (.digits(hours_units),  .digits_seg(hours_units_seg));
    led_segment u7 (.digits(day_tens),     .digits_seg(day_tens_seg));
    led_segment u8 (.digits(day_units),    .digits_seg(day_units_seg));
    led_segment u9 (.digits(month_tens),   .digits_seg(month_tens_seg));
    led_segment u10(.digits(month_units),  .digits_seg(month_units_seg));
    led_segment u11(.digits(year_thousands), .digits_seg(year_thousands_seg));
    led_segment u12(.digits(year_hundreds),  .digits_seg(year_hundreds_seg));
    led_segment u13(.digits(year_tens),      .digits_seg(year_tens_seg));
    led_segment u14(.digits(year_units),     .digits_seg(year_units_seg));

    // ------------------------------
    // Blink generator (1 Hz)
    // ------------------------------
    localparam BLINK_DIV = 12_500_000; // 50 MHz -> toggle every 0.5s
    reg [$clog2(BLINK_DIV)-1:0] blink_counter;
    reg blink_state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            blink_counter <= 0;
            blink_state   <= 1'b1;
        end else begin
            if (blink_counter == BLINK_DIV - 1) begin
                blink_counter <= 0;
                blink_state   <= ~blink_state;
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
    end

    // ------------------------------
    // Debounce + edge detect for select_button
    // ------------------------------
    reg btn_sync0, btn_sync1;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            btn_sync0 <= 0;
            btn_sync1 <= 0;
        end else begin
            btn_sync0 <= select_button;
            btn_sync1 <= btn_sync0;
        end
    end

    // Debounce (20ms)
    reg [19:0] debounce_cnt;
    reg btn_stable;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            debounce_cnt <= 0;
            btn_stable   <= 0;
        end else if (btn_sync1 != btn_stable) begin
            debounce_cnt <= debounce_cnt + 1;
            if (debounce_cnt == 1_000_000) begin // ~20 ms @ 50 MHz
                btn_stable   <= btn_sync1;
                debounce_cnt <= 0;
            end
        end else begin
            debounce_cnt <= 0;
        end
    end

    // Edge detect
    reg btn_prev;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) btn_prev <= 0;
        else        btn_prev <= btn_stable;
    end
    wire select_pulse = btn_stable & ~btn_prev;

    // ------------------------------
    // Mode counter
    // ------------------------------
    reg [2:0] counter;
    localparam SECOND  = 3'b001, 
               MINUTES = 3'b010, 
               HOURS   = 3'b011, 
               DAYS    = 3'b100, 
               MONTHS  = 3'b101, 
               YEARS   = 3'b110;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 3'b000;
        end else if (!manual_mode) begin
            counter <= 3'b000;
        end else begin
            if (counter == 3'b000) begin
                counter <= SECOND;
            end else if (select_pulse) begin
                if (counter == YEARS)
                    counter <= SECOND;
                else
                    counter <= counter + 1;
            end
        end
    end

    // ------------------------------
    // object_mode decode
    // ------------------------------
    always @(*) begin
        case (counter)
            SECOND:  object_mode = 6'b000_001;
            MINUTES: object_mode = 6'b000_010;
            HOURS:   object_mode = 6'b000_100;
            DAYS:    object_mode = 6'b001_000;
            MONTHS:  object_mode = 6'b010_000;
            YEARS:   object_mode = 6'b100_000;
            default: object_mode = 6'b000_000;
        endcase
    end

    // ------------------------------
    // LED output mapping
    // ------------------------------
    always @(*) begin
        if (display_mode) begin
            led_hex_0 = (object_mode == 6'b000_001 && ~blink_state) ? 7'b111_1111 : seconds_units_seg;
            led_hex_1 = (object_mode == 6'b000_001 && ~blink_state) ? 7'b111_1111 : seconds_tens_seg;
            led_hex_2 = (object_mode == 6'b000_010 && ~blink_state) ? 7'b111_1111 : minutes_units_seg;
            led_hex_3 = (object_mode == 6'b000_010 && ~blink_state) ? 7'b111_1111 : minutes_tens_seg;
            led_hex_4 = (object_mode == 6'b000_100 && ~blink_state) ? 7'b111_1111 : hours_units_seg;
            led_hex_5 = (object_mode == 6'b000_100 && ~blink_state) ? 7'b111_1111 : hours_tens_seg;
            led_hex_6 = 7'b111_1111;
            led_hex_7 = 7'b111_1111;
        end else begin
            led_hex_0 = (object_mode == 6'b100_000 && ~blink_state) ? 7'b111_1111 : year_units_seg;
            led_hex_1 = (object_mode == 6'b100_000 && ~blink_state) ? 7'b111_1111 : year_tens_seg;
            led_hex_2 = (object_mode == 6'b100_000 && ~blink_state) ? 7'b111_1111 : year_hundreds_seg;
            led_hex_3 = (object_mode == 6'b100_000 && ~blink_state) ? 7'b111_1111 : year_thousands_seg;
            led_hex_4 = (object_mode == 6'b010_000 && ~blink_state) ? 7'b111_1111 : month_units_seg;
            led_hex_5 = (object_mode == 6'b010_000 && ~blink_state) ? 7'b111_1111 : month_tens_seg;
            led_hex_6 = (object_mode == 6'b001_000 && ~blink_state) ? 7'b111_1111 : day_units_seg;
            led_hex_7 = (object_mode == 6'b001_000 && ~blink_state) ? 7'b111_1111 : day_tens_seg;
        end
    end

endmodule
