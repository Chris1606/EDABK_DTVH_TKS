module ALU( 
    input wire [31 : 0]     srcA_E, // Data from source register A 

    //Src B 
    input wire [31 : 0]     srcB_E, 

    //ALU opcode 
    input wire [3 : 0]      ALU_SEL_E,
    output wire [31 : 0]    ALU_res
);  
    //ALU Opcode  

    localparam ADD  = 4'b0000; //add
    localparam SUB  = 4'b1000; //sub with funct 7 is 
    localparam AND  = 4'b0111;  // and
    localparam OR   = 4'b0110; //Or
    localparam XOR  = 4'b0100; // Xor
    localparam SLL  = 4'b0001; //Shift left logic 
    localparam SRL  = 4'b0101; //Shift right logic 
    localparam SRA  = 4'b1101; //Shift right Arrithmetic funct7 is 1
    localparam LT   = 4'b0010; // Lessthan 
    localparam LTU  = 4'b0011;  //Less than unsigned
    localparam ADD0 = 4'b1111;

    reg [31 : 0] ALU_result; // reg to store ALU 

    always @(ALU_SEL_E, srcA_E, srcB_E) begin 
        case (ALU_SEL_E) 
            ADD:    
                ALU_result = srcA_E + srcB_E; 
            ADD0: 
                ALU_result = 32'b0 + srcB_E;  
            SUB: 
                ALU_result = srcA_E - srcB_E; 
            AND: 
                ALU_result = srcA_E & srcB_E; 
            OR: 
                ALU_result = srcA_E | srcB_E; 
            XOR: 
                ALU_result = srcA_E ^ srcB_E; 
            SLL: 
                ALU_result = srcA_E << srcB_E [4 : 0];
            SRL: 
                ALU_result = srcA_E >> srcB_E [4 : 0];
            SRA: 
                ALU_result = $signed(srcA_E) >>> srcB_E [4 : 0];
            LT:
                ALU_result = ($signed(srcA_E) < $signed(srcB_E)) ? {{31{1'b0}}, 1'b1} : 32'b0; 
            LTU:
                ALU_result = ($unsigned(srcA_E) < $unsigned(srcB_E)) ? {{31{1'b0}}, 1'b1} : 32'b0; 
        endcase
    end

    assign ALU_res = ALU_result;

endmodule