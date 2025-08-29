module ALU( 
    //Src A 
    input wire              A_sel,
    input wire [31 : 0]     PC, // Take the PC address
    input wire [31 : 0]     DataA, // Data from source register A 

    //Src B
    input wire              B_sel, 
    input wire [31 : 0]     DataB, 

    //ALU opcode 
    input wire [3 : 0]      ALUSel, 

    input wire [31 : 7]     Instr, 
    input wire [2 : 0]      ImmSel, 


    output wire [31 : 0]     ALU_res
);  
    reg [31 : 0] Immext;

    localparam I_type = 3'b000; 
    localparam S_type = 3'b001; 
    localparam B_type = 3'b010; 
    localparam J_type = 3'b011; 
    localparam U_type = 3'b100; 

    always @(ImmSel, Instr) begin 
        case (ImmSel) 
            I_type:
                Immext = {{20{Instr[31]}}, Instr[31 : 20]};  
            S_type:
                Immext = {{20{Instr[31]}}, Instr[31 : 25], Instr[11 : 7]};   
            B_type:
                Immext = {{20{Instr[31]}}, Instr[7], Instr[30 : 25], Instr[11 : 8], 1'b0};
            J_type:
                Immext = {{12{Instr[31]}}, Instr[19 : 12], Instr[20], Instr[30 : 21], 1'b0};
            U_type:
                Immext = {Instr[31 : 12], 12'b0};
            default:  
                Immext = {{20{Instr[31]}}, Instr[31 : 20]}; 
        endcase
    end 


    wire [31 : 0] srcA;
    wire [31 : 0] srcB;
    


    assign srcA = (A_sel == 1'b1) ? PC : DataA; 
    assign srcB = (B_sel == 1'b1) ? Immext : DataB;

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

    always @(ALUSel, srcA, srcB) begin 
        case (ALUSel) 
            ADD:    
                ALU_result = srcA + srcB; 
            ADD0: 
                ALU_result = 32'b0 + srcB;  
            SUB: 
                ALU_result = srcA - srcB; 
            AND: 
                ALU_result = srcA & srcB; 
            OR: 
                ALU_result = srcA | srcB; 
            XOR: 
                ALU_result = srcA ^ srcB; 
            SLL:    
                ALU_result = srcA << srcB [4 : 0];
            SRL: 
                ALU_result = srcA >> srcB [4 : 0];
            SRA: 
                ALU_result = $signed(srcA) >>> srcB [4 : 0];
            LT:
                ALU_result = ($signed(srcA) < $signed(srcB)) ? {{31{1'b0}}, 1'b1} : 32'b0; 
            LTU:
                ALU_result = ($unsigned(srcA) < $unsigned(srcB)) ? {{31{1'b0}}, 1'b1} : 32'b0; 
        endcase
    end

    assign ALU_res = ALU_result;

endmodule