module booth_multiplier #(parameter DATA_WIDTH = 32)(
    input wire                          clk, 
    input wire                          rst_n, 
    
    input wire                          start, 
    input wire                          en,

    input wire [DATA_WIDTH - 1 : 0]     Mcand,
    input wire [DATA_WIDTH - 1 : 0]     Mplier,
    
    output wire [DATA_WIDTH * 2 - 1 : 0] result,

    output wire                         ready
);

    reg [$clog2(DATA_WIDTH) - 1 : 0]    counter;

     


endmodule