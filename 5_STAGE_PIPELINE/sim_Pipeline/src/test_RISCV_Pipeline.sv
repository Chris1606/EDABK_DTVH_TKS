module test_RISCV_Pipeline;

    reg clk;
    reg rst_n;

    integer total_error;

parameter CLOCK_CYCLE = 2;

initial clk = 0;
always #(CLOCK_CYCLE/2) clk = ~clk;

    RISCV_5_Stage_PIPELINE DUT(
        .clk(clk),
        .rst_n(rst_n)
    );

task reset_register_file();
    begin
        for (int i = 1; i < 32; i = i + 1) begin
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

        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        for(int i = 0; i < 32; i = i + 1) begin
            golden_register_file[i] = i;
        end

        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                $display("  (ERROR: ADDI instruction: expected x%0d = x0 + %0d)", i, i);
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
                $display("Test LUI instruction failed! (Time out)");
                $finish;
            end
        end

        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        for(int i = 0; i < 32; i = i + 1) begin
            golden_register_file[i] = i << 12;
        end

        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                $display("  (ERROR: LUI instruction: expected x%0d = %0h)", i, i << 12);
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
        $readmemh("./Pipeline_test/R-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
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

        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/R-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                case (i)
                    5  : $display("  (ERROR: INIT of x5)");
                    6  : $display("  (ERROR: INIT of x6)");
                    7  : $display("  (ERROR: ADD  instruction: x7  = x5 + x6)");
                    8  : $display("  (ERROR: SUB  instruction: x8  = x5 - x6)");
                    9  : $display("  (ERROR: XOR  instruction: x9  = x5 ^ x6)");
                    10 : $display("  (ERROR: OR   instruction: x10 = x5 | x6)");
                    11 : $display("  (ERROR: AND  instruction: x11 = x5 & x6)");
                    12 : $display("  (ERROR: SLL  instruction: x12 = x5 << x6[4:0])");
                    13 : $display("  (ERROR: SRL  instruction: x13 = x5 >> x6[4:0])");
                    14 : $display("  (ERROR: SRA  instruction: x14 = $signed(x5) >>> x6[4:0])");
                    15 : $display("  (ERROR: SLT  instruction: signed compare)");
                    16 : $display("  (ERROR: SLTU instruction: unsigned compare)");
                    default: $display("  (Register not tied to an R-type result in this test)");
                endcase

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
        $readmemh("./Pipeline_test/I-type(arithmetic&logic)/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/I-type(arithmetic&logic)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);

                case (i)
                // INIT (Khoanh vùng nếu init sai)
                5  : $display("  (ERROR INIT x5 = 0x000000F0)");
                6  : $display("  (ERROR INIT x6 = 0x000000A0)");
                7  : $display("  (ERROR INIT x7 = 0x000000AB)");
                9  : $display("  (ERROR INIT x9 = 0x00000015)");
                10 : $display("  (ERROR INIT x10 = 0x000000F0)");
                11 : $display("  (ERROR INIT x11 = 0xFFFFFF80)");
                12 : $display("  (ERROR INIT x12 = 0x00000003)");
                13 : $display("  (ERROR INIT x13 = 0xFFFFFF80)");
                14 : $display("  (ERROR INIT x14 = 0xFFFFFFFB)");

                // Kết quả lệnh I arithmetic / (1) R-type SRA
                20 : $display("  (ERROR XORI  : x20 = x5  ^ 0x0FF)");
                21 : $display("  (ERROR ORI   : x21 = x6  | 0x00F)");
                22 : $display("  (ERROR ANDI  : x22 = x7  & 0x0F0)");
                23 : $display("  (ERROR SLLI  : x23 = x9  << 3)");
                24 : $display("  (ERROR SRLI  : x24 = x10 >> 3)");
                25 : $display("  (ERROR SRA   : x25 = $signed(x11) >>> x12)"); // R-type
                26 : $display("  (ERROR SRAI  : x26 = x13 >>> 3)");
                27 : $display("  (ERROR SLTI  : x27 = (signed)x14 < 10)");
                28 : $display("  (ERROR SLTIU : x28 = (unsigned)x14 < 10)");

                default: $display("  (Register not tied to an I-type arithmetic result in this test)");
                endcase

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
        $readmemh("./Pipeline_test/I-type(load)/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/I-type(load)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);

                unique case (i)
                // Khởi tạo / staging
                1  : $display("  (ERROR INIT base DMEM: x1 = 0x00000000)");
                2  : $display("  (ERROR STAGING x2: kiem tra chuoi SB/SH truoc khi LOAD)");
                // Kết quả LOADs
                10 : $display("  (ERROR LW)   lw  x10, 0(x1)   expect 0xA1B2C3D4");
                11 : $display("  (ERROR LB)   lb  x11, 0(x1)   expect 0xFFFFFFD4 (sign-extend)");
                12 : $display("  (ERROR LBU)  lbu x12, 0(x1)   expect 0x000000D4 (zero-extend)");
                13 : $display("  (ERROR LB)   lb  x13, 3(x1)   expect 0xFFFFFFA1");
                14 : $display("  (ERROR LBU)  lbu x14, 3(x1)   expect 0x000000A1");
                15 : $display("  (ERROR LH)   lh  x15, 4(x1)   expect 0xFFFF8001 (LE: [5:4]=80 01)");
                16 : $display("  (ERROR LHU)  lhu x16, 4(x1)   expect 0x00008001");
                17 : $display("  (ERROR LH)   lh  x17, 6(x1)   expect 0x00007F02 (LE: [7:6]=7F 02)");
                18 : $display("  (ERROR LHU)  lhu x18, 6(x1)   expect 0x00007F02");
                19 : $display("  (ERROR LW)   lw  x19, 8(x1)   expect 0x33221100");

                default: $display("  (Register not tied to a LOAD/STORE result in this test)");
                endcase
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
    integer mem_data [0:256];
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Pipeline_test/S-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/S-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                case (i)
                // INIT/STAGING (để khoanh vùng lỗi khởi tạo/toán hạng cho store)
                1  : $display("  (ERROR INIT base x1 = 0x00000000)");
                2  : $display("  (ERROR STAGING x2) SB chain @0..3  expected final x2 = 0x000000DD");
                3  : $display("  (ERROR STAGING x3) SH @4 (0x07E5) + SH @6 (0xFF80)  expected final x3 = 0xFFFFFF80");
                4  : $display("  (ERROR STAGING x4) SW @8 with 0x000007C3  expected final x4 = 0x000007C3");

                default: $display("  (Register not tied to an S-type staging result in this test)");
                endcase
                error_count = error_count + 1;
            end
        end

        $readmemh("./Pipeline_test/S-type/golden_DMEM_hex.txt", mem_data);
        i = 0;
        while((DUT.DMEM_inst.memory[i] !== 32'hx)) begin
            if (DUT.DMEM_inst.memory[i] !== mem_data[i]) begin
                $display("Mismatch at memory address %0d: DUT = %h, Golden = %h", i, DUT.DMEM_inst.memory[i], mem_data[i]);
                case (i)
                0 : $display("  (ERROR STORE @0..3) SB sequence  expect Dmem[0] = 0xDDCCBBAA (bytes: AA BB CC DD, little-endian)");
                1 : $display("  (ERROR STORE @4..7) SH 0x07E5 @4 + SH 0xFF80 @6  expect Dmem[1] = 0xFF8007E5 (bytes: E5 07 80 FF)");
                2 : $display("  (ERROR STORE @8..11) SW 0x000007C3 @8  expect Dmem[2] = 0x000007C3 (bytes: C3 07 00 00)");
                default: $display("  (ERROR DMEM padding) expect 0x00000000 for unused words");
                endcase

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
        $readmemh("./Pipeline_test/J-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/J-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                case (i)
                5  : $display("  (ERROR JAL link #1) jal x5, imm");
                6  : $display("  (ERROR JAL link #2) jal x6, imm");
                7  : $display("  (ERROR JAL link #3) jal x7, imm");
                10 : $display("  (ERROR MARK) x10 = 10 at ~0x00C0");
                default: $display("  (Register not tied to a JAL result in this test)");
                endcase
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
        $readmemh("./Pipeline_test/B-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        $display("Branch test cycle count: %0d", cycle);
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/B-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                case (i)
                // INIT (khoanh vùng nếu khởi tạo sai)
                2  : $display("  (ERROR INIT x2) expected final x2 = 0xFFFFFFFB after addi -10 (was 5)");
                3  : $display("  (ERROR INIT x3) expected x3 = 0x0000000A");

                // Kết quả BRANCH (cờ kết quả bạn ghi ra thanh ghi)
                20 : $display("  (ERROR BEQ ) beq  x2,x3 : 5 == 10 ? expected x20 = 0 (not taken)");
                21 : $display("  (ERROR BNE ) bne  x2,x3 : 5 != 10 ? expected x21 = 1 (taken)");
                22 : $display("  (ERROR BLT ) blt  x2,x3 (signed)   : -5 < 10  ? expected x22 = 1 (taken)");
                23 : $display("  (ERROR BGE ) bge  x3,x2 (signed)   : 10 >= -5 ? expected x23 = 1 (taken)");
                24 : $display("  (ERROR BLTU) bltu x2,x3 (unsigned) : 0xFFFFFFFB < 10 ? expected x24 = 0 (not taken)");
                25 : $display("  (ERROR BGEU) bgeu x2,x3 (unsigned) : 0xFFFFFFFB >= 10 ? expected x25 = 1 (taken)");

                default: $display("  (Register not tied to a BRANCH result in this test)");
                endcase
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
        $readmemh("./Pipeline_test/I-type(JALR)/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/I-type(JALR)/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                case (i)
                // INIT (khoanh vùng nếu init sai)
                1  : $display("  (ERROR INIT x1) expected x1 = 0x00000040 (base -> jalr #1)");
                2  : $display("  (ERROR INIT x2) expected x2 = 0x00000080 (base -> jalr #2)");
                3  : $display("  (ERROR INIT x3) expected x3 = 0x000000C1 (odd, test clear LSB via &~1)");

                // Link registers từ các lệnh JALR
                5  : $display("  (ERROR JALR link #1) x5 = pc+4 tại 0x0004; target = (x1+0)&~1 = 0x00000040");
                6  : $display("  (ERROR JALR link #2) x6 = pc+4 tại 0x0044; target = (x2+0)&~1 = 0x00000080");
                7  : $display("  (ERROR JALR link #3) x7 = pc+4 tại 0x0084; target = (x3-1)&~1 = 0x000000C0 (clear bit0)");

                // Marker tại đích cuối
                10 : $display("  (ERROR MARK) x10 = 10 tại 0x00C0  (finish )");

                default: $display("  (Register not tied to a JALR result in this test)");
                endcase
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
        $readmemh("./Pipeline_test/U-type/IMEM_hex.txt", DUT.IMEM_inst.memory);
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
        for(int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/U-type/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                unique case (i)
                // LUI
                5  : $display("  (ERROR LUI  ) x5 = imm<<12 = 0x00001<<12 -> 0x00001000");
                6  : $display("  (ERROR LUI  ) x6 = imm<<12 = 0xABCDE<<12 -> 0xABCDE000");

                // AUIPC: x[rd] = PC + (imm<<12)
                7  : $display("  (ERROR AUIPC) x7 = 0x00000008 + 0x00001000 -> 0x00001008");
                8  : $display("  (ERROR AUIPC) x8 = 0x0000000C + 0x00002000 -> 0x0000200C");
                9  : $display("  (ERROR AUIPC) x9 = 0x00000010 + 0x12345000 -> 0x12345010");

                default: $display("  (Register not tied to LUI/AUIPC in this test)");
                endcase
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

task Random_program();
    integer error_count;
    integer cycle;
    integer i;
    integer mem_data [0:256];
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Pipeline_test/Random_program/IMEM_hex.txt", DUT.IMEM_inst.memory);
        $readmemh("./Pipeline_test/Random_program/input_DMEM_hex.txt", DUT.DMEM_inst.memory);
        reset_register_file();
        $display("%t Starting Random_program test...", $time);



        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 1000) begin
                $display("Test Random_program failed! (Time out)");
                break;
            end
        end
        for(int j = 0; j < 5; j = j + 1) begin
            @(posedge clk);
        end

        $readmemh("./Pipeline_test/Random_program/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        $readmemh("./Pipeline_test/Random_program/golden_DMEM_hex.txt", mem_data);
        i = 0;
        while((DUT.DMEM_inst.memory[i] !== 32'hx) | ((mem_data[i]!== 0))) begin
            if (DUT.DMEM_inst.memory[i] !== mem_data[i]) begin
                $display("Mismatch at memory address %0d: DUT = %h, Golden = %h", i, DUT.DMEM_inst.memory[i], mem_data[i]);
                error_count = error_count + 1;
            end
            i = i + 1;
        end

        if(error_count == 0) begin
            $display("%t Random_program test passed!", $time);
        end else begin
            $display("%t Random_program test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

task Full_Hazard_test();
    integer error_count;
    integer cycle;
    integer i;
    integer mem_data [0:256];
    begin
        error_count = 0;
        cycle = 1;
        rst_n = 0;
        #(CLOCK_CYCLE);
        @(negedge clk) rst_n = 1;
        $readmemh("./Pipeline_test/Full_Hazard/IMEM_hex.txt", DUT.IMEM_inst.memory);
        $readmemh("./Pipeline_test/Full_Hazard/input_DMEM_hex.txt", DUT.DMEM_inst.memory);

        for(int j = 0; j < 5; j = j + 1) begin
            $display("DMEM initial[%0d] = %h", j, DUT.DMEM_inst.memory[j]);
        end

        reset_register_file();
        $display("%t Starting Full_Hazard test...", $time);



        wait(DUT.Instruction_out_top !== 32'hx);
        @(posedge clk);
        while(DUT.Instruction_out_top !== 32'hx) begin
            cycle = cycle + 1;
            #(CLOCK_CYCLE/2);
            @(negedge clk) if(DUT.Instruction_out_top === 32'hx) break;
            #(CLOCK_CYCLE/2);
            if(cycle > 1000) begin
                $display("Test Full_Hazard program failed! (Time out)");
                break;
            end
        end
        for(int j = 0; j < 5; j = j + 1) begin
            @(posedge clk);
            cycle = cycle + 1;
        end
        $display("Total cycle count: %0d", cycle);

        $readmemh("./Pipeline_test/Full_Hazard/golden_register_file_hex.txt", golden_register_file);
        for (int i = 0; i < 32; i = i + 1) begin
            if (DUT.Reg_inst.registers[i] !== golden_register_file[i]) begin
                $display("Mismatch at register x%0d: DUT = %h, Golden = %h", i, DUT.Reg_inst.registers[i], golden_register_file[i]);
                error_count = error_count + 1;
            end
        end

        $readmemh("./Pipeline_test/Full_Hazard/golden_DMEM_hex.txt", mem_data);
        i = 0;
        while((DUT.DMEM_inst.memory[i] !== 32'hx)) begin
            if (DUT.DMEM_inst.memory[i] !== mem_data[i]) begin
                $display("Mismatch at memory address %0d: DUT = %h, Golden = %h", i, DUT.DMEM_inst.memory[i], mem_data[i]);
                error_count = error_count + 1;
            end
            i = i + 1;
        end

        if(error_count == 0) begin
            $display("%t Full_Hazard test passed!", $time);
        end else begin
            $display("%t Full_Hazard test failed with %0d errors.",$time, error_count);
            total_error = total_error + error_count;
        end
        reset_register_file();
        reset_imem();
        // $finish; 
    end
endtask

initial begin
    total_error = 0;
    Prequesite_test(); // PASS
    R_type_instruction(); // PASS
    I_type_arithmetic_instruction(); // PASS
    S_type_instruction(); // Prerequisite for I_type_load_instruction test // PASS
    I_type_load_instruction(); // PASS
    JAL_instruction(); // PASS

    U_type_instruction(); // PASS

    B_type_instruction(); //Pass 
    JALR_instruction(); // 
    Random_program(); 
    Full_Hazard_test();

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