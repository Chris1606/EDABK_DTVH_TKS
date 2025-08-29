    .option norvc
    .text
    .globl _start
_start:
    # Base của DMEM
    addi x1, x0, 0          # x1 = 0x00000000 (MEMORY_OFFSET)

    # ---- Ghi word 0xA1B2C3D4 ở địa chỉ 0 (bằng các byte) ----
    addi x2, x0, 0xD4       # b0
    sb   x2, 0(x1)
    addi x2, x0, 0xC3       # b1
    sb   x2, 1(x1)
    addi x2, x0, 0xB2       # b2
    sb   x2, 2(x1)
    addi x2, x0, 0xA1       # b3
    sb   x2, 3(x1)

    # ---- Ghi half 0x8001 tại offset 4 ----
    addi x2, x0, 0x01
    sb   x2, 4(x1)
    addi x2, x0, 0x80
    sb   x2, 5(x1)

    # ---- Ghi half 0x7F02 tại offset 6 ----
    addi x2, x0, 0x02
    sb   x2, 6(x1)
    addi x2, x0, 0x7F
    sb   x2, 7(x1)

    # ---- Ghi word 0x33221100 tại offset 8 ----
    addi x2, x0, 0x00
    sb   x2, 8(x1)
    addi x2, x0, 0x11
    sb   x2, 9(x1)
    addi x2, x0, 0x22
    sb   x2,10(x1)
    addi x2, x0, 0x33
    sb   x2,11(x1)

    # ---- LOADs cần test ----
    lw   x10, 0(x1)         # = 0xA1B2C3D4
    lb   x11, 0(x1)         # = 0xFFFFFFD4  (sign)
    lbu  x12, 0(x1)         # = 0x000000D4  (zero)
    lb   x13, 3(x1)         # = 0xFFFFFFA1  (sign)
    lbu  x14, 3(x1)         # = 0x000000A1  (zero)
    lh   x15, 4(x1)         # = 0xFFFF8001  (sign)
    lhu  x16, 4(x1)         # = 0x00008001  (zero)
    lh   x17, 6(x1)         # = 0x00007F02  (sign)
    lhu  x18, 6(x1)         # = 0x00007F02  (zero)
    lw   x19, 8(x1)         # = 0x33221100

done:
    j done
