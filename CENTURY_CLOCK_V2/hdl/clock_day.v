module clock_day(
    input wire          clk, 
    input wire          rst_n, 


    input wire          day_mode,
    input wire          manual_mode, 
    input wire          up, 
    input wire          down, 

    input wire          tick_days, 

    input wire [3:0]    max_days_tens, 

    input wire [3:0]    max_days_units, 


    output reg [3:0]    day_tens, 
    output reg [3:0]    day_units,

    output wire         tick_months

);

    wire at_max_day = (day_tens == max_days_tens && day_units == max_days_units );
    assign tick_months = (at_max_day && ~manual_mode && tick_days) ? 1'b1 : 1'b0; 
    


    
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin
            day_tens  <= 4'd0; 
            day_units <= 4'd1; 
        end  
        else begin 
            // ================= AUTO MODE =================
            if (~manual_mode) begin     
                if (tick_days) begin
                    if (day_tens == max_days_tens && day_units == max_days_units) begin 
                        day_tens  <= 4'd0; 
                        day_units <= 4'd1;
                    end
                    else if (day_units == 4'd9) begin 
                        day_units <= 4'd0; 
                        day_tens  <= day_tens + 1'b1; 
                    end 
                    else begin
                        day_units <= day_units + 1'b1;
                    end  
                end
            end
            // ================= MANUAL MODE =================
            else if (manual_mode && day_mode) begin 
                if (up && ~down) begin  
                    if (day_tens == max_days_tens && day_units == max_days_units) begin 
                        day_tens  <= 4'd0;
                        day_units <= 4'd1;
                    end
                    else if (day_units == 4'd9) begin 
                        day_units <= 4'd0;
                        day_tens  <= day_tens + 1'b1;
                    end
                    else begin 
                        day_units <= day_units + 1'b1;
                    end
                end
                else if (~up && down) begin 
                    if (day_tens == 4'd0 && day_units == 4'd1) begin 
                        day_tens  <= max_days_tens;
                        day_units <= max_days_units;
                    end
                    else if (day_units == 4'd0) begin 
                        day_units <= 4'd9;
                        day_tens  <= day_tens - 1'b1;
                    end
                    else begin 
                        day_units <= day_units - 1'b1;
                    end
                end
            end

            // ================= CHỈNH LẠI NẾU > MAX_DAY =================
            if ((day_tens*10 + day_units) > (max_days_tens*10 + max_days_units)) begin
                day_tens  <= max_days_tens;
                day_units <= max_days_units;
            end
        end
    end
endmodule
