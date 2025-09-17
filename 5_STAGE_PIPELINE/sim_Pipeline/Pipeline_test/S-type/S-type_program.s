
    .text
    .globl _start
_start:
    # Base DMEM = MEMORY_OFFSET = 0x00000000
    addi x1, x0, 0              # x1 = 0 (base)

    # ===== SB: tạo word 0xDDCCBBAA tại địa chỉ 0 =====
    addi x2, x0, 0xAA           # 170
    sb   x2, 0(x1)              # [0] = AA
    addi x2, x0, 0xBB           # 187
    sb   x2, 1(x1)              # [1] = BB
    addi x2, x0, 0xCC           # 204
    sb   x2, 2(x1)              # [2] = CC
    addi x2, x0, 0xDD           # 221
    sb   x2, 3(x1)              # [3] = DD   -> word@0 = 0xDDCCBBAA

    # ===== SH: ghi 0x07E5 tại offset 4, rồi 0xFF80 tại offset 6 =====
    addi x3, x0, 2021           # 0x07E5 fits 12-bit
    sh   x3, 4(x1)              # bytes[5:4] = 07 E5 (LE) -> 0x07E5 phần thấp
    addi x3, x0, -128           # 0xFFFFFF80
    sh   x3, 6(x1)              # bytes[7:6] = FF 80       -> word@4 = 0xFF8007E5

    # ===== SW: ghi 0x000007C3 tại offset 8 =====
    addi x4, x0, 1987           # 0x07C3
    sw   x4, 8(x1)              # word@8 = 0x000007C3

    # (tùy chọn) đọc lại để kiểm tra nhanh
    #  lw   x20, 0(x1)             # x20 = 0xDDCCBBAA
    # lw   x21, 4(x1)             # x21 = 0xFF8007E5
    #lw   x22, 8(x1)             # x22 = 0x000007C3

done:
    j done
