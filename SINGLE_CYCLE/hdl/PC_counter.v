module PC_counter (
    input wire              clk, 
    input wire              rst_n, 

    input wire              PC_sel, 
    
    input wire [31 : 0]     ALU_result, 

    output wire [31 : 0]    PC_plus4,
    output reg [31 : 0]     PC   
); 

    //PC Plus 4


    assign PC_plus4 = PC + 32'd4; 

    // PC Mux 
    wire [31 : 0]PC_next; 

    assign PC_next =  (PC_sel) ? ALU_result : PC_plus4;

    // PC Update
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            PC <= 0; 
        end 
        else begin 
            PC <= PC_next; 
        end
    end 



endmodule