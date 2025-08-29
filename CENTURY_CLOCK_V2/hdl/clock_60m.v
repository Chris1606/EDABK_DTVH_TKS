module clock_60m(
    input wire          clk, 
    input wire          rst_n, 
    
    input wire          minute_mode,    // turn on to change mins
    input wire          manual_mode,    // manual mode is on 

    input wire          up, 
    input wire          down, 
    
    input wire          tick_mins, 

    output reg [3 : 0]  minutes_tens,
    output reg [3 : 0]  minutes_units,  

    output wire          tick_hours
);
    wire at_59m = (minutes_tens == 4'd5 && minutes_units == 4'd9);
    assign tick_hours = (!manual_mode && at_59m && tick_mins) ? 1'b1 : 1'b0; 

    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            minutes_tens     <= 0;
            minutes_units    <= 0;  
        end
        else begin 
            // ================= AUTO MODE =================
            if (~manual_mode) begin     
                if (tick_mins) begin
                    if (minutes_tens == 4'd5 && minutes_units == 4'd9) begin 
                        minutes_tens  <= 4'd0;
                        minutes_units <= 4'd0;
                    end 
                    else if (minutes_units == 4'd9) begin 
                        minutes_units <= 4'd0; 
                        minutes_tens  <= minutes_tens + 1'b1; 
                    end 
                    else begin
                        minutes_units <= minutes_units + 1;
                    end  
                end
            end
            // ================= MANUAL MODE =================
            else if (manual_mode && minute_mode) begin 
                if (up && ~down) begin  
                    if (minutes_tens == 4'd5 && minutes_units == 4'd9) begin 
                        minutes_tens  <= 4'd0;
                        minutes_units <= 4'd0;
                    end
                    else if (minutes_units == 4'd9) begin 
                        minutes_units <= 4'd0;
                        minutes_tens  <= minutes_tens + 1;
                    end
                    else begin 
                        minutes_units <= minutes_units + 1;
                    end
                end
                else if (~up && down) begin 
                    if (minutes_tens == 4'd0 && minutes_units == 4'd0) begin 
                        minutes_tens  <= 4'd5;
                        minutes_units <= 4'd9;
                    end
                    else if (minutes_units == 4'd0) begin 
                        minutes_units <= 4'd9;
                        minutes_tens  <= minutes_tens - 1;
                    end
                    else begin 
                        minutes_units <= minutes_units - 1;
                    end
                end
            end
            else begin 
                minutes_tens  <= minutes_tens;
                minutes_units <= minutes_units;
            end
        end  
    end 
endmodule
