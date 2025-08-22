module day_in_month (
    input wire [3 : 0]  month_tens,
    input wire [3 : 0]  month_units,  
    
    input wire [3 : 0] year_thousands,
    input wire [3 : 0] year_hundreds, 
    input wire [3 : 0] year_tens, 
    input wire [3 : 0] year_units, 
    input wire         rst_n,
    
    output reg [3 : 0]  max_days_tens, 
    output reg [3 : 0]  max_days_units,

    output wire                leap
); 
  
    // Hằng số tháng (1–12)
    localparam JAN = 8'd1;
    localparam FEB = 8'd2;
    localparam MAR = 8'd3;
    localparam APR = 8'd4;
    localparam MAY = 8'd5;
    localparam JUN = 8'd6;
    localparam JUL = 8'd7;
    localparam AUG = 8'd8;
    localparam SEP = 8'd9; 
    localparam OCT = 8'd10;
    localparam NOV = 8'd11;
    localparam DEC = 8'd12;
    
    reg [7:0] month;
    // Biến để xác định năm nhuận
    reg       leap_year;
    reg [7:0] year_thousands_hundreds;
    reg [7:0] year_tens_units;
    assign leap = leap_year;

    always @(*) begin
        // Tính tháng và năm từ BCD
        month = (month_tens << 3) + (month_tens << 1) + month_units;
        
        year_thousands_hundreds = (year_thousands << 3) + (year_thousands << 1) + year_hundreds;

        year_tens_units = (year_tens << 3) + (year_tens << 1) + year_units;

        
           if (year_tens == 4'd0 && year_units == 4'd0) begin 
                if (year_thousands_hundreds [1 : 0] == 2'b00) begin 
                    leap_year = 1'b1; 
                end 
                else if (year_thousands_hundreds [1 : 0] != 2'b00) begin 
                    leap_year = 1'b0; 
                end
                else 
                    leap_year = 1'b0; 
            end 

            else if (year_tens_units [1 : 0] == 2'b00) begin
                leap_year = 1'b1; 
            end
            else begin 
                leap_year = 1'b0;
            end 
           
        // Giá trị mặc định nếu reset
        if (~rst_n) begin
            max_days_tens  = 4'd3; 
            max_days_units = 4'd1;  
        end else begin
            case (month)
                JAN, MAR, MAY, JUL, AUG, OCT, DEC: begin
                    max_days_tens  = 4'd3; 
                    max_days_units = 4'd1;
                end
                APR, JUN, SEP, NOV: begin
                    max_days_tens  = 4'd3;
                    max_days_units = 4'd0;
                end
                FEB: begin
                    if (leap_year) begin
                        max_days_tens  = 4'd2;
                        max_days_units = 4'd9;
                    end else begin
                        max_days_tens  = 4'd2;
                        max_days_units = 4'd8;
                    end
                end
                default: begin
                    max_days_tens  = 4'd3; 
                    max_days_units = 4'd1;
                end
            endcase
        end
    end
endmodule