module control_unit (
    // Instruction: Ins [30, 14 : 12, 6 : 2]
    input wire [4 : 0]      opcode, 
    input wire [2 : 0]      funct3,
    input wire              funct7_5,        
    input wire              BrEq, 
    input wire              BrLt,

    // input wire              ready, 
    // output wire             read

    output reg             PC_sel, 
    output reg [2 : 0]     ImmSel, 

    output reg             BrUn, 
    
    output reg             ASel, //1 : Pc for address, 0: data for math
    output reg             BSel, 

    output reg [3 : 0]     ALUSel, 
    output reg             MemWriteEn, 
    output reg             RegWEn, 
    output reg [1 : 0]     WBSel    

);
    //opcode of instruction from bit 2 to bit 6
    localparam R_opcode         = 5'b0_1100;
    localparam I_math_opcode    = 5'b0_0100;
    localparam I_load_opcode    = 5'b0_0000;
    localparam S_opcode         = 5'b0_1000;
    localparam B_opcode         = 5'b1_1000;
    localparam J_opcode         = 5'b1_1011;
    localparam JALR_opcode      = 5'b1_1001;
    localparam LUI_opcode       = 5'b0_1101;
    localparam AUIPC_opcode       = 5'b0_0101;


    localparam ALU_ADD  = 4'b0000; //add
    localparam ALU_SUB  = 4'b1000; //sub with funct 7 is 
    localparam ALU_AND  = 4'b0111;  // and
    localparam ALU_OR   = 4'b0110; //Or
    localparam ALU_XOR  = 4'b0100; // Xor
    localparam ALU_SLL  = 4'b0001; //Shift left logic 
    localparam ALU_SRL  = 4'b0101; //Shift right logic 
    localparam ALU_SRA  = 4'b1101; //Shift right Arrithmetic funct7 is 1
    localparam ALU_LT   = 4'b0010; // Lessthan 
    localparam ALU_LTU  = 4'b0011;  //Less than unsigned
    localparam ALU_ADD0 = 4'b1111;


    // In the DMem controller
    localparam Data_mem = 2'b00;
    localparam ALU_result = 2'b01; 
    localparam PC_plus = 2'b10;

    //BranchUn Unsigned and Signed
    localparam Unsigned = 1'b0;
    localparam Signed   = 1'b1; 

    // always @(opcode, funct3, funct7_5) begin 
    always @(*) begin        
        case(opcode)
            R_opcode: 
            begin 
                case (funct3) 
                    3'b000:
                    begin 
                        if (funct7_5) begin
                            //sub rd, rs1, rs3 
                            PC_sel = 0; 
                            ImmSel = 3'b0; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b0; 
                            ALUSel = ALU_SUB; 
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result;
                        end 
                        else begin 
                            //add rd, rs1, rs2
                            PC_sel = 0; 
                            ImmSel = 3'b0; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b0; 
                            ALUSel = ALU_ADD; 
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result;
                        end 
                    end
                    3'b100:
                    begin 
                        //xor rd, rs1, rs4
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_XOR;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end  
                    3'b110: 
                    begin 
                        //or rd, rs1, rs5
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_OR;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end  
                    3'b111:
                    begin 
                        //and rd, rs1, rs6
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_AND;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end   
                    3'b001:
                    begin
                        //sll rd, rs1, rs7 
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_SLL;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end  
                    3'b101:
                    begin 
                        if (funct7_5) begin 
                        //sra rd, rs1, rs9
                            PC_sel = 0; 
                            ImmSel = 3'b0; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b0; 
                            ALUSel = ALU_SRA;
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result; 
                        end 
                        else begin 
                        //srl rd, rs1, rs8
                            PC_sel = 0; 
                            ImmSel = 3'b0; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b0; 
                            ALUSel = ALU_SRL;
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result;
                             
                        end 
                    end

                    3'b010:
                    begin 
                        //slt rd,rs1,rs2
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_LT;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end
                    3'b011:
                    begin 
                        //sltu rd,rs1,rs2
                        PC_sel = 0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = ALU_LTU;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end
                    default:
                    begin 
                        PC_sel = 1'b0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = 4'b0;
                        MemWriteEn = 1'b0; 
                        WBSel  = 2'b0;
                    end
                endcase
            end 
            I_math_opcode: 
            begin 
                case (funct3) 
                    3'b000:
                    begin 
                        //addi rd, rs1, imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b100:
                    begin 
                        //Xor rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_XOR;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b110:
                    begin 
                        //Ori rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_OR;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b111:
                    begin 
                        //andi rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_AND;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b001:
                    begin 
                        //sll rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_SLL;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b101:
                    begin 
                        if (funct7_5) begin 
                            //srai rd,rs1,imm
                            PC_sel = 0; 
                            ImmSel = 3'b000; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b1; //select immediate 
                            ALUSel = ALU_SRA;
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result;
                        end 
                        else begin 
                            //srli rd,rs1,imm
                            PC_sel = 0; 
                            ImmSel = 3'b000; 
                            RegWEn = 1'b1; 
                            BrUn   = 1'b0; 
                            ASel  = 1'b0; 
                            BSel  = 1'b1; //select immediate 
                            ALUSel = ALU_SRL;
                            MemWriteEn = 1'b0; 
                            WBSel  = ALU_result;
                        end 
                    end
                    3'b010:
                    begin 
                        //slti rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_LT;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end 
                    3'b011:
                    begin 
                        //slti rd,rs1,imm
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_LTU;
                        MemWriteEn = 1'b0; 
                        WBSel  = ALU_result;
                    end
                    default: 
                    begin
                        PC_sel = 1'b0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = 4'b0;
                        MemWriteEn = 1'b0; 
                        WBSel  = 2'b0; 
                    end  
                endcase
            end 
            I_load_opcode: 
            begin 
                case (funct3)
                    3'b000:
                    begin 
                        //lb rd, offset(rs1)
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = Data_mem;
                    end
                    3'b001: 
                    begin
                        //lh rd, offset(rs1)
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = Data_mem;
                    end
                    3'b010: begin
                        //lw rd, offset(rs1)
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = Data_mem;
                    end 
                    3'b100: begin 
                        //lbu rd, offset(rs1)
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = Data_mem;                        
                    end 
                    3'b101: 
                    begin 
                        //lhu rd, offset(rs1)
                        PC_sel = 0; 
                        ImmSel = 3'b000; 
                        RegWEn = 1'b1; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; //select immediate 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0; 
                        WBSel  = Data_mem;
                    end
                    default: 
                    begin 
                        PC_sel = 1'b0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = 4'b0;
                        MemWriteEn = 1'b0; 
                        WBSel  = 2'b0;                        
                    end  
                endcase
            end
            S_opcode:
            begin
                case (funct3) 
                    3'b000:
                    begin
                        // /sb rs2, offset(rs1) 
                        PC_sel = 1'b0; 
                        ImmSel = 3'b001; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b1; 
                        WBSel  = 2'b0;                        
                    end 
                    3'b001:
                    begin 
                        //sh rs2, offset(rs1)
                        PC_sel = 1'b0; 
                        ImmSel = 3'b001; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b1; 
                        WBSel  = 2'b0;                               
                    end
                    3'b010:
                    begin 
                        //sh rs2, offset(rs1)
                        PC_sel = 1'b0; 
                        ImmSel = 3'b001; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b1; 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b1; 
                        WBSel  = 2'b0;                               
                    end                        
                    default:
                    begin
                        PC_sel = 1'b0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = 4'b0;
                        MemWriteEn = 1'b0; 
                        WBSel  = 2'b0;   
                    end

                endcase
            end 

            B_opcode:
            begin
                case (funct3)
                    3'b000:
                    begin 
                        //beq rs1, rs2, offset
                        BrUn = Signed;
                        ImmSel = 3'b010;
                        ASel = 1'b1;
                        BSel = 1'b1;
                        RegWEn = 1'b0; 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrEq) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end
                    3'b001:
                    begin 
                        //bne rs1, rs2, offset
                        BrUn = Signed;
                        ImmSel = 3'b010;
                        ASel = 1'b1;
                        BSel = 1'b1;
                        RegWEn = 1'b0; 
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrEq == 0 ) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end
                    3'b100:
                    begin 
                        //blt rs1, rs2, offset
                        BrUn = Signed;
                        ImmSel = 3'b010;
                        RegWEn = 1'b0; 
                        ASel = 1'b1;
                        BSel = 1'b1;
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrLt) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end                        
                    3'b101:
                    begin 
                        //bge rs1, rs2, offset
                        BrUn = Signed;
                        ImmSel = 3'b010;
                        RegWEn = 1'b0; 
                        ASel = 1'b1;
                        BSel = 1'b1;
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrLt == 0) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end                     
                    3'b110: 
                    begin 
                        //bltu rs1, rs2, offset
                        BrUn = Unsigned;
                        ImmSel = 3'b010;
                        RegWEn = 1'b0; 
                        ASel = 1'b1; // PC
                        BSel = 1'b1; // Immediate
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrLt) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end                     
                    
                    3'b111: 
                    begin 
                        //bltu rs1, rs2, offset
                        BrUn = Unsigned;
                        ImmSel = 3'b010;
                        RegWEn = 1'b0; 
                        ASel = 1'b1; // PC
                        BSel = 1'b1; // Immediate
                        ALUSel = ALU_ADD;
                        MemWriteEn = 1'b0;
                        WBSel = 2'b00; 

                        if (BrLt == 0) 
                            PC_sel = 1'b1;
                        else    
                            PC_sel = 1'b0;  
                    end   
                    default:  
                    begin
                        PC_sel = 1'b0; 
                        ImmSel = 3'b0; 
                        RegWEn = 1'b0; 
                        BrUn   = 1'b0; 
                        ASel  = 1'b0; 
                        BSel  = 1'b0; 
                        ALUSel = 4'b0;
                        MemWriteEn = 1'b0; 
                        WBSel  = 2'b0;   
                    end
                endcase  
            end  
            J_opcode:
            //jal, rd, offset
            begin
                PC_sel = 1'b1;  
                ImmSel = 3'b011; 
                RegWEn = 1'b1;
                BrUn = 1'b0; 
                ASel = 1'b1; //PC
                BSel = 1'b1; //Immediate 
                ALUSel = ALU_ADD; 
                MemWriteEn = 1'b0;  
                WBSel = PC_plus; 
            end 
            JALR_opcode:
            begin 
                if (funct3 == 3'b000) begin 
                    //jalr rd,rs1,offset
                    PC_sel = 1'b1; 
                    ImmSel = 3'b000; //I Type
                    RegWEn = 1'b1;
                    BrUn = 1'b0; 
                    ASel = 1'b0; //Rs1
                    BSel = 1'b1; //Immediate 
                    ALUSel = ALU_ADD; 
                    MemWriteEn = 1'b0;  
                    WBSel = PC_plus; 
                end 
                else begin 
                    PC_sel = 1'b1;
                    ImmSel = 3'b000; 
                    RegWEn = 1'b0;
                    BrUn = 1'b0; 
                    ASel = 1'b0; 
                    BSel = 1'b0;
                    ALUSel = ALU_ADD; 
                    MemWriteEn = 1'b0;  
                    WBSel = 3'b000; 
                end
            end 
            LUI_opcode:
                //lui rd,imm
            begin 
                PC_sel = 1'b0;
                ImmSel = 3'b100; 
                RegWEn = 1'b1;
                BrUn = 1'b0; 
                ASel = 1'b0; // Make it to zero 
                BSel = 1'b1;
                ALUSel = ALU_ADD0; 
                MemWriteEn = 1'b0;  
                WBSel = ALU_result;
            end 
            AUIPC_opcode: 
            begin 
                //auipc rd,imm
                PC_sel = 1'b0;
                ImmSel = 3'b100; 
                RegWEn = 1'b1;
                BrUn = 1'b0; 
                ASel = 1'b1; // PC_source
                BSel = 1'b1; //Immediate
                ALUSel = ALU_ADD; 
                MemWriteEn = 1'b0;  
                WBSel = ALU_result;
            end
            default: 
            begin 
                PC_sel = 1'b0;
                ImmSel = 3'b000; 
                RegWEn = 1'b0;
                BrUn = 1'b0; 
                ASel = 1'b0; // PC_source
                BSel = 1'b0;
                ALUSel = 3'b000; 
                MemWriteEn = 1'b0;  
                WBSel = 3'b000;
            end 
        endcase
    end  
endmodule