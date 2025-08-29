module RISCV_Single_Cycle(
    input wire      clk, 
    input wire      rst_n
);
    wire            PC_sel; 
    wire [2 : 0]    ImmSel; 
    wire            BrUn; 

    wire            ASel, BSel; 

    wire [3 : 0]    ALUSel; 
    wire            MemWriteEn;
    wire            RegWEn; 
    wire [1 : 0]    WBSel; 

    //Take the ALU result; 
    wire [31 : 0]   ALU_result;
    reg  [31 : 0]    PC; 
    wire [31 : 0]   PC_plus4;

    //PC counter section 
    assign PC_plus4 = PC + 32'd4; 
    wire  [31 : 0] PC_next; 
    assign PC_next =  (PC_sel) ? ALU_result : PC_plus4;
    
    always @(posedge clk or negedge rst_n) begin 
        if (~rst_n) begin 
            PC <= 0; 
        end 
        else begin 
            PC <= PC_next; 
        end
    end 



    //Instruction memory 
    wire [31 : 0]   Instruction; 
    wire [31 : 0]   Instruction_out_top; 
    assign Instruction_out_top = Instruction;
    instruction_memory IMEM_inst(
        .A(PC), 
        .RD(Instruction)
    );

    //Register file
    wire [31 : 0] data_to_register_file; 

    wire [31 : 0] DataA, DataB; //data from register file

    registers_file Reg_inst(
        .clk(clk), 
        .rst_n(rst_n),
        .data_in(data_to_register_file), 
        .RegWEn(RegWEn),
        .AddrD(Instruction [11 : 7]), 
        .AddrA(Instruction [19 : 15]), 
        .AddrB(Instruction [24 : 20]),

        .DataA(DataA), 
        .DataB(DataB)
    );

    reg BrEq, BrLt; 

    //branch comparator
    always @(BrUn, DataA, DataB) begin
        if (BrUn == 0) begin
            // unsigned compare
            BrEq = ($unsigned(DataA) == $unsigned(DataB));
            BrLt = ($unsigned(DataA) < $unsigned(DataB));
        end else begin
            // signed compare
            BrEq = ($signed(DataA) == $signed(DataB));
            BrLt = ($signed(DataA) <  $signed(DataB));
        end
    end

    //ALU
    ALU u_ALU(
        .A_sel(ASel), 
        .PC(PC), 
        .DataA(DataA), 

        .B_sel(BSel), 
        .DataB(DataB), 
        .Instr(Instruction[31 : 7]), 
        .ImmSel(ImmSel), 

        .ALUSel(ALUSel), 
        .ALU_res(ALU_result)
    );

    //Data memory 
    wire [31 : 0] memory_data ; 
    data_memory DMEM_inst(
        .clk(clk), 
        .funct3(Instruction[14 : 12]), 
        .Address(ALU_result),
        .WD(DataB), 
        .MemWriteEn(MemWriteEn), 
        .RD(memory_data)
    );

    //Writeback 
    localparam Data_mem = 2'b00;
    localparam ALU_result_WB = 2'b01; 
    localparam PC_plus = 2'b10;

    reg [31 : 0]    data_to_reg;
    always @(WBSel, memory_data, ALU_result, PC_plus4) begin

        case (WBSel)
            Data_mem:
                data_to_reg =  memory_data; //Data read from data mem 
            ALU_result_WB: 
                data_to_reg = ALU_result; // ALU result 
            PC_plus: 
                data_to_reg = PC_plus4;
            default: 
                data_to_reg = 32'b0; 
        endcase
    end  
    assign data_to_register_file = data_to_reg; 

    //control unit section 
    control_unit u_control_unit(
        .opcode(Instruction[6 : 2]), 
        .funct3(Instruction[14 : 12]), 
        .funct7_5(Instruction[30]),
        .BrEq(BrEq), 
        .BrLt(BrLt), 

        .PC_sel(PC_sel), 
        .ImmSel(ImmSel), 
        .BrUn(BrUn), 
        .ASel(ASel), 
        .BSel(BSel), 

        .ALUSel(ALUSel), 
        .MemWriteEn(MemWriteEn),
        .RegWEn(RegWEn), 
        .WBSel(WBSel)
    ); 

endmodule