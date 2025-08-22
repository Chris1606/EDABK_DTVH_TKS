module controller (
    input wire          clk, 
    input wire          rst_n,
    input wire          select_button,
    input wire          manual_mode,

    output reg [5 : 0]  object_mode, 
    output wire         blink_state
); 
    // ------------------------------
    // Blink generator (1 Hz)
    // ------------------------------
    localparam BLINK_DIV = 12_500_000; // 50 MHz -> toggle every 0.5s
    reg [$clog2(BLINK_DIV)-1:0] blink_counter;
    reg blink_states;

    assign blink_state = blink_states;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            blink_counter <= 0;
            blink_states   <= 1'b1;
        end else begin
            if (blink_counter == BLINK_DIV - 1) begin
                blink_counter <= 0;
                blink_states   <= ~blink_states;
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
    always @(counter) begin
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
endmodule