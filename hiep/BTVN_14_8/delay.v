`timescale 1ns / 1ps

module example1_inter_delay_tb;

    integer a, b;

    // Process 1
    initial begin
        $display("[%0t ns] Process 1: Bắt đầu.", $time);
        a = 3;
        $display("[%0t ns] Process 1: a được gán giá trị 3. a=%d", $time, a);
        
        #6; // Wait 6ns
        b = a + a; // Calculate b after 6ns
        $display("[%0t ns] Process 1: b = a + a. a=%d, b=%d", $time, a, b);

        #4; // Wait another 4ns
        a = b + a; // Calculate a after 4ns
        $display("[%0t ns] Process 1: a = b + a. a=%d, b=%d", $time, a, b);
        $display("[%0t ns] Process 1: Kết thúc.", $time);
    end

    // Process 2 (runs in parallel)
    initial begin
        $display("[%0t ns] Process 2: Bắt đầu.", $time);
        #3; // Wait 3ns
        a = 1; // Assign a after 3ns
        $display("[%0t ns] Process 2: a được gán giá trị 1. a=%d", $time, a);

        #5; // Wait another 5ns
        b = 3; // Assign b after 5ns
        $display("[%0t ns] Process 2: b được gán giá trị 3. b=%d", $time, b);
        $display("[%0t ns] Process 2: Kết thúc.", $time);
    end
    
    // Monitor to track values
    initial begin
        $monitor("[%0t ns] MONITOR: a = %d, b = %d", $time, a, b);
        #20 $finish; // End simulation after 20ns
    end

endmodule

// Uncomment the following module to test intra-delay behavior
/*
module example2_intra_delay_tb;

    integer a, b;

    // Process 1
    initial begin
        $display("[%0t ns] Process 1: Bắt đầu.", $time);
        a = 3;
        $display("[%0t ns] Process 1: a được gán giá trị 3. a=%d", $time, a);

        // Evaluate a+a immediately, assign to b after 6ns
        b = #6 a + a;
        $display("[%0t ns] Process 1: Đã đọc a+a (%d+%d), lên lịch gán cho b sau 6ns.", $time, a, a);

        // Evaluate b+a immediately, assign to a after 4ns
        a = #4 b + a;
        $display("[%0t ns] Process 1: Đã đọc b+a (%d+%d), lên lịch gán cho a sau 4ns.", $time, b, a);
    end

    // Process 2 (runs in parallel)
    initial begin
        $display("[%0t ns] Process 2: Bắt đầu.", $time);
        #3; // Wait 3ns
        a = 1; // Assign a after 3ns
        $display("[%0t ns] Process 2: a được gán giá trị 1. a=%d", $time, a);

        #5; // Wait another 5ns
        b = 3; // Assign b after 5ns
        $display("[%0t ns] Process 2: b được gán giá trị 3. b=%d", $time, b);
        $display("[%0t ns] Process 2: Kết thúc.", $time);
    end

    // Monitor to track values
    initial begin
        $monitor("[%0t ns] MONITOR: a = %d, b = %d", $time, a, b);
        #20 $finish; // End simulation after 20ns
    end

endmodule
*/