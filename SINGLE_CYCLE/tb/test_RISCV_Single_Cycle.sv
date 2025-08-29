module test_RISCV_Single_Cycle;

    reg clk;
    reg rst_n;

    integer total_error;

parameter CLOCK_CYCLE = 2;

initial clk = 0;
always #(CLOCK_CYCLE/2) clk = ~clk;

    RISCV_Single_Cycle DUT(
        .clk(clk),
        .rst_n(rst_n)
    );

task reset_register_file();
    begin
        for (int i = 0; i < 32; i = i + 1) begin
            DUT.Reg_inst.registers[i] = 32'b0;
        end
    end
endtask

task reset_imem();
    begin
        for (int i = 0; i < 256; i = i + 1) begin
            DUT.IMEM_inst.memory[i] = 32'bx;
        end
    end
endtask

reg [31:0] golden_register_file [0:31];

task Prequesite_test();
    integer error_count;
    integer cycle;
    begin   

    //  TEST ADD_I INSTRUCTION
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        DUT.IMEM_inst.memory[0] = 32'h00a00013; //addi x0 x0 10
        DUT.IMEM_inst.memory[1] = 32'h00100093; //addi x1 x0 1
        DUT.IMEM_inst.memory[2] = 32'h00200113; //addi x2 x0 2
        DUT.IMEM_inst.memory[3] = 32'h00300193; //addi x3 x0 3
        DUT.IMEM_inst.memory[4] = 32'h00400213; //addi x4 x0 4
        DUT.IMEM_inst.memory[5] = 32'h00500293; //addi x5 x0 5
        DUT.IMEM_inst.memory[6] = 32'h00600313; //addi x6 x0 6
        DUT.IMEM_inst.memory[7] = 32'h00700393; //addi x7 x0 7
        DUT.IMEM_inst.memory[8] = 32'h00800413; //addi x8 x0 8
        DUT.IMEM_inst.memory[9] = 32'h00900493; //addi x9 x0 9
        DUT.IMEM_inst.memory[10] = 32'h00a00513; //addi x10 x0 10
        DUT.IMEM_inst.memory[11] = 32'h00b00593; //addi x11 x0 11
        DUT.IMEM_inst.memory[12] = 32'h00c00613; //addi x12 x0 12
        DUT.IMEM_inst.memory[13] = 32'h00d00693; //addi x13 x0 13
        DUT.IMEM_inst.memory[14] = 32'h00e00713; //addi x14 x0 14
        DUT.IMEM_inst.memory[15] = 32'h00f00793; //addi x15 x0 15
        DUT.IMEM_inst.memory[16] = 32'h01000813; //addi x16 x0 16
        DUT.IMEM_inst.memory[17] = 32'h01100893; //addi x17 x0 17
        DUT.IMEM_inst.memory[18] = 32'h01200913; //addi x18 x0 18
        DUT.IMEM_inst.memory[19] = 32'h01300993; //addi x19 x0 19
        DUT.IMEM_inst.memory[20] = 32'h01400a13; //addi x20 x0 20
        DUT.IMEM_inst.memory[21] = 32'h01500a93; //addi x21 x0 21
        DUT.IMEM_inst.memory[22] = 32'h01600b13; //addi x22 x0 22
        DUT.IMEM_inst.memory[23] = 32'h01700b93; //addi x23 x0 23
        DUT.IMEM_inst.memory[24] = 32'h01800c13; //addi x24 x0 24
        DUT.IMEM_inst.memory[25] = 32'h01900c93; //addi x25 x0 25
        DUT.IMEM_inst.memory[26] = 32'h01a00d13; //addi x26 x0 26
        DUT.IMEM_inst.memory[27] = 32'h01b00d93; //addi x27 x0 27
        DUT.IMEM_inst.memory[28] = 32'h01c00e13; //addi x28 x0 28
        DUT.IMEM_inst.memory[29] = 32'h01d00e93; //addi x29 x0 29
        DUT.IMEM_inst.memory[30] = 32'h01e00f13; //addi x30 x0 30
        DUT.IMEM_inst.memory[31] = 32'h01f00f93; //addi x31 x0 31

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 50) begin
                $display("Test ADD_I instruction failed! (Time out)");
                $finish;
            end
        end

        for(int i = 0; i < 32; i = i + 1) begin
            golden_register_file[i] = i;
        end

        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end
        if(error_count == 0) begin
            $display("Test ADD_I instruction passed!");
        end else begin
            $display("Test ADD_I instruction failed with %0d errors.", error_count);
        end
    //  DONE TEST ADD_I INSTRUCTION

    //  TEST LUI INSTRUCTION
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;

        DUT.IMEM_inst.memory[0] = 32'h0000a037; // lui x0 0xa
        DUT.IMEM_inst.memory[1] = 32'h000010b7; // lui x1 0x1
        DUT.IMEM_inst.memory[2] = 32'h00002137; // lui x2 0x2
        DUT.IMEM_inst.memory[3] = 32'h000031b7; // lui x3 0x3
        DUT.IMEM_inst.memory[4] = 32'h00004237; // lui x4 0x4
        DUT.IMEM_inst.memory[5] = 32'h000052b7; // lui x5 0x5
        DUT.IMEM_inst.memory[6] = 32'h00006337; // lui x6 0x6
        DUT.IMEM_inst.memory[7] = 32'h000073b7; // lui x7 0x7
        DUT.IMEM_inst.memory[8] = 32'h00008437; // lui x8 0x8
        DUT.IMEM_inst.memory[9] = 32'h000094b7; // lui x9 0x9
        DUT.IMEM_inst.memory[10] = 32'h0000a537; // lui x10 0xa
        DUT.IMEM_inst.memory[11] = 32'h0000b5b7; // lui x11 0xb
        DUT.IMEM_inst.memory[12] = 32'h0000c637; // lui x12 0xc
        DUT.IMEM_inst.memory[13] = 32'h0000d6b7; // lui x13 0xd
        DUT.IMEM_inst.memory[14] = 32'h0000e737; // lui x14 0xe
        DUT.IMEM_inst.memory[15] = 32'h0000f7b7; // lui x15 0xf
        DUT.IMEM_inst.memory[16] = 32'h00010837; // lui x16 0x10
        DUT.IMEM_inst.memory[17] = 32'h000118b7; // lui x17 0x11
        DUT.IMEM_inst.memory[18] = 32'h00012937; // lui x18 0x12
        DUT.IMEM_inst.memory[19] = 32'h000139b7; // lui x19 0x13
        DUT.IMEM_inst.memory[20] = 32'h00014a37; // lui x20 0x14
        DUT.IMEM_inst.memory[21] = 32'h00015ab7; // lui x21 0x15
        DUT.IMEM_inst.memory[22] = 32'h00016b37; // lui x22 0x16
        DUT.IMEM_inst.memory[23] = 32'h00017bb7; // lui x23 0x17
        DUT.IMEM_inst.memory[24] = 32'h00018c37; // lui x24 0x18
        DUT.IMEM_inst.memory[25] = 32'h00019cb7; // lui x25 0x19
        DUT.IMEM_inst.memory[26] = 32'h0001ad37; // lui x26 0x1a
        DUT.IMEM_inst.memory[27] = 32'h0001bdb7; // lui x27 0x1b
        DUT.IMEM_inst.memory[28] = 32'h0001ce37; // lui x28 0x1c
        DUT.IMEM_inst.memory[29] = 32'h0001deb7; // lui x29 0x1d
        DUT.IMEM_inst.memory[30] = 32'h0001ef37; // lui x30 0x1e
        DUT.IMEM_inst.memory[31] = 32'h0001ffb7; // lui x31 0x1f

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 50) begin
                $display("Test ADD_I instruction failed! (Time out)");
                $finish;
            end
        end

        for(int i = 0; i < 32; i = i + 1) begin
            golden_register_file[i] = i << 12;
        end

        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("Test LUI instruction passed!");
        end else begin
            $display("Test LUI instruction failed with %0d errors.", error_count);
        end

        if(error_count == 0) begin
            $display("%t Prequesite test (ADDI, LUI, register file) passed!", $time);
        end else begin
            $display("%t Prequesite test failed(ADDI, LUI, register file) with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end

        reset_register_file();
        reset_imem();

    end
endtask

task R_type_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/R-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting R-type instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test R-type instruction failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/R-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t R-type instruction test passed!", $time);
        end else begin
            $display("%t R-type instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task I_type_arithmetic_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/I-type(arithmetic&logic)/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting I-type arithmetic instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test I-type arithmetic & logic instruction failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/I-type(arithmetic&logic)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t I-type arithmetic instruction test passed!", $time);
        end else begin
            $display("%t I-type arithmetic instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task I_type_load_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/I-type(load)/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting I-type load instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test I-type load failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/I-type(load)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t I-type load instruction test passed!", $time);
        end else begin
            $display("%t I-type load instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task S_type_instruction();
    integer error_count;
    integer cycle;
    integer i;
    integer mem_data [0:63];
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/S-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting S-type instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test S-type failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/S-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        $readmemh("./Single_Cycle_test/S-type/golden_DMEM_hex.txt", mem_data);
        i = 0;
        while(DUT.DMEM_inst.memory[i] !== 32'hx) begin
            if (DUT.DMEM_inst.memory[i] !== mem_data[i]) begin
                $display("Mismatch at memory address %0d: DUT = %h, Golden = %h", i, DUT.DMEM_inst.memory[i], mem_data[i]);
                error_count = error_count + 1;
            end
            i = i + 1;
        end


        if(error_count == 0) begin
            $display("%t S-type instruction test passed!", $time);
        end else begin
            $display("%t S-type instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task JAL_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/J-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting JAL instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test JAL failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/J-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t JAL instruction test passed!", $time);
        end else begin
            $display("%t JAL instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task B_type_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/B-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting B-type instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test B-type failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/B-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t B-type instruction test passed!", $time);
        end else begin
            $display("%t B-type instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task JALR_instruction();    
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/I-type(JALR)/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting JALR instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test JALR failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/I-type(JALR)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t JALR instruction test passed!", $time);
        end else begin
            $display("%t JALR instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task U_type_instruction();
    integer error_count;
    integer cycle;
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Single_Cycle_test/U-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
        reset_register_file();
        $display("%t Starting U-type instruction test...", $time);

        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 100) begin
                $display("Test U-type failed! (Time out)");
                $finish;
            end
        end

        $readmemh("./Single_Cycle_test/U-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        if(error_count == 0) begin
            $display("%t U-type instruction test passed!", $time);
        end else begin
            $display("%t U-type instruction test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

initial begin
    total_error = 0;
    Prequesite_test();
    R_type_instruction();
    I_type_arithmetic_instruction();
    S_type_instruction(); // Prerequisite for I_type_load_instruction test
    I_type_load_instruction();
    JALR_instruction();
    JAL_instruction();
    B_type_instruction();
    U_type_instruction();
    $display("Total error count: %0d", total_error);

    if(total_error == 0)begin
        $display("\n");

        $display("@@@@@@@@@@   @@@@@@@    @@@@@@@@@  @@@@@@@@@        @@         @@");
        $display("@@      @@      @@      @@         @@                @@       @@ ");
        $display("@@      @@      @@      @@         @@                 @@     @@  ");
        $display("@@@@@@@@@@      @@      @@@@@@@@   @@        @@@@@@    @@   @@   ");
        $display("@@   @@         @@             @@  @@                   @@ @@    ");
        $display("@@    @@        @@             @@  @@                    @@@     ");
        $display("@@     @@    @@@@@@@    @@@@@@@@@  @@@@@@@@@              @      ");

        $display(" **********************************************");   
        $display(" *****************************                *");
        $display(" **                         **       |\__||    *");
        $display(" **   Congratulations !!    **      / O.O  |  *");
        $display(" **                         **    /_____   |  *");
        $display(" ** RV32I Simulation PASS!! **   /^ ^ ^ \\  |  *");
        $display(" **                         **  |^ ^ ^ ^ |w|  *");
        $display(" *****************************   \\m___m__|_|  *");
        $display(" **********************************************");   
    end
    else begin
        $display("\n");
        $display(" ****************************               ");
        $display(" **                        **       |\__||  ");
        $display(" **  OOPS!!                **      / X,X  | ");
        $display(" **                        **    /_____   | ");
        $display(" **  Simulation Failed!!   **   /^ ^ ^ \\  |");
        $display(" **                        **  |^ ^ ^ ^ |w| ");
        $display(" ****************************   \\m___m__|_|");
    end  
    $finish;
end

endmodule