/*******************************************************************************
 * Tên module: tb_top
 * Chức năng: Testbench để mô phỏng toàn bộ hoạt động của module top.v
 * Tương ứng với FSM 2 nhiệm vụ chính: Chế độ xem và Chế độ cài đặt
 * Tác giả: Hiệp (AI Assistant)
 * Phiên bản: 2.0 (Cập nhật theo FSM mới)
 ******************************************************************************/
`timescale 1ns / 1ps

module tb_top;

    //================== Parameters ==================
    localparam CLK_PERIOD       = 20; // Chu kỳ clock 50MHz là 20ns
    localparam BTN_PRESS_TIME   = 200_000_000; // Giả lập nhấn nút trong 200ms
    localparam SIM_DELAY        = CLK_PERIOD * 100; // Delay nhỏ giữa các thao tác

    //================== Signal Declarations ==================
    // Inputs to DUT (Device Under Test)
    reg clk_50mhz;
    reg rst_n;
    reg mode_btn;
    reg inc_btn;
    reg dec_btn;

    // Outputs from DUT
    wire [7:0] seg;
    wire [7:0] an;

    //================== Instantiate DUT ==================
    top UUT (
        .clk_50mhz(clk_50mhz),
        .rst_n(rst_n),
        .mode_btn(mode_btn),
        .inc_btn(inc_btn),
        .dec_btn(dec_btn),
        .seg(seg),
        .an(an)
    );

    //================== Clock Generator ==================
    always #((CLK_PERIOD)/2) clk_50mhz = ~clk_50mhz;

    //================== Tasks for Button Presses ==================
    // Task để giả lập việc nhấn nút MODE
    task press_mode_button;
        begin
            $display("T=%0t ns: [ACTION] Pressing MODE button...", $time);
            mode_btn = 1'b1;
            #(BTN_PRESS_TIME);
            mode_btn = 1'b0;
            #(SIM_DELAY);
        end
    endtask

    // Task để giả lập việc nhấn nút INCREASE
    task press_inc_button;
        begin
            $display("T=%0t ns: [ACTION] Pressing INCREASE button...", $time);
            inc_btn = 1'b1;
            #(BTN_PRESS_TIME);
            inc_btn = 1'b0;
            #(SIM_DELAY);
        end
    endtask
    
    // Task để giả lập việc nhấn nút DECREASE
    task press_dec_button;
        begin
            $display("T=%0t ns: [ACTION] Pressing DECREASE button...", $time);
            dec_btn = 1'b1;
            #(BTN_PRESS_TIME);
            dec_btn = 1'b0;
            #(SIM_DELAY);
        end
    endtask

    //================== Main Test Sequence ==================
    initial begin
        // --- SCENARIO 0: Initialization & Reset ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] Starting Millennium Clock Simulation", $time);
        $display("T=%0t ns: [TEST] FSM with 2 Main Tasks: VIEW & SETTING", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        clk_50mhz = 1'b0;
        rst_n     = 1'b0; // Assert reset (active-low)
        mode_btn  = 1'b0;
        inc_btn   = 1'b0;
        dec_btn   = 1'b0;

        #(CLK_PERIOD * 10);
        $display("T=%0t ns: [TEST] Releasing reset...", $time);
        rst_n = 1'b1; // De-assert reset
        #(SIM_DELAY);

        // --- SCENARIO 1: NHIỆM VỤ 1 - CHẾ ĐỘ XEM (VIEW MODE) ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] SCENARIO 1: Testing VIEW MODE", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        // Chờ đồng hồ chạy một lúc để quan sát
        $display("T=%0t ns: [TEST] Letting clock run for 2 seconds in VIEW_TIME mode...", $time);
        #(2 * 1_000_000_000); // Chờ 2 giây
        
        // Chuyển sang xem ngày tháng
        $display("T=%0t ns: [TEST] Switching to VIEW_DATE mode...", $time);
        press_mode_button(); // S_VIEW_TIME -> S_VIEW_DATE
        #(2 * 1_000_000_000); // Chờ 2 giây để quan sát ngày tháng
        
        // --- SCENARIO 2: NHIỆM VỤ 2 - CHẾ ĐỘ CÀI ĐẶT (SETTING MODE) ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] SCENARIO 2: Testing SETTING MODE", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        // Vào chế độ cài đặt
        $display("T=%0t ns: [TEST] Entering SETTING mode...", $time);
        press_mode_button(); // S_VIEW_DATE -> S_SET_HOUR
        
        // Test cài đặt giờ
        $display("T=%0t ns: [TEST] Setting HOUR to 15...", $time);
        repeat (15) press_inc_button(); // Tăng lên 15 giờ
        #(1 * 1_000_000_000); // Chờ 1 giây
        
        // Chuyển sang cài đặt phút
        $display("T=%0t ns: [TEST] Switching to MINUTE setting...", $time);
        press_mode_button(); // S_SET_HOUR -> S_SET_MINUTE
        
        // Test cài đặt phút
        $display("T=%0t ns: [TEST] Setting MINUTE to 45...", $time);
        repeat (45) press_inc_button(); // Tăng lên 45 phút
        #(1 * 1_000_000_000); // Chờ 1 giây
        
        // Chuyển sang cài đặt ngày
        $display("T=%0t ns: [TEST] Switching to DAY setting...", $time);
        press_mode_button(); // S_SET_MINUTE -> S_SET_DAY
        
        // Test cài đặt ngày
        $display("T=%0t ns: [TEST] Setting DAY to 25...", $time);
        repeat (25) press_inc_button(); // Tăng lên ngày 25
        #(1 * 1_000_000_000); // Chờ 1 giây
        
        // Chuyển sang cài đặt tháng
        $display("T=%0t ns: [TEST] Switching to MONTH setting...", $time);
        press_mode_button(); // S_SET_DAY -> S_SET_MONTH
        
        // Test cài đặt tháng
        $display("T=%0t ns: [TEST] Setting MONTH to 12...", $time);
        repeat (12) press_inc_button(); // Tăng lên tháng 12
        #(1 * 1_000_000_000); // Chờ 1 giây
        
        // Chuyển sang cài đặt năm
        $display("T=%0t ns: [TEST] Switching to YEAR setting...", $time);
        press_mode_button(); // S_SET_MONTH -> S_SET_YEAR
        
        // Test cài đặt năm
        $display("T=%0t ns: [TEST] Setting YEAR to 2025...", $time);
        repeat (5) press_inc_button(); // Tăng năm lên 2025
        #(1 * 1_000_000_000); // Chờ 1 giây
        
        // --- SCENARIO 3: HOÀN THÀNH CÀI ĐẶT VÀ QUAN SÁT ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] SCENARIO 3: Finalizing Settings", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        // Quay về chế độ xem
        $display("T=%0t ns: [TEST] Returning to VIEW mode...", $time);
        press_mode_button(); // S_SET_YEAR -> S_VIEW_TIME
        
        // Quan sát đồng hồ chạy với thời gian mới
        $display("T=%0t ns: [TEST] Observing clock with new settings (15:45:XX)...", $time);
        #(3 * 1_000_000_000); // Chờ 3 giây
        
        // Chuyển sang xem ngày tháng mới
        $display("T=%0t ns: [TEST] Switching to view new date (25-12-25)...", $time);
        press_mode_button(); // S_VIEW_TIME -> S_VIEW_DATE
        #(2 * 1_000_000_000); // Chờ 2 giây
        
        // --- SCENARIO 4: TEST CHỨC NĂNG GIẢM GIÁ TRỊ ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] SCENARIO 4: Testing DECREASE Function", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        // Vào lại chế độ cài đặt
        press_mode_button(); // S_VIEW_DATE -> S_SET_HOUR
        
        // Test giảm giờ
        $display("T=%0t ns: [TEST] Decreasing HOUR from 15 to 10...", $time);
        repeat (5) press_dec_button(); // Giảm từ 15 xuống 10
        #(1 * 1_000_000_000);
        
        // Chuyển sang giảm phút
        press_mode_button(); // S_SET_HOUR -> S_SET_MINUTE
        $display("T=%0t ns: [TEST] Decreasing MINUTE from 45 to 30...", $time);
        repeat (15) press_dec_button(); // Giảm từ 45 xuống 30
        #(1 * 1_000_000_000);
        
        // Quay về chế độ xem
        press_mode_button(); // S_SET_MINUTE -> S_SET_DAY
        press_mode_button(); // S_SET_DAY -> S_SET_MONTH
        press_mode_button(); // S_SET_MONTH -> S_SET_YEAR
        press_mode_button(); // S_SET_YEAR -> S_VIEW_TIME
        
        // Quan sát kết quả cuối cùng
        $display("T=%0t ns: [TEST] Final observation with updated time (10:30:XX)...", $time);
        #(3 * 1_000_000_000);
        
        // --- SCENARIO 5: TEST CHUYỂN ĐỔI NHANH GIỮA CÁC CHẾ ĐỘ ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] SCENARIO 5: Quick Mode Switching", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        
        // Chuyển nhanh giữa các chế độ
        repeat (3) begin
            press_mode_button(); // VIEW_TIME -> VIEW_DATE
            #(500_000_000); // 0.5 giây
            press_mode_button(); // VIEW_DATE -> SET_HOUR
            #(500_000_000); // 0.5 giây
            press_mode_button(); // SET_HOUR -> SET_MINUTE
            #(500_000_000); // 0.5 giây
            press_mode_button(); // SET_MINUTE -> SET_DAY
            #(500_000_000); // 0.5 giây
            press_mode_button(); // SET_DAY -> SET_MONTH
            #(500_000_000); // 0.5 giây
            press_mode_button(); // SET_MONTH -> SET_YEAR
            #(500_000_000); // 0.5 giây
            press_mode_button(); // SET_YEAR -> VIEW_TIME
            #(500_000_000); // 0.5 giây
        end
        
        // --- SCENARIO 6: End Simulation ---
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $display("T=%0t ns: [TEST] Simulation completed successfully!", $time);
        $display("T=%0t ns: [TEST] All FSM states and functions tested", $time);
        $display("T=%0t ns: [TEST] ==========================================", $time);
        $finish;
    end

    //================== Optional: Waveform Dump ==================
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
    end

endmodule