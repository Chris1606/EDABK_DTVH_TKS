`timescale 1ns/1ps

module tb_ALU;

  // DUT signals
  reg  [31:0] RD1;
  reg  [31:0] RD2;
  reg  [31:0] immext;
  reg         ALU_src;       // 0: dùng RD2, 1: dùng immext
  reg  [2:0]  ALU_control;   // 000:add, 001:sub, 010:and, 011:or, 101:slt
  wire [31:0] ALU_result;
  wire        zero_flag;

  // Instantiate DUT
  ALU dut (
    .immext(immext),
    .RD2(RD2),
    .ALU_src(ALU_src),
    .RD1(RD1),
    .ALU_control(ALU_control),
    .ALU_result(ALU_result),
    .zero_flag(zero_flag)
  );

  // Localparams khớp với ALU
  localparam ADD  = 3'b000;
  localparam SUB  = 3'b001;
  localparam AND_ = 3'b010;
  localparam OR_  = 3'b011;
  localparam SLT  = 3'b101;

  initial begin
    $display("=== TB ALU (đơn giản) ===");
    $display("time  ctl src RD1          RD2          IMM          ->  RESULT       Z");

    // 1) ADD (R-type): RD1 + RD2
    RD1 = 32'd10; RD2 = 32'd20; immext = 32'd0; ALU_src = 1'b0; ALU_control = ADD; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 2) SUB (R-type): RD1 - RD2 => zero
    RD1 = 32'd123; RD2 = 32'd123; ALU_src = 1'b0; ALU_control = SUB; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 3) AND
    RD1 = 32'hF0F0_1234; RD2 = 32'h0FF0_FF00; ALU_src = 1'b0; ALU_control = AND_; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 4) OR
    RD1 = 32'h00F0_00F0; RD2 = 32'h0F0F_0000; ALU_src = 1'b0; ALU_control = OR_; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 5) SLT (signed): -1 < 1 => 1
    RD1 = -32'sd1; RD2 = 32'sd1; ALU_src = 1'b0; ALU_control = SLT; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 6) SLT (signed, cùng dấu âm): -3 < -2 => 1
    RD1 = -32'sd3; RD2 = -32'sd2; ALU_src = 1'b0; ALU_control = SLT; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 7) ADD với immext (I-type hành vi): RD1 + immext
    RD1 = 32'd100; immext = 32'd4; ALU_src = 1'b1; ALU_control = ADD; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    // 8) SUB với immext: RD1 - immext (âm)
    RD1 = 32'd100; immext = 32'd150; ALU_src = 1'b1; ALU_control = SUB; #10;
    $display("%4t  %03b  %b   %h  %h  %h  ->  %h  %b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);

    $finish;
  end

  // Tùy chọn: theo dõi tự động
  initial begin
    $monitor("t=%0t ctl=%03b src=%b RD1=%h RD2=%h IMM=%h -> RES=%h Z=%b",
              $time, ALU_control, ALU_src, RD1, RD2, immext, ALU_result, zero_flag);
  end

endmodule
