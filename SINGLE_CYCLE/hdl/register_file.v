module registers_file #(
    parameter REG_WIDTH = 32
)(
    input wire              clk,
    input wire              rst_n,
    input wire [31:0]       data_in, 

    input wire [4:0]        AddrD, // destination registers 
    input wire [4:0]        AddrA, // source registers 1 
    input wire [4:0]        AddrB, // source registers 2
    
    input wire              RegWEn, 

    output wire [31:0]      DataA, // Data of registers 1 
    output wire [31:0]      DataB  // Data of registers 2

);

    // 32 registerss of 32-bit
    reg [REG_WIDTH-1:0] registers [0:31];
    
    integer i;
    // Write back
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            for (i = 0; i < REG_WIDTH; i = i + 1)
                registers[i] <= 32'b0;    
        end 
        else begin 
            if (RegWEn && AddrD != 5'd0) begin 
                registers[AddrD] <= data_in;
            end 
        end
    end 
    
    // Read ports (x0 always returns 0)
    assign DataA = (AddrA != 5'd0) ? registers[AddrA] : 32'd0; 
    assign DataB = (AddrB != 5'd0) ? registers[AddrB] : 32'd0; 

endmodule
