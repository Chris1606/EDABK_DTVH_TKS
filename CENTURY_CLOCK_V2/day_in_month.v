module day_in_month (
    input wire [3 : 0]  month_tens,
    input wire [3 : 0]  month_units,  
    
    input wire [3 : 0] year_thousands,
    input wire [3 : 0] year_hundreds, 
    input wire [3 : 0] year_tens, 
    input wire [3 : 0] year_units, 
    input wire         rst_n,
    
    output reg [3 : 0]  max_days_tens, 
    output reg [3 : 0]  max_days_units
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
    reg [11:0] year;
    reg       leap_year;

    always @(*) begin
        // Tính tháng và năm từ BCD
        month = month_tens * 4'd10 + month_units;
        year  = 12'd2000 + year_tens * 4'd10 + year_units;

        // Xác định năm nhuận (chia hết cho 4, không chia hết cho 100 trừ khi chia hết cho 400)
        if ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)))
            leap_year = 1;
        else
            leap_year = 0;

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
