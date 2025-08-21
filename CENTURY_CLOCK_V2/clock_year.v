module clock_year (
    input wire          clk, 
    input wire          rst_n, 

    input wire          year_mode,
    input wire          manual_mode, 
    
    input wire          up, 
    input wire          down, 

    input wire          tick_years, 


    output reg  [3 : 0] year_thousands,
    output reg  [3 : 0] year_hundreds, 
    output reg  [3 : 0] year_tens, 
    output reg  [3 : 0] year_units

);

    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            year_thousands  <= 4'd0;
            year_hundreds   <= 4'd0;
            year_tens       <= 4'd0;
            year_units      <= 4'd0;

        end
        else begin 
            // ================= AUTO MODE =================
            if (~manual_mode) begin 
                if (tick_years && year_mode) begin 
                    // Reset year to 0 after reaching 9999
                    if (year_thousands == 4'd9 && year_hundreds == 4'd9 &&
                        year_tens      == 4'd9 && year_units    == 4'd9) 
                    begin 
                        year_thousands  <= 4'd0;
                        year_hundreds   <= 4'd0;
                        year_tens       <= 4'd0;
                        year_units      <= 4'd0;
                    end

                    else begin 
                        if (year_units == 4'd9 ) begin 
                            year_units  <= 4'd0; 
                            year_tens   <= year_tens + 1'b1; 
                            if (year_tens == 4'd9) begin 
                                year_tens   <= 4'd0;
                                year_hundreds <= year_hundreds + 1'b1; 
                                if (year_hundreds == 4'd9) begin 
                                    year_hundreds <= 4'd0;
                                    year_thousands <= year_thousands + 1'b1;
                                end
                            end 
                        end
                        else begin 
                            year_units  <= year_units + 1'b1;
                        end 
                    end
                end
            end     
                
            // ================= MANUAL MODE =================
            else if (manual_mode && year_mode) begin 
                if (up && ~down) begin  
                    if (year_thousands == 4'd9 && year_hundreds == 4'd9 &&
                        year_tens      == 4'd9 && year_units    == 4'd9) 
                    begin 
                        year_thousands  <= 4'd0;
                        year_hundreds   <= 4'd0;
                        year_tens       <= 4'd0;
                        year_units      <= 4'd0;
                    end 
                    else begin 
                        if (year_units == 4'd9 ) begin 
                            year_units  <= 4'd0; 
                            year_tens   <= year_tens + 1'b1; 
                            if (year_tens == 4'd9) begin 
                                year_tens   <= 4'd0;
                                year_hundreds <= year_hundreds + 1'b1; 
                                if (year_hundreds == 4'd9) begin 
                                    year_hundreds <= 4'd0;
                                    year_thousands <= year_thousands + 1'b1;
                                end
                            end 
                        end
                        else begin 
                            year_units  <= year_units + 1'b1;
                        end 
                    end 
                end

                else if (~up && down) begin 
                    if (year_thousands == 4'd0 && year_hundreds == 4'd0 &&
                        year_tens      == 4'd0 && year_units    == 4'd0) 
                    begin 
                        year_thousands  <= 4'd9;
                        year_hundreds   <= 4'd9;
                        year_tens       <= 4'd9;
                        year_units      <= 4'd9;
                    end 
                    else begin 
                        if (year_units == 4'd0) begin 
                            year_units  <= 4'd9; 
                            year_tens   <= year_tens - 1'b1;
                            if (year_tens == 4'd0) begin
                                year_tens <= 4'd9;
                                year_hundreds <= year_hundreds - 1'b1;
                                if (year_hundreds == 4'd0) begin
                                    year_hundreds <= 4'd9;
                                    year_thousands <= year_thousands - 1'b1;
                                    if (year_thousands == 4'd0) begin
                                        year_thousands <= 4'd9; 
                                    end 
                                end
                            end
                        end
                        else begin 
                            year_units  <= year_units - 1'b1;
                        end 
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