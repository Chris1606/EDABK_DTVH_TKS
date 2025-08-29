`timescale 1ns/1ps

module tb_single_cycle_Rtype();
  parameter PERIOD = 10;

  reg clk;
  reg rst_n;

  // Clock
  initial clk = 0;
  always #(PERIOD/2) clk = ~clk;

  // DUT
  top_single_cycle uut(
      .clk(clk),
      .rst_n(rst_n)
  );

  // VCD (tùy chọn)
  initial begin
    $dumpfile("single_cycle.vcd");
    $dumpvars(0, tb_single_cycle);
  end

  // --- Monitor ---
  wire [31:0] PC      = uut.PC;
  wire [31:0] Instr   = uut.Instruction;
  wire [31:0] ALU_res = uut.ALU_result;

  // Đọc RF & DMEM (đổi đường dẫn nếu khác)
  function [31:0] reg_read;
    input [4:0] r;
    begin reg_read = uut.u_register_file.RF[r]; end
  endfunction

  // -------- Golden helpers --------
  function [31:0] g_add;  input [31:0] a,b; begin g_add  = a + b; end endfunction
  function [31:0] g_sub;  input [31:32] a,b; begin g_sub  = a - b; end endfunction
  function [31:0] g_xor;  input [31:0] a,b; begin g_xor  = a ^ b; end endfunction
  function [31:0] g_or ;  input [31:0] a,b; begin g_or   = a | b; end endfunction
  function [31:0] g_and;  input [31:0] a,b; begin g_and  = a & b; end endfunction
  function [31:0] g_sll;  input [31:0] a,b; begin g_sll  = a <<  b[4:0]; end endfunction
  function [31:0] g_srl;  input [31:0] a,b; begin g_srl  = a >>  b[4:0]; end endfunction
  function [31:0] g_slt;  input signed [31:0] a,b; begin g_slt  = (a < b) ? 32'd1 : 32'd0; end endfunction
  function [31:0] g_sltu; input [31:0] a,b; begin g_sltu = (a < b) ? 32'd1 : 32'd0; end endfunction
  function [31:0] g_sra;  input signed [31:0] a; input [31:0] b; begin g_sra = a >>> b[4:0]; end endfunction

  // Bước + kiểm PC + kiểm RF[rd]
  task step_and_check_pc_rf;
    input [4:0]  rd;
    input [31:0] expected;
    input [31:0] prev_pc;
    begin
      @(posedge clk); #1; // kết thúc 1 chu kỳ
      // PC_next = PC_prev + 4
      if (PC !== (prev_pc + 32'd4))
        $fatal(1, "FAIL PC: PC_cur=%08h, PC_prev+4=%08h", PC, prev_pc + 32'd4);
      // Kiểm RF[rd] (trừ x0)
      if (rd != 5'd0 && reg_read(rd) !== expected)
        $fatal(1, "FAIL RF[x%0d]: got=%08h, expect=%08h", rd, reg_read(rd), expected);
      $display("PASS @PC=%08h: x%0d == %08h", prev_pc, rd, expected);
    end
  endtask

  // Địa chỉ PC theo thứ tự lệnh trong file (bắt đầu từ 0)
  localparam PC0  = 32'h0000_0000; // addi x2,10
  localparam PC1  = 32'h0000_0004; // addi x1,10
  localparam PC2  = 32'h0000_0008; // add
  localparam PC3  = 32'h0000_000C; // sub
  localparam PC4  = 32'h0000_0010; // xor
  localparam PC5  = 32'h0000_0014; // or
  localparam PC6  = 32'h0000_0018; // and
  localparam PC7  = 32'h0000_001C; // sll
  localparam PC8  = 32'h0000_0020; // srl
  localparam PC9  = 32'h0000_0024; // slt
  localparam PC10 = 32'h0000_0028; // sltu
  localparam PC11 = 32'h0000_002C; // sra

  // Main
  initial begin
    $display("===========================");
    $display(" Start R-type golden test ");
    $display("===========================");

    // Reset
    rst_n = 0;
    #(3*PERIOD);
    rst_n = 1;

    // === Lệnh 0: addi x2, x0, 10 ===
    step_and_check_pc_rf(5'd2, 32'd10, PC0);

    // === Lệnh 1: addi x1, x0, 10 ===
    step_and_check_pc_rf(5'd1, 32'd10, PC1);

    // Lấy rs1, rs2 cho các R-type còn lại
    // (Sau 2 addi, x1=10, x2=10)
    // Mỗi bước sẽ đọc giá trị hiện tại để tính expected.
    // === Lệnh 2: add x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_add (reg_read(1), reg_read(2)), PC2);

    // === Lệnh 3: sub x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_sub (reg_read(1), reg_read(2)), PC3);

    // === Lệnh 4: xor x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_xor (reg_read(1), reg_read(2)), PC4);

    // === Lệnh 5: or x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_or  (reg_read(1), reg_read(2)), PC5);

    // === Lệnh 6: and x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_and (reg_read(1), reg_read(2)), PC6);

    // === Lệnh 7: sll x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_sll (reg_read(1), reg_read(2)), PC7);

    // === Lệnh 8: srl x3, x1, x2 ===
    step_and_check_pc_rf(5'd3, g_srl (reg_read(1), reg_read(2)), PC8);

    // === Lệnh 9: slt x3, x1, x2 === (signed)
    step_and_check_pc_rf(5'd3, g_slt (reg_read(1), reg_read(2)), PC9);

    // === Lệnh 10: sltu x3, x1, x2 === (unsigned)
    step_and_check_pc_rf(5'd3, g_sltu(reg_read(1), reg_read(2)), PC10);

    // === Lệnh 11: sra x3, x1, x2 === (arithmetic)
    step_and_check_pc_rf(5'd3, g_sra (reg_read(1), reg_read(2)), PC11);

    $display("=== R-type Test PASS ===");
    $finish;
  end

endmodule


module tb_single_cycle_itype;
  parameter PERIOD = 10;

  reg clk;
  reg rst_n;

  // Clock
  initial clk = 0;
  always #(PERIOD/2) clk = ~clk;

  // DUT
  top_single_cycle uut(
    .clk(clk),
    .rst_n(rst_n)
  );

  // VCD (tùy chọn)
  initial begin
    $dumpfile("single_cycle_itype.vcd");
    $dumpvars(0, tb_single_cycle_itype);
  end
    reg [31:0] pc_prev;
    reg [31:0] instr_prev;
    reg [31:0] rs1_val, imm_se, imm_ze;
    reg [4:0]  shamt;
  // ====== Monitor nhanh ======
  wire [31:0] PC    = uut.PC;
  wire [31:0] Instr = uut.Instruction;

  // ====== Truy cập hierarchical ======
  function [31:0] reg_read;
    input [4:0] r;
    begin
      reg_read = uut.u_register_file.RF[r];
    end
  endfunction

  function [31:0] get_instr_at_pc;
    input [31:0] pc;
    begin
      get_instr_at_pc = uut.u_instruction_memory.I_MEM_BLOCK[pc[31:2]];
    end
  endfunction

  // ====== Helpers: imm & golden ======
  // imm12 sign-extend
  function [31:0] sext12;
    input [11:0] imm12;
    begin
      sext12 = {{20{imm12[11]}}, imm12};
    end
  endfunction

  // imm12 zero-extend (dùng cho sltiu theo golden bạn yêu cầu)
  function [31:0] zext12;
    input [11:0] imm12;
    begin
      zext12 = {20'b0, imm12};
    end
  endfunction

  // Lấy imm12 từ instruction I-type
  function [11:0] imm12_from_instr;
    input [31:0] instr;
    begin
      imm12_from_instr = instr[31:20];
    end
  endfunction

  // Lấy shamt (5 bit thấp) từ instruction shift-immediate
  function [4:0] shamt5_from_instr;
    input [31:0] instr;
    begin
      shamt5_from_instr = instr[24:20];
    end
  endfunction

  // ====== Bước + kiểm PC + kiểm RF[rd] ======
  task step_and_check;
    input [4:0]  rd;
    input [31:0] expected;
    input [31:0] prev_pc;
    begin
      @(posedge clk); #1; // kết thúc 1 chu kỳ thực thi
      // PC_next = PC_prev + 4
      if (PC !== (prev_pc + 32'd4))
        $fatal(1, "FAIL PC: curr=%08h, prev+4=%08h", PC, prev_pc + 32'd4);

      // Kiểm RF[rd] (x0 bỏ qua)
      if (rd != 5'd0 && reg_read(rd) !== expected)
        $fatal(1, "FAIL RF[x%0d] @PC=%08h: got=%08h, exp=%08h",
               rd, prev_pc, reg_read(rd), expected);

      $display("PASS @PC=%08h: x%0d == %08h", prev_pc, rd, expected);
    end
  endtask

  // ====== Địa chỉ PC của từng lệnh (bắt đầu từ 0x00) ======
  localparam PC0  = 32'h0000_0000; // addi  x3, x1, 5
  localparam PC1  = 32'h0000_0004; // xori  x3, x1, 0x0F0
  localparam PC2  = 32'h0000_0008; // ori   x3, x1, 0x0F0
  localparam PC3  = 32'h0000_000C; // andi  x3, x1, 0x0F0
  localparam PC4  = 32'h0000_0010; // slli  x3, x1, 3
  localparam PC5  = 32'h0000_0014; // srli  x3, x1, 3
  localparam PC6  = 32'h0000_0018; // srai  x3, x1, 3
  localparam PC7  = 32'h0000_001C; // slti  x3, x1, -1
  localparam PC8  = 32'h0000_0020; // sltiu x3, x1, 0x0FF
  localparam PC9  = 32'h0000_0024; // addi  x1, x0, 0

  // ====== Khởi tạo RF & DMEM để tránh X ======
  task init_rf_and_mem;
    integer i;
    begin
      for (i = 0; i < 32; i = i + 1)
        uut.u_register_file.RF[i] = 32'b0;

      for (i = 0; i < 64; i = i + 1)
        uut.u_data_memory.data_memory_reg[i] = 32'b0;

      // (Tuỳ chọn) đặt x1 giá trị ban đầu nếu muốn — hiện để 0 cho sạch wave
      // uut.u_register_file.RF[1] = 32'h12345678;
    end
  endtask

  // ====== Main ======
  initial begin


    $display("===== I-type Golden Test Start =====");

    // Reset
    rst_n = 0;
    #(3*PERIOD);
    rst_n = 1;

    // Zero hóa RF/DMEM để tránh X
    init_rf_and_mem();

    // ---------- Lệnh 0: addi x3, x1, imm ----------
    pc_prev    = PC0;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_se     = sext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, rs1_val + imm_se, pc_prev); // x[rd] = x[rs1] + sext(imm)

    // ---------- Lệnh 1: xori x3, x1, imm ----------
    pc_prev    = PC1;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_se     = sext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, rs1_val ^ imm_se, pc_prev); // x[rd] = x[rs1] ^ sext(imm)

    // ---------- Lệnh 2: ori x3, x1, imm ----------
    pc_prev    = PC2;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_se     = sext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, rs1_val | imm_se, pc_prev); // x[rd] = x[rs1] | sext(imm)

    // ---------- Lệnh 3: andi x3, x1, imm ----------
    pc_prev    = PC3;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_se     = sext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, rs1_val & imm_se, pc_prev); // x[rd] = x[rs1] & sext(imm)

    // ---------- Lệnh 4: slli x3, x1, shamt ----------
    pc_prev    = PC4;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    shamt      = shamt5_from_instr(instr_prev);
    step_and_check(5'd3, rs1_val << shamt, pc_prev); // x[rd] = x[rs1] << imm[4:0]

    // ---------- Lệnh 5: srli x3, x1, shamt ----------
    pc_prev    = PC5;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    shamt      = shamt5_from_instr(instr_prev);
    step_and_check(5'd3, rs1_val >> shamt, pc_prev); // x[rd] = x[rs1] >> imm[4:0] (logical)

    // ---------- Lệnh 6: srai x3, x1, shamt ----------
    pc_prev    = PC6;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    shamt      = shamt5_from_instr(instr_prev);
    step_and_check(5'd3, $signed(rs1_val) >>> shamt, pc_prev); // x[rd] = x[rs1] >>> imm[4:0] (arith)

    // ---------- Lệnh 7: slti x3, x1, imm (signed) ----------
    pc_prev    = PC7;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_se     = sext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, ($signed(rs1_val) < $signed(imm_se)) ? 32'd1 : 32'd0, pc_prev);
    // x[rd] = x[rs1] < signed(imm)

    // ---------- Lệnh 8: sltiu x3, x1, imm (unsigned compare with unsigned(imm)) ----------
    pc_prev    = PC8;
    instr_prev = get_instr_at_pc(pc_prev);
    rs1_val    = reg_read(5'd1);
    imm_ze     = zext12(imm12_from_instr(instr_prev));
    step_and_check(5'd3, ($unsigned(rs1_val) < $unsigned(imm_ze)) ? 32'd1 : 32'd0, pc_prev);
    // x[rd] = x[rs1] <unsigned(imm)

    // ---------- Lệnh 9: addi x1, x0, 0 (kết thúc) ----------
    pc_prev    = PC9;
    // Sau lệnh này x1 phải = 0
    step_and_check(5'd1, 32'd0, pc_prev);

    $display("===== I-type Golden Test PASS =====");
    $finish;
  end

endmodule



`timescale 1ns/1ps

module tb_single_cycle_load;
  parameter PERIOD = 10;

  reg clk;
  reg rst_n;

  // Clock
  initial clk = 0;
  always #(PERIOD/2) clk = ~clk;

  // DUT
  top_single_cycle uut(
    .clk(clk),
    .rst_n(rst_n)
  );

  // Dump (optional)
  initial begin
    $dumpfile("single_cycle_load.vcd");
    $dumpvars(0, tb_single_cycle_load);
  end

  // ===== Hierarchical monitors =====
  wire [31:0] PC    = uut.PC;
  wire [31:0] Instr = uut.Instruction;

  function [31:0] reg_read;
    input [4:0] r;
    begin reg_read = uut.u_register_file.RF[r]; end
  endfunction

  // ===== Helpers: sign/zero extend =====
  function [31:0] sext8;
    input [7:0] b;
    begin sext8 = {{24{b[7]}}, b}; end
  endfunction

  function [31:0] sext16;
    input [15:0] h;
    begin sext16 = {{16{h[15]}}, h}; end
  endfunction

  // ===== DMEM helpers (little-endian byte addressing) =====
  // data_memory_reg is word array, index = addr[31:2]
  function [7:0] dmem_read_byte;
    input [31:0] byte_addr;
    reg [31:0] w;
    reg [1:0]  off;
    begin
      w   = uut.u_data_memory.data_memory_reg[byte_addr[31:2]];
      off = byte_addr[1:0];
      case (off)
        2'd0: dmem_read_byte = w[7:0];
        2'd1: dmem_read_byte = w[15:8];
        2'd2: dmem_read_byte = w[23:16];
        2'd3: dmem_read_byte = w[31:24];
      endcase
    end
  endfunction

  function [15:0] dmem_read_half_le;
    input [31:0] byte_addr;
    reg [7:0] b0, b1;
    begin
      b0 = dmem_read_byte(byte_addr);
      b1 = dmem_read_byte(byte_addr + 32'd1);
      dmem_read_half_le = {b1, b0}; // little-endian
    end
  endfunction

  function [31:0] dmem_read_word_aligned;
    input [31:0] byte_addr;
    begin
      dmem_read_word_aligned = uut.u_data_memory.data_memory_reg[byte_addr[31:2]];
    end
  endfunction

  // ===== Step & checks =====
  task step_and_check_pc;
    input [31:0] prev_pc;
    begin
      @(posedge clk); #1;
      if (PC !== (prev_pc + 32'd4))
        $fatal(1, "FAIL PC: curr=%08h, prev+4=%08h", PC, prev_pc + 32'd4);
    end
  endtask

  task check_rd_equals;
    input [4:0]  rd;
    input [31:0] exp_val;
    input [31:0] at_pc;
    begin
      if (rd != 5'd0 && reg_read(rd) !== exp_val)
        $fatal(1, "FAIL RF[x%0d] @PC=%08h: got=%08h, exp=%08h",
               rd, at_pc, reg_read(rd), exp_val);
      $display("PASS @PC=%08h: x%0d == %08h", at_pc, rd, exp_val);
    end
  endtask

  // ===== Addresses for this program =====
  localparam PC0 = 32'h0000_0000; // lb  x10, 1(x0)
  localparam PC1 = 32'h0000_0004; // lh  x11, 6(x0)
  localparam PC2 = 32'h0000_0008; // lw  x12, 8(x0)
  localparam PC3 = 32'h0000_000C; // lbu x13, 3(x0)
  localparam PC4 = 32'h0000_0010; // lhu x14, 4(x0)
  localparam PC5 = 32'h0000_0014; // addi x0,x0,0 (NOP)

  // ===== Init memories & RF =====
  integer i;
  initial begin
    // Nếu IMEM/DMEM KHÔNG tự $readmemh bên trong module, dùng 2 dòng sau:
    // $readmemh("prog_load.hex", uut.u_instruction_memory.RF);
    // $readmemh("dmem_load.hex", uut.u_data_memory.data_memory_reg);
     $readmemh("data.txt",      uut.u_data_memory.data_memory_reg);
    // RF sạch để tránh X
    for (i = 0; i < 32; i = i + 1)
      uut.u_register_file.RF[i] = 32'b0;
  end

  // ===== Main sequence =====
  initial begin
    $display("==== LOAD Golden Test Start ====");

    // Reset
    rst_n = 0;
    #(3*PERIOD);
    rst_n = 1;

    // Base = x0 => address = sext(offset) (ở đây offset dương nhỏ)
    // Với dmem_load.hex như đã đề xuất:
    // Word0: 0xFF7F8011  -> [00]=11 [01]=80 [02]=7F [03]=FF
    // Word1: 0xABCD1234  -> [04]=34 [05]=12 [06]=CD [07]=AB
    // Word2: 0xDEADBEEF  -> [08]=EF [09]=BE [0A]=AD [0B]=DE

    // ---- 0) lb x10, 1(x0) ----
    step_and_check_pc(PC0);
    check_rd_equals(5'd10, sext8(dmem_read_byte(32'd1)), PC0);

    // ---- 1) lh x11, 6(x0) ----
    step_and_check_pc(PC1);
    check_rd_equals(5'd11, sext16(dmem_read_half_le(32'd6)), PC1);

    // ---- 2) lw x12, 8(x0) ---- (word-aligned)
    step_and_check_pc(PC2);
    check_rd_equals(5'd12, dmem_read_word_aligned(32'd8), PC2);

    // ---- 3) lbu x13, 3(x0) ----
    step_and_check_pc(PC3);
    check_rd_equals(5'd13, {24'b0, dmem_read_byte(32'd3)}, PC3);

    // ---- 4) lhu x14, 4(x0) ----
    step_and_check_pc(PC4);
    check_rd_equals(5'd14, {16'b0, dmem_read_half_le(32'd4)}, PC4);

    // ---- 5) NOP ----
    step_and_check_pc(PC5);
    $display("==== LOAD Golden Test PASS ====");
    $finish;
  end

endmodule
