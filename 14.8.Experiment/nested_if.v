module nested_if (
    input        clk, 
    input        rst_n, 
    input        up_en, 
    input        down_en, 
    output reg [3:0] counter
);

always @(posedge clk or negedge rst_n) begin
    // Nếu reset được kích hoạt
    if (!rst_n) begin
        counter <= 4'b0000;
    end 
    // Nếu enable và đếm lên
    else if (up_en) begin
        counter <= counter + 1'b1;
    end 
    // Nếu enable và đếm xuống
    else if (down_en) begin
        counter <= counter - 1'b1;
    end 
    // Nếu không đếm
    else begin
        counter <= counter; // Dòng này thực tế là dư thừa
    end
end

endmodule
