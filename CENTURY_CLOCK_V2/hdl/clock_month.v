module clock_month(
    input wire          clk, 
    input wire          rst_n, 
    
    input wire          month_mode,
    input wire          manual_mode, 
    
    input wire          up, 
    input wire          down, 

    input wire          tick_months,  

    output reg [3 : 0]  month_tens, 
    output reg [3 : 0]  month_units, 
    
    output wire          tick_years
);

    
    wire at_DEC = (month_tens==4'd1 && month_units== 4'd2); 
    assign tick_years = (~manual_mode && at_DEC && tick_months) ? 1'b1 : 1'b0;
    always @(posedge clk or negedge rst_n) begin 
        
        if (~rst_n) begin 
            month_tens  <= 4'b0;
            month_units <= 4'b1; 
        end 
        else begin 
            // ================= AUTO MODE =================
            if (~manual_mode) begin     
                if (tick_months) begin
                    if (month_tens   == 4'd1 && month_units   == 4'd2) begin 
                        month_tens    <= 4'd0; 
                        month_units   <= 4'd1;
                    end 
                    else if (month_units == 4'd9) begin 
                        month_units <= 4'd0; 
                        month_tens  <= month_tens + 1'b1; 
                    end 
                    else begin
                        month_units  <= month_units + 1'b1;
                    end  
                end
            end
            // ================= MANUAL MODE =================
            else if (manual_mode && month_mode) begin 
                if (up && ~down) begin  
                    if (month_tens   == 4'd1 && month_units   == 4'd2) begin 
                        month_tens  <= 4'd0;
                        month_units <= 4'd1;
                    end
                    else if (month_units == 4'd9) begin 
                        month_units <= 4'd0;
                        month_tens  <= month_tens + 1'b1;
                    end
                    else begin 
                        month_units <= month_units + 1'b1;
                    end
                end
                else if (~up && down) begin 
                    if (month_tens == 4'd0 && month_units == 4'd1) begin 
                        month_tens  <= 4'd1;
                        month_units <= 4'd2;
                    end
                    else if (month_units == 4'd0) begin 
                        month_units <= 4'd9;
                        month_tens  <= month_tens - 1'b1;
                    end
                    else begin 
                        month_units <= month_units - 1'b1;
                    end
                end
            end
            else begin 
                month_tens <= month_tens; 
                month_units <= month_units;
            end
        end

    end


endmodule