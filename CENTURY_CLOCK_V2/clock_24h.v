module clock_24h(
    input wire          clk, 
    input wire          rst_n, 
    
    input wire          hour_mode,       // only active in manual mode
    input wire          manual_mode,     // 1 = manual, 0 = auto

    input wire          up, 
    input wire          down, 
    
    input wire          tick_hours, 

    output reg [3 : 0]  hours_tens, 
    output reg [3 : 0]  hours_units,

    output wire         tick_days
);
    
    wire at_23h = (hours_tens == 4'd2 && hours_units == 4'd3); 
    assign tick_days = (!manual_mode && at_23h && tick_hours) ? 1'b1 : 1'b0;  
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            hours_tens  <= 0;
            hours_units <= 0;
        end
        else begin 


            // ================= AUTO MODE =================
            if (~manual_mode) begin     
                if (tick_hours) begin
                    if (hours_tens == 4'd2 && hours_units == 4'd3) begin 
                        hours_tens  <= 4'd0;
                        hours_units <= 4'd0;
                    end 
                    else if (hours_units == 4'd9) begin 
                        hours_units <= 4'd0; 
                        hours_tens  <= hours_tens + 1'b1; 
                    end 
                    else begin
                        hours_units <= hours_units + 1'b1;
                    end  
                end
            end
            // ================= MANUAL MODE =================
            else if (manual_mode && hour_mode) begin 
                if (up && ~down) begin  
                    if (hours_tens == 4'd2 && hours_units == 4'd3) begin 
                        hours_tens  <= 4'd0;
                        hours_units <= 4'd0;
                    end
                    else if (hours_units == 4'd9) begin 
                        hours_units <= 4'd0;
                        hours_tens  <= hours_tens + 1;
                    end
                    else begin 
                        hours_units <= hours_units + 1;
                    end
                end
                else if (~up && down) begin 
                    if (hours_tens == 4'd0 && hours_units == 4'd0) begin 
                        hours_tens  <= 4'd2;
                        hours_units <= 4'd3;
                    end
                    else if (hours_units == 4'd0) begin 
                        hours_units <= 4'd9;
                        hours_tens  <= hours_tens - 1;
                    end
                    else begin 
                        hours_units <= hours_units - 1;
                    end
                end
            end

            else begin 
                hours_tens  <= hours_tens; 
                hours_units <= hours_units;
            end 
        end
    end

endmodule
