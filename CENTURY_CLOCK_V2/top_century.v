module top_century(
    input wire        clk, 
    input wire        rst_n, 


    //if bit = 0, then the module is in clock mode
    //if bit = 1, then the module is in manual mode
    //input wire [5:0]  object_mode, // bit 0: seconds_mode, bit 1: minutes_mode, bit 2: hours_mode
    
    input wire        select_button,

    //if this is on the whole system will stop, and you can chang one at a time only 
    input wire        manual_mode, 

    //display mode, 0: SS:MM:HH, 1: DD:MM:YY
    input wire        display_mode,

    input wire        down, 
    input wire        up , 


    //Display on seven segment led, 
    output wire [6 : 0] led_hex_0, 
    output wire [6 : 0] led_hex_1,

    output wire [6 : 0] led_hex_2,
    output wire [6 : 0] led_hex_3,

    output wire [6 : 0] led_hex_4, 
    output wire [6 : 0] led_hex_5,

    output wire [6 : 0] led_hex_6,
    output wire [6 : 0] led_hex_7
    );


    wire [3 : 0] seconds_tens;
    wire [3 : 0] seconds_units;

    wire [3 : 0] minutes_tens;
    wire [3 : 0] minutes_units;

    wire [3 : 0] hours_tens;
    wire [3 : 0] hours_units;

    wire [3 : 0] day_tens; 
    wire [3 : 0] day_units; 

    wire [3 : 0] month_tens;
    wire [3 : 0] month_units;  
    
    wire [3 : 0] year_thousands;
    wire [3 : 0] year_hundreds; 
    wire [3 : 0] year_tens;
    wire [3 : 0] year_units;
        



    wire [3 : 0] max_days_tens;
    wire [3 : 0] max_days_units;

    //Display on seven segment led, 
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
    

    wire tick_mins; // second to minute tick
    wire tick_hours; //minute to hour tick
    wire tick_days; //hour to day tick
    wire tick_months; //day to month tick
    wire tick_years; // month to year tick

    wire finished; //finish the year

    wire [5 : 0]        object_mode, 
    

    //  only use 1HZ for implementation on FPGA 
    wire clk_1Hz;
    
    //Clock divider to implement 1Hz clock
    pulse_1s u_pulse_1s (
        .clk(clk),
        .rst_n(rst_n),
        .enable_pulse_1s(1'b1), // always enable
        .clk_1Hz(clk_1Hz)
    );


    wire blink_state; 
    controller u_controller (
        .clk(clk_1Hz), 
        .rst_n(rst_n), 
        .select_button(select_button), 
        .object_mode(object_mode), 
        .blink_state(blink_state)
    ); 

    display u_display(
        .object_mode(object_mode),
        .blink_state(blink_state),

        .display_mode(display_mode),
        .seconds_tens(seconds_tens),
        .seconds_units(seconds_units),
        .minutes_tens(minutes_tens),
        .minutes_units(minutes_units),
        .hours_tens(hours_tens),
        .hours_units(hours_units),
        .day_tens(day_tens),
        .day_units(day_units),
        .month_tens(month_tens),
        .month_units(month_units),
        .year_thousands(year_thousands),
        .year_hundreds(year_hundreds),
        .year_tens(year_tens),
        .year_units(year_units),
  
        .led_hex_0(led_hex_0),
        .led_hex_1(led_hex_1),
        .led_hex_2(led_hex_2),
        .led_hex_3(led_hex_3),
        .led_hex_4(led_hex_4),
        .led_hex_5(led_hex_5),
        .led_hex_6(led_hex_6),
        .led_hex_7(led_hex_7)
    );
    //display mode 
    // display_mode u_display(
    //     .clk(clk_1Hz), 
    //     .rst_n(rst_n), 
        
    //     .display_mode(display_mode), 
    //     .select_button(select_button), 

    //     .seconds_tens(seconds_tens), 
    //     .seconds_units(seconds_units),
  
    //     .minutes_tens(minutes_tens),
    //     .minutes_units(minutes_units),

    //     .hours_tens(hours_tens),
    //     .hours_units(hours_units),

    //     .day_tens(day_tens),
    //     .day_units(day_units),

    //     .month_tens(month_tens),
    //     .month_units(month_units),

    //     .year_thousands(year_thousands),
    //     .year_hundreds(year_hundreds),
    //     .year_tens(year_tens),
    //     .year_units(year_units),

    //     .led_hex_0(led_hex_0),
    //     .led_hex_1(led_hex_1),
    //     .led_hex_2(led_hex_2),
    //     .led_hex_3(led_hex_3),
    //     .led_hex_4(led_hex_4),
    //     .led_hex_5(led_hex_5),
    //     .led_hex_6(led_hex_6),
    //     .led_hex_7(led_hex_7),

    //     .object_mode(object_mode)
    // );

    // bitwise because FPGA recive press as 0; 
    wire up_fpga = ~up; 
    wire down_fpga = ~down; 


    //Seconds mode 
    clock_60s u_clock_60s (
        .clk(clk_1Hz),
        .rst_n(rst_n),
        
        .second_mode(object_mode[0]),

        .manual_mode(manual_mode), 

        .up(up_fpga ),
        .down(down_fpga),
         
        .seconds_tens(seconds_tens),
        .seconds_units(seconds_units),

        .tick_mins(tick_mins)
    );

    //Minutes mode
    clock_60m u_clock_60m(
        .clk(clk_1Hz),
        .rst_n(rst_n),
        
        .minute_mode(object_mode[1]),

        .manual_mode(manual_mode), 

        .up(up_fpga ),
        .down(down_fpga),

        .tick_mins(tick_mins),

        .minutes_tens(minutes_tens),
        .minutes_units(minutes_units),

        .tick_hours(tick_hours)        
    );

    //Hours mode
    clock_24h u_clock_24h(
        .clk(clk_1Hz),
        .rst_n(rst_n),
        
        .hour_mode(object_mode[2]),

        .manual_mode(manual_mode), 

        .up(up_fpga ),
        .down(down_fpga),

        .tick_hours(tick_hours),

        .hours_tens(hours_tens), 
        .hours_units(hours_units), 

        .tick_days(tick_days)        
    );
    
    //check the max day in month 
    day_in_month u_day_in_month(
        .month_tens(month_tens), 
        .month_units(month_units), 
        
        .year_thousands(year_thousands), 
        .year_hundreds(year_hundreds), 
        .year_tens(year_tens),
        .year_units(year_units), 

        .rst_n(rst_n), 

        .max_days_tens(max_days_tens), 
        .max_days_units(max_days_units)
    );

    //DAy mode
    clock_day u_clock_day (
        .clk(clk_1Hz),
        .rst_n(rst_n),

        .day_mode(object_mode[3]),   // Assuming bit 3 of object_mode is for day control
        .manual_mode(manual_mode),

        .up(up_fpga ),
        .down(down_fpga),

        .tick_days(tick_days),

        .max_days_tens(max_days_tens),
        .max_days_units(max_days_units),

        .day_tens(day_tens),
        .day_units(day_units),

        .tick_months(tick_months)
    );

    clock_month u_clock_month(
        
        .clk(clk_1Hz),
        .rst_n(rst_n),

        .month_mode(object_mode[4]),   // Assuming bit 3 of object_mode is for day control
        .manual_mode(manual_mode),
        
        .up(up_fpga ),
        .down(down_fpga),

        .tick_months(tick_months), 

        .month_tens(month_tens), 
        .month_units(month_units),

        .tick_years(tick_years)


    );

    clock_year u_clock_year(
        
        .clk(clk_1Hz),
        .rst_n(rst_n),

        .year_mode(object_mode[5]),   // Assuming bit 3 of object_mode is for day control
        .manual_mode(manual_mode),
        
        .up(up_fpga ),
        .down(down_fpga),

        .tick_years(tick_years),

        .year_thousands(year_thousands), 
        .year_hundreds(year_hundreds), 
        .year_tens(year_tens),
        .year_units(year_units),

        .finished(finished)
    );


    

endmodule
