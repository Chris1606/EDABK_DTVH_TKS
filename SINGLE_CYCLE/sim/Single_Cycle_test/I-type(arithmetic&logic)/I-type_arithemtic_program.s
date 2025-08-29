
    .text
    .globl _start
_start:
# --------- Khởi tạo (chỉ dùng ADDI) ----------
    addi x5,  x0, 240        # 0x000000F0 (cho xori)
    addi x6,  x0, 160        # 0x000000A0 (cho ori)
    addi x7,  x0, 171        # 0x000000AB (cho andi)
    addi x9,  x0, 21         # 0x00000015 (cho slli)
    addi x10, x0, 240        # 0x000000F0 (cho srli)
    addi x11, x0, -128       # 0xFFFFFF80 (âm) (cho sra R-type)
    addi x12, x0, 3          # shamt = 3 (cho sra R-type)
    addi x13, x0, -128       # 0xFFFFFF80 (cho srai)
    addi x14, x0, -5         # 0xFFFFFFFB (cho slti/sltiu)

# --------- Các lệnh cần test (ghi kết quả vào thanh ghi riêng) ----------
    xori x20, x5,  0x0FF     # x20 = 0x0000000F
    ori  x21, x6,  0x00F     # x21 = 0x000000AF
    andi x22, x7,  0x0F0     # x22 = 0x000000A0

    slli x23, x9,  3         # x23 = 0x000000A8  (21 << 3)
    srli x24, x10, 3         # x24 = 0x0000001E  (240 >> 3 logic)
    sra  x25, x11, x12       # x25 = 0xFFFFFFF0  (-128 >> 3 số học)
    srai x26, x13, 3         # x26 = 0xFFFFFFF0  (-128 >> 3 số học)

    slti  x27, x14, 10       # x27 = 1  (signed: -5 < 10)
    sltiu x28, x14, 10       # x28 = 0  (unsigned: 0xFFFFFFFB > 10)

done:
    j done
