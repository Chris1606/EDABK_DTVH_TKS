module display(
    input wire          clk, 
    input wire          rst_n, 

   
    input wire              display_mode, 

    input wire              select_button, 


    input wire [3 : 0]       seconds_tens,
    input wire [3 : 0]       seconds_units,

    input wire [3 : 0]       minutes_tens,
    input wire [3 : 0]       minutes_units,

    input wire [3 : 0]       hours_tens,
    input wire [3 : 0]       hours_units,

    input wire [3 : 0]      day_tens,
    input wire [3 : 0]      day_units, 

    input wire [3 : 0]      month_tens,
    input wire [3 : 0]      month_units,  
    
    input wire [3 : 0]      year_thousands,
    input wire [3 : 0]      year_hundreds,
    input wire [3 : 0]      year_tens,
    input wire [3 : 0]      year_units,

    
    
    output reg [6 : 0]      led_hex_0, 
    output reg [6 : 0]      led_hex_1,

    output reg [6 : 0]      led_hex_2,
    output reg [6 : 0]      led_hex_3,

    output reg [6 : 0]      led_hex_4, 
    output reg [6 : 0]      led_hex_5,

    output reg [6 : 0]      led_hex_6,
    output reg [6 : 0]      led_hex_7

    output reg [5 : 0]     object_mode
);

    wire [6 : 0] seconds_tens_seg;
    wire [6 : 0] seconds_units_seg;

    wire [6 : 0] minutes_tens_seg;
    wire [6 : 0] minutes_units_seg;

    wire [6 : 0] hours_tens_seg;
    wire [6 : 0] hours_units_seg;

    wire [6 : 0] day_tens_seg;
    wire [6 : 0] day_units_seg;

    wire [6 : 0] month_tens_seg;
    wire [6 : 0] month_units_seg;  

    wire [6 : 0] year_thousands_seg;
    wire [6 : 0] year_hundreds_seg; 
    wire [6 : 0] year_tens_seg; 
    wire [6 : 0] year_units_seg;    

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
    led_segment u12(.digits(year_hundreds),  .digits_seg(year_hundreds_seg));
    led_segment u13(.digits(year_tens),      .digits_seg(year_tens_seg));
    led_segment u14(.digits(year_units),     .digits_seg(year_units_seg));


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
        end
        else begin
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

    reg counter [2 : 0]; 

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

    localparam SECOND   = 3'b001; 
    localparam MINUTES  = 3'b010; 
    localparam HOURS    = 3'b011; 
    localparam DAYS     = 3'b100; 
    localparam MONTHS   = 3'b101; 
    localparam YEARS    = 3'b110;  

    always @(*) begin 
        object_mode = 6'd0; 
        case (counter)
            SECOND: 
                object_mode = 6'b000_001
            MINUTES:
                object_mode = 6'b000_010; 
            HOURS:
                object_mode = 6'b000_100; 
            DAYS:
                object_mode = 6'b001_000;
            MONTH: 
                object_mode = 6'b010_000; 
            YEARS:  
                object_mode = 6'b100_000; 
        endcase
    end 

    localparam divider = 50_000_000;  // 50 MHz clock → 1 Hz pulse
    reg [$clog2(divider) - 1  : 0]  blink_counter;
    reg                        blink_state; 
//  blink led for this one 
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            blink_counter <= 0; 
            blink_state   <= 1'b1; 
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