module counter #(parameter WIDTH = 4)(
    input wire                  clk, 
    input wire                  rst_n, 

    input wire                  start_cnt, 
    
    input wire [WIDTH - 1 : 0]  data, 
    
    output reg                  count_done
);
    reg [1 : 0] state, next_state; 
    localparam IDLE = 2'b00; 
    localparam WAIT = 2'b01; 

    
    always @(state) begin 
        
    end 
endmodule

module control #(parameter WIDTH = 4)(
    input wire                  clk, 
    input wire                  rst_n,  

    input wire                  start, 

    input wire [WIDTH -1 : 0]   data, 

    input wire                  cnt_done, 

    output reg                  start_cnt, 
    
    output reg                  ack
);

    reg [1 : 0] state, next_state; 

    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01; 
    localparam WAIT = 2'b10;
    localparam STOP = 2'b11; 

    always @(state) begin
        next_state = state; 
        case (state)
            IDLE: 
                next_state = (start) ? LOAD : IDLE;
            LOAD: 
                next_state = WAIT; 
            WAIT: 
                next_state = (cnt_done) ? STOP : WAIT; 
            STOP: 
                next_state = IDLE; 
        endcase
    end 
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) 
            state <= IDLE; 
        else    
            state <= next_state; 
    end 

    always @(state) begin
        case (state)
            LOAD: 
                start_cnt = 1; 
            WAIT: 
                ack = 0;  
            STOP: 
                ack = 1;              
        endcase

    end

endmodule



