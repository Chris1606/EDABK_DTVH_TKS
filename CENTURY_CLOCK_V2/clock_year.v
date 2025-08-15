module clock_year (
    input wire          clk, 
    input wire          rst_n, 

    input wire          year_mode,
    input wire          manual_mode, 
    
    input wire          up, 
    input wire          down, 

    input wire          tick_years, 

    input wire [3 : 0]  seconds_tens, 
    input wire [3 : 0]  seconds_units, 
    
    input wire [3 : 0]  minutes_tens,
    input wire [3 : 0]  minutes_units,  

    input wire [3 : 0]  hours_tens, 
    input wire [3 : 0]  hours_units,
    

    input wire [3 : 0]  day_tens,
    input wire [3 : 0]  day_units,      

    input wire [3 : 0]  month_tens, 
    input wire [3 : 0]  month_units, 


    output reg  [3 : 0] year_thousands,
    output reg  [3 : 0] year_hundreds, 
    output reg  [3 : 0] year_tens, 
    output reg  [3 : 0] year_units,

    output wire          finished
);

    wire at_finish_year =(year_thousands == 4'd2 && year_hundreds == 4'd0 && year_tens == 4'd9 && year_units == 4'd9);
    assign finished = (~manual_mode && tick_years && at_finish_year) ? 1'b1 : 1'b0;

    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            year_thousands  <= 4'd2;
            year_hundreds   <= 4'd0;
            year_tens       <= 4'd2;
            year_units      <= 4'd5;

        end
        else begin 
            // ================= AUTO MODE =================
            if (~manual_mode) begin     
                if (tick_years) begin
                    if (year_thousands == 4'd2 && year_hundreds == 4'd0 &&
                        year_tens      == 4'd9 && year_units    == 4'd9) 
                    begin 
                        year_thousands  <= 4'd2;
                        year_hundreds   <= 4'd0;
                        year_tens       <= 4'd2;
                        year_units      <= 4'd5;
                    end 
                    else if (year_units == 4'd9) begin 
                        year_units  <= 4'd0; 
                        year_tens   <= year_tens + 1; 
                    end 
                    else begin
                        year_units  <= year_units + 1;
                    end  
                end
            end
            // ================= MANUAL MODE =================
            else if (manual_mode && year_mode) begin 
                if (up && ~down) begin  
                    if (year_thousands == 4'd2 && year_hundreds == 4'd0 &&
                        year_tens      == 4'd9 && year_units    == 4'd9) 
                    begin 
                        year_thousands  <= 4'd2;
                        year_hundreds   <= 4'd0;
                        year_tens       <= 4'd2;
                        year_units      <= 4'd5;
                    end 
                    else if (year_units == 4'd9) begin 
                        year_units  <= 4'd0; 
                        year_tens   <= year_tens + 1; 
                    end 
                    else begin
                        year_units  <= year_units + 1;
                    end  
                end
                else if (~up && down) begin 
                    if (year_thousands == 4'd2 && year_hundreds == 4'd0 &&
                        year_tens      == 4'd2 && year_units    == 4'd5) 
                    begin 
                        year_thousands  <= 4'd2;
                        year_hundreds   <= 4'd0;
                        year_tens       <= 4'd9;
                        year_units      <= 4'd9;
                    end 
                    else if (year_units == 4'd0) begin 
                        year_units  <= 4'd9; 
                        year_tens   <= year_tens - 1; 
                    end 
                    else begin
                        year_units  <= year_units - 1;
                    end  
                end
            end
            else begin 
                    year_thousands  <= year_thousands;
                    year_hundreds   <= year_hundreds;
                    year_tens       <= year_tens;
                    year_units      <= year_units ;
            end

        end 
    end 
endmodule