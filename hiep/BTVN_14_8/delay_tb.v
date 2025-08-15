`timescale 1ns / 1ps

module dut_inter_delay (
    input               start,
    output reg integer  a,
    output reg integer  b
);

    // Use always @(posedge start) to trigger the DUT
    always @(posedge start) begin
        // Process 1
        fork
            begin
                $display("[%0t ns] DUT Process 1: Bắt đầu.", $time);
                a = 3;
                
                #6; // Wait 6ns
                b = a + a;
                
                #4; // Wait another 4ns
                a = b + a;
                $display("[%0t ns] DUT Process 1: Kết thúc.", $time);
            end

            // Process 2
            begin
                $display("[%0t ns] DUT Process 2: Bắt đầu.", $time);
                #3; // Wait 3ns
                a = 1;

                #5; // Wait another 5ns
                b = 3;
                $display("[%0t ns] DUT Process 2: Kết thúc.", $time);
            end
        join
    end

endmodule

// // Testbench to verify dut_inter_delay
// module tb_inter_delay;

//     // Signals to connect to the DUT
//     reg         start_signal;
//     wire integer a_out;
//     wire integer b_out;

//     // Instantiate the DUT
//     dut_inter_delay my_dut (
//         .start(start_signal),
//         .a(a_out),
//         .b(b_out)
//     );
    
//     // Test procedure
//     initial begin
//         $display("--- Starting Testbench for Case 1 ---");
//         $monitor("[%0t ns] MONITOR: a_out = %d, b_out = %d", $time, a_out, b_out);
        
//         // Initialize
//         start_signal = 0;
//         #10;
        
//         // Generate a pulse for 'start_signal' to trigger the DUT
//         $display("[%0t ns] TB: Triggering start signal.", $time);
//         start_signal = 1;
//         #2; // Hold the pulse for 2ns
//         start_signal = 0;
        
//         // Wait for the simulation to complete
//         #20;
//         $display("--- Final Results: a = %d, b = %d ---", a_out, b_out);
//         $finish;
//     end
    
// endmodule