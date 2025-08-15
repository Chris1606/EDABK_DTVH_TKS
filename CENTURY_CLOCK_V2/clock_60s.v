module clock_60s(
    input wire          clk,
    input wire          rst_n, 
    
    input wire          second_mode,   // bật lên để chỉnh seconds
    input wire          manual_mode,   // bật lên để vào chế độ chỉnh tay

    input wire          up, 
    input wire          down, 

    output reg [3 : 0]  seconds_tens, 
    output reg [3 : 0]  seconds_units,

    output wire          tick_mins
); 

    wire at_59s = (seconds_tens == 4'd5 && seconds_units == 4'd9);

        // tick_mins is combinational: high in auto mode when value is 59
    assign tick_mins = (!manual_mode && at_59s) ? 1'b1 : 1'b0;
    
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            seconds_tens    <= 4'd0;
            seconds_units   <= 4'd0;
        end 
        else begin 
            // ===================== AUTO MODE =====================
            if (~manual_mode) begin  // Clock is running normally
                if (seconds_tens == 4'd5 && seconds_units == 4'd9) begin 
                    seconds_tens  <= 0; 
                    seconds_units <= 0; 
                end 
                else if (seconds_units == 4'd9) begin 
                    seconds_units <= 4'd0; 
                    seconds_tens  <= seconds_tens + 1'b1;
                end 
                else begin 
                    seconds_units <= seconds_units + 1'b1; 
                end
            end 

            // ===================== MANUAL MODE =====================
            else if (manual_mode && second_mode) begin
                // Manual + seconds selected
                if (up && !down) begin 
                    if (seconds_tens == 4'd5 && seconds_units == 4'd9) begin 
                        seconds_tens  <= 4'd0;
                        seconds_units <= 4'd0;
                    end 
                    else if (seconds_units == 4'd9) begin 
                        seconds_units <= 4'd0;
                        seconds_tens  <= seconds_tens + 1'b1;
                    end 
                    else begin 
                        seconds_units <= seconds_units + 1'b1;
                    end 
                end 
                else if (!up && down) begin 
                    if (seconds_tens == 4'd0 && seconds_units == 4'd0) begin 
                        seconds_tens  <= 4'd5; 
                        seconds_units <= 4'd9;
                    end 
                    else if (seconds_units == 4'd0) begin
                        seconds_units <= 4'd9;  
                        seconds_tens  <= seconds_tens - 1; 
                    end
                    else begin 
                        seconds_units <= seconds_units - 1; 
                    end 
                end
                // Nếu không nhấn gì thì giữ nguyên
            end
            else begin 
                seconds_tens <= seconds_tens;
                seconds_units <= seconds_units;
            end
        end

    end
endmodule
