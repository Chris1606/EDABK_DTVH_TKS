/*******************************************************************************
 * MODULE: top
 * CHỨC NĂNG: Module cấp cao nhất cho dự án Đồng hồ Thiên niên kỷ.
 * - Chứa Máy trạng thái (FSM) để quản lý các chế độ hoạt động.
 * - Kết nối và điều khiển tất cả các module con.
 * TÁC GIẢ: Hiệp (AI Assistant) & User
 * PHIÊN BẢN: 2.0 (Đã khắc phục các lỗi nghiêm trọng)
 ******************************************************************************/
module top (
    input           clk_50mhz,  // xung của fpga
    input           rst_n,
    input           mode_btn,   // manual mode 
    input           inc_btn,    // tăng
    input           dec_btn,    // giảm 
    output [7:0]    seg,
    output [7:0]    an
);

    //==========================================================================
    // KHAI BÁO WIRES & REGS
    //==========================================================================

    // --- Tín hiệu Clock ---
    wire clk_1khz;
    wire sec_en_tick; // Tick 1Hz an toàn, được tạo trong domain 1kHz

    // --- Tín hiệu Nút bấm ---
    wire btn_mode_db, btn_inc_db, btn_dec_db;
    wire mode_pulse, inc_pulse, dec_pulse;

    // --- Tín hiệu Thời gian (Dạng Nhị phân từ Counters) ---
    wire [5:0] sec_bin, min_bin;
    wire [4:0] hour_bin;
    wire [4:0] day_bin;
    wire [3:0] month_bin;
    wire [15:0] year_bin;
    
    // --- Tín hiệu Thời gian (Dạng BCD đã tách) ---
    wire [3:0] sec_t, sec_u, min_t, min_u, hour_t, hour_u;
    wire [3:0] day_t, day_u, month_t, month_u;
    wire [3:0] year_k, year_h, year_t, year_u;

    // --- Thanh ghi tạm cho chế độ SET ---
    reg [4:0] hour_set; 
    reg [5:0] min_set; 
    reg [4:0] day_set; 
    reg [3:0] month_set; 
    reg [15:0] year_set;
    
    // --- Tín hiệu điều khiển ---
    reg load_time_en, load_date_en;
    reg [31:0] display_data;
    reg is_8_led_mode;
    wire is_blinking_mode;

    //==========================================================================
    // LOGIC TẠO TICK 1HZ (FIX LỖI CDC)
    //==========================================================================
    reg [9:0] counter_1hz_in_1khz;
    always @(posedge clk_1khz or negedge rst_n) begin
        if (!rst_n) 
            counter_1hz_in_1khz <= 0;
        else if (counter_1hz_in_1khz == 999) // Đếm 1000 chu kỳ của clock 1kHz = 1 giây
            counter_1hz_in_1khz <= 0;
        else 
            counter_1hz_in_1khz <= counter_1hz_in_1khz + 1;
    end
    assign sec_en_tick = (counter_1hz_in_1khz == 999);

    //==========================================================================
    // FSM - MÁY TRẠNG THÁI ĐIỀU KHIỂN (2 NHIỆM VỤ CHÍNH)
    //==========================================================================
    
    // --- Định nghĩa trạng thái ---
    // NHIỆM VỤ 1: Chọn xem thời gian hoặc ngày tháng
    localparam S_VIEW_TIME = 4'h0, S_VIEW_DATE = 4'h1;
    // NHIỆM VỤ 2: Chế độ cài đặt
    localparam S_SET_HOUR = 4'h2, S_SET_MINUTE = 4'h3, S_SET_DAY = 4'h4, S_SET_MONTH = 4'h5, S_SET_YEAR = 4'h6;
    
    reg [3:0] state, next_state;
    reg [1:0] view_mode; // 0: xem thời gian, 1: xem ngày tháng
    reg is_setting_mode; // 0: chế độ xem, 1: chế độ cài đặt

    // Khối Sequential: Cập nhật trạng thái
    always @(posedge clk_1khz or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_VIEW_TIME;
            view_mode <= 2'b00;
            is_setting_mode <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Khối Combinational: Quyết định trạng thái tiếp theo và các tín hiệu điều khiển
    always @(*) begin
        // Giá trị mặc định
        next_state = state;
        load_time_en = 1'b0;
        load_date_en = 1'b0;
        
        // Logic chuyển trạng thái khi nhấn nút MODE
        if (mode_pulse) begin
            case (state)
                // === NHIỆM VỤ 1: Chế độ xem ===
                S_VIEW_TIME:  next_state = S_VIEW_DATE;  // Chuyển từ xem thời gian sang xem ngày tháng
                S_VIEW_DATE:  next_state = S_SET_HOUR;   // Chuyển từ xem ngày tháng sang chế độ cài đặt
                
                // === NHIỆM VỤ 2: Chế độ cài đặt ===
                S_SET_HOUR:   next_state = S_SET_MINUTE;
                S_SET_MINUTE: next_state = S_SET_DAY;
                S_SET_DAY:    next_state = S_SET_MONTH;
                S_SET_MONTH:  next_state = S_SET_YEAR;
                S_SET_YEAR:   next_state = S_VIEW_TIME;  // Quay về chế độ xem thời gian
                default:      next_state = S_VIEW_TIME;
            endcase
        end

        // Cập nhật view_mode và is_setting_mode
        case (next_state)
            S_VIEW_TIME, S_VIEW_DATE: begin
                view_mode = (next_state == S_VIEW_TIME) ? 2'b00 : 2'b01;
                is_setting_mode = 1'b0;
            end
            S_SET_HOUR, S_SET_MINUTE, S_SET_DAY, S_SET_MONTH, S_SET_YEAR: begin
                is_setting_mode = 1'b1;
            end
        endcase

        // Sao chép giá trị hiện tại vào thanh ghi SET khi bắt đầu vào chế độ cài đặt
        if (state != next_state && (next_state >= S_SET_HOUR && next_state <= S_SET_YEAR) ) begin
            hour_set  = hour_bin; 
            min_set   = min_bin; 
            day_set   = day_bin; 
            month_set = month_bin; 
            year_set  = year_bin;
        end
        
        // Bật tín hiệu LOAD khi thoát khỏi chế độ cài đặt
        if ((state >= S_SET_HOUR && state <= S_SET_MINUTE) && (next_state == S_VIEW_TIME || next_state == S_VIEW_DATE)) begin
            load_time_en = 1'b1;
        end
        if ((state >= S_SET_DAY && state <= S_SET_YEAR) && (next_state == S_VIEW_TIME || next_state == S_VIEW_DATE)) begin
            load_date_en = 1'b1;
        end

        // Logic tăng/giảm giá trị trong chế độ cài đặt
        case (state)
            S_SET_HOUR:   if(inc_pulse) hour_set = (hour_set == 23) ? 0 : hour_set + 1; else if(dec_pulse) hour_set = (hour_set == 0) ? 23 : hour_set - 1;
            S_SET_MINUTE: if(inc_pulse) min_set = (min_set == 59) ? 0 : min_set + 1; else if(dec_pulse) min_set = (min_set == 0) ? 59 : min_set - 1;
            S_SET_DAY:    if(inc_pulse) day_set = (day_set == 31) ? 1 : day_set + 1; else if(dec_pulse) day_set = (day_set == 1) ? 31 : day_set - 1;
            S_SET_MONTH:  if(inc_pulse) month_set = (month_set == 12) ? 1 : month_set + 1; else if(dec_pulse) month_set = (month_set == 1) ? 12 : month_set - 1;
            S_SET_YEAR:   if(inc_pulse) year_set = year_set + 1; else if(dec_pulse && year_set > 0) year_set = year_set - 1;
        endcase
    end

    //==========================================================================
    // LOGIC HIỂN THỊ (2 NHIỆM VỤ CHÍNH)
    //==========================================================================
    assign is_blinking_mode = is_setting_mode; // Nhấp nháy khi ở chế độ cài đặt
    
    always @(*) begin
        // Giá trị mặc định
        is_8_led_mode = 1'b0;
        display_data = 32'hFFFFFFFF; 

        case(state)
            // === NHIỆM VỤ 1: CHẾ ĐỘ XEM ===
            S_VIEW_TIME: begin
                is_8_led_mode = 1'b0; // 6 LED cho thời gian
                display_data[23:20] = hour_t;  display_data[19:16] = hour_u;
                display_data[15:12] = min_t;   display_data[11:8]  = min_u;
                display_data[7:4]   = sec_t;   display_data[3:0]   = sec_u;
            end
            S_VIEW_DATE: begin
                is_8_led_mode = 1'b1; // 8 LED cho ngày tháng
                // Hiển thị DD-MM-YY
                display_data[23:20] = year_t;  display_data[19:16] = year_u;
                display_data[15:12] = month_t; display_data[11:8]  = month_u;
                display_data[7:4]   = day_t;   display_data[3:0]   = day_u;
            end
            
            // === NHIỆM VỤ 2: CHẾ ĐỘ CÀI ĐẶT ===
            S_SET_HOUR: begin
                is_8_led_mode = 1'b0; // 6 LED
                display_data[23:20] = hour_set / 10; display_data[19:16] = hour_set % 10;
                display_data[15:12] = min_t;         display_data[11:8]  = min_u;
                display_data[7:4]   = sec_t;         display_data[3:0]   = sec_u;
            end
            S_SET_MINUTE: begin
                is_8_led_mode = 1'b0; // 6 LED
                display_data[23:20] = hour_t;        display_data[19:16] = hour_u;
                display_data[15:12] = min_set / 10;  display_data[11:8]  = min_set % 10;
                display_data[7:4]   = sec_t;         display_data[3:0]   = sec_u;
            end
            S_SET_DAY: begin
                is_8_led_mode = 1'b1; // 8 LED
                display_data[23:20] = year_t;        display_data[19:16] = year_u;
                display_data[15:12] = month_t;       display_data[11:8]  = month_u;
                display_data[7:4]   = day_set / 10;  display_data[3:0]   = day_set % 10;
            end
            S_SET_MONTH: begin
                is_8_led_mode = 1'b1; // 8 LED
                display_data[23:20] = year_t;        display_data[19:16] = year_u;
                display_data[15:12] = month_set / 10; display_data[11:8] = month_set % 10;
                display_data[7:4]   = day_t;         display_data[3:0]   = day_u;
            end
            S_SET_YEAR: begin
                is_8_led_mode = 1'b1; // 8 LED
                display_data[23:20] = year_set / 1000; display_data[19:16] = (year_set % 1000) / 100;
                display_data[15:12] = (year_set % 100) / 10; display_data[11:8] = year_set % 10;
                display_data[7:4]   = month_t;       display_data[3:0]   = month_u;
            end
        endcase
    end

    //==========================================================================
    // KẾT NỐI CÁC MODULE CON (INSTANTIATIONS)
    //==========================================================================

    // --- Khối Tiện ích ---
    clk_divider i_clk_divider(.clk_in(clk_50mhz), .rst_n(rst_n), .clk_1hz_tick_out(), .clk_1khz_out(clk_1khz));
    
    debounce i_db_mode(.clk(clk_1khz), .button_in(mode_btn), .button_out(btn_mode_db));
    debounce i_db_inc(.clk(clk_1khz), .button_in(inc_btn), .button_out(btn_inc_db));
    debounce i_db_dec(.clk(clk_1khz), .button_in(dec_btn), .button_out(btn_dec_db));

    edge_detector i_edge_mode(.clk(clk_1khz), .level_in(btn_mode_db), .pulse_out(mode_pulse));
    edge_detector i_edge_inc(.clk(clk_1khz), .level_in(btn_inc_db), .pulse_out(inc_pulse));
    edge_detector i_edge_dec(.clk(clk_1khz), .level_in(btn_dec_db), .pulse_out(dec_pulse));
    
    // --- Khối Logic Đếm ---
    wire minute_tick, hour_tick;
    counter_generic #(.MAX_VAL(59)) i_sec (
        .clk(clk_1khz), .rst_n(rst_n), .en(sec_en_tick), 
        .load(1'b0), .data_in(0), // FIX: Giây không bao giờ bị load
        .count_out(sec_bin), .tick_out()
    );
    counter_generic #(.MAX_VAL(59)) i_min (
        .clk(clk_1khz), .rst_n(rst_n), .en((sec_bin==59)&&sec_en_tick), 
        .load(load_time_en), .data_in(min_set), 
        .count_out(min_bin), .tick_out(minute_tick)
    );
    counter_generic #(.MAX_VAL(23)) i_hour(
        .clk(clk_1khz), .rst_n(rst_n), .en(minute_tick), 
        .load(load_time_en), .data_in(hour_set), 
        .count_out(hour_bin), .tick_out(hour_tick)
    );
    date_counter i_date (
        .clk(clk_1khz), .rst_n(rst_n), .day_tick_in(hour_tick), 
        .load(load_date_en), .day_in(day_set), .month_in(month_set), .year_in(year_set), 
        .day_out(day_bin), .month_out(month_bin), .year_out(year_bin)
    );
    
    // --- Khối Chuyển đổi Dữ liệu ---
    binary_to_bcd2 conv_sec (.binary_in(sec_bin), .tens(sec_t), .units(sec_u));
    binary_to_bcd2 conv_min (.binary_in(min_bin), .tens(min_t), .units(min_u));
    binary_to_bcd2 conv_hour(.binary_in(hour_bin),.tens(hour_t), .units(hour_u));
    binary_to_bcd2 conv_day (.binary_in(day_bin), .tens(day_t), .units(day_u));
    binary_to_bcd2 conv_month(.binary_in(month_bin),.tens(month_t), .units(month_u));
    binary_to_bcd4 conv_year(.binary_in(year_bin), .thousands(year_k), .hundreds(year_h), .tens(year_t), .units(year_u));

    // --- Khối Hiển thị ---
    sevenseg_driver i_display (
        .clk_fast(clk_1khz), .rst_n(rst_n), 
        .mode_8_leds(is_8_led_mode), 
        .is_blinking(is_blinking_mode), 
        .data_in(display_data), 
        .seg(seg), .an(an)
    );

endmodule