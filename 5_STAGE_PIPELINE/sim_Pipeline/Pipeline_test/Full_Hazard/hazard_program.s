    .text
    .globl _start
_start:
    # ==== DMEM base (MEMORY_OFFSET = 0) ====
    addi x1, x0, 0              # x1 = base = 0

    # ==== Khởi tạo DMEM (dùng SW) ====
    addi x3, x0, 0x123          # 0x00000123
    sw   x3, 0(x1)              # M[0]  = 0x00000123
    addi x4, x0, 0x456          # 0x00000456
    sw   x4, 4(x1)              # M[4]  = 0x00000456

    # ----------------------------------------------------------------
    # RAW ALU->ALU chain (forward EX/MEM, MEM/WB) #
    # ----------------------------------------------------------------
    addi x5, x0, 7              # x5=7
    addi x6, x0, 3              # x6=3
    add  x7,  x5, x6            # x7=10  (RAW: uses x5,x6)
    sub  x8,  x7, x6            # x8=7   (RAW: uses x7)
    and  x9,  x8, x5            # x9=7
    or   x10, x9, x6            # x10=7
    xor  x11, x10, x5           # x11=0
    addi x12, x11, 1            # x12=1  (dùng ngay kết quả 0)

    # RAW trên cùng 1 thanh ghi (rd==rs)
    add  x13, x12, x12          # x13=2
    add  x13, x13, x13          # x13=4  (ghi rồi đọc ngay x13)

    # ----------------------------------------------------------------
    # Load-use hazard (cần stall 1 chu kỳ nếu không forward từ MEM) #
    # ----------------------------------------------------------------
    lw   x14, 0(x1)             # x14 = M[0] = 0x00000123
    add  x15, x14, x14          # x15 = 0x00000246  (dùng ngay x14)

    lw   x16, 4(x1)             # x16 = M[4] = 0x00000456
    sub  x17, x16, x14          # x17 = 0x00000333  (dùng ngay x16,x14)

    # ----------------------------------------------------------------
    # Load -> Store (forward dữ liệu load sang cổng store) #
    # ----------------------------------------------------------------
    lw   x18, 0(x1)             # x18 = 0x00000123
    sw   x18, 8(x1)             # M[8] = 0x00000123 (không NOP chen giữa!)
    lw   x19, 8(x1)             # x19 = 0x00000123 (đọc lại xác nhận)

    # ----------------------------------------------------------------
    # ALU tạo địa chỉ -> dùng ngay cho load
    # ----------------------------------------------------------------
    addi x2,  x0, 12            # offset = 12
    add  x20, x1, x2            # x20 = &M[12]
    lw   x21, 0(x20)            # x21 = M[12] (init là 0)
    addi x21, x21, 1            # x21 = 1
    sw   x21, 12(x1)            # M[12] = 1

    # ----------------------------------------------------------------
    # Branch hazards: not-taken & taken ngay sát sau lệnh tạo dữ liệu #
    # ----------------------------------------------------------------
    add  x22, x15, x0           # x22 = 0x246 (≠0)
    beq  x22, x0, BR1_T         # NOT taken
    addi x23, x0, 1             # PHẢI được thực thi -> x23=1
BR1_T:
    sub  x24, x14, x14          # x24 = 0
    beq  x24, x0, BR2_T         # TAKEN
    addi x23, x23, 1            # PHẢI bị flush (x23 vẫn =1)
BR2_T:
    lw   x25, 0(x1)             # x25 = 0x123
    bne  x25, x14, BR3_T        # NOT taken (bằng nhau)
    addi x26, x0, 5             # thực thi -> x26=5
BR3_T:

done:
    beq  x0, x0, done           # loop


// ======================== Code to run in Ripes ========================
    .text
    .globl _start
_start:
    # ==== DMEM base (MEMORY_OFFSET = 0x10000000) ====
    lui  x1, 0x10000           # x1 = 0x1000_0000
    addi x1, x1, 0

    # ==== Khởi tạo DMEM (dùng SW) ====
    addi x3, x0, 0x123          # 0x00000123
    sw   x3, 0(x1)              # M[0x1000_0000] = 0x00000123
    addi x4, x0, 0x456          # 0x00000456
    sw   x4, 4(x1)              # M[0x1000_0004] = 0x00000456

    # ----------------------------------------------------------------
    # RAW ALU->ALU chain (forward EX/MEM, MEM/WB)
    # ----------------------------------------------------------------
    addi x5, x0, 7              # x5=7
    addi x6, x0, 3              # x6=3
    add  x7,  x5, x6            # x7=10
    sub  x8,  x7, x6            # x8=7
    and  x9,  x8, x5            # x9=7
    or   x10, x9, x6            # x10=7
    xor  x11, x10, x5           # x11=0
    addi x12, x11, 1            # x12=1

    # RAW rd==rs
    add  x13, x12, x12          # x13=2
    add  x13, x13, x13          # x13=4

    # ----------------------------------------------------------------
    # Load-use hazard
    # ----------------------------------------------------------------
    lw   x14, 0(x1)             # x14 = M[0x1000_0000] = 0x00000123
    add  x15, x14, x14          # x15 = 0x00000246

    lw   x16, 4(x1)             # x16 = M[0x1000_0004] = 0x00000456
    sub  x17, x16, x14          # x17 = 0x00000333

    # ----------------------------------------------------------------
    # Load -> Store
    # ----------------------------------------------------------------
    lw   x18, 0(x1)             # x18 = 0x00000123
    sw   x18, 8(x1)             # M[0x1000_0008] = 0x00000123
    lw   x19, 8(x1)             # x19 = 0x00000123

    # ----------------------------------------------------------------
    # ALU tạo địa chỉ -> dùng ngay cho load
    # ----------------------------------------------------------------
    addi x2,  x0, 12            # offset = 12
    add  x20, x1, x2            # x20 = 0x1000_000C
    lw   x21, 0(x20)            # x21 = M[0x1000_000C] (init = 0)
    addi x21, x21, 1            # x21 = 1
    sw   x21, 12(x1)            # M[0x1000_000C] = 1

    # ----------------------------------------------------------------
    # Branch hazards
    # ----------------------------------------------------------------
    add  x22, x15, x0           # x22 = 0x246
    beq  x22, x0, BR1_T         # NOT taken
    addi x23, x0, 1             # x23=1
BR1_T:
    sub  x24, x14, x14          # x24 = 0
    beq  x24, x0, BR2_T         # TAKEN
    addi x23, x23, 1            # bị flush, x23 vẫn =1
BR2_T:
    lw   x25, 0(x1)             # x25 = 0x123
    bne  x25, x14, BR3_T        # NOT taken
    addi x26, x0, 5             # x26=5
BR3_T:

done:
    beq  x0, x0, done           # loop
