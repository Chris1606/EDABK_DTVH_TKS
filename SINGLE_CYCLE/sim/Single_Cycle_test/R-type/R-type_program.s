    .globl _start
_start:

# ---------- ADD ----------
    addi x5, x0, 21        #INITILIZE # x5 = 21 (0x00000015)
    addi x6, x0, 10        #INITILIZE # x6 = 10 (0x0000000A)
    add  x7, x5, x6        # x7 = x5 + x6 = 31 (0x0000001F)

# ---------- SUB ----------
    sub  x8, x5, x6        # x8 = x5 - x6 = 11 (0x0000000B)

# ---------- XOR / OR / AND ----------
    li   x5, 0x55AA55AA    #INITILIZE # x5 = 0x55AA55AA
    li   x6, 0x0F0F0F0F    #INITILIZE # x6 = 0x0F0F0F0F
    xor  x9,  x5, x6       # x9  = x5 ^ x6  = 0x5AA55AA5
    or   x10, x5, x6       # x10 = x5 | x6  = 0x5FAF5FAF
    and  x11, x5, x6       # x11 = x5 & x6  = 0x050A050A

# ---------- SLL ----------
# dịch trái logic: chỉ dùng 5 bit thấp của rs2
    addi x5, x0, 0x15      #INITILIZE # x5 = 0x00000015 (21)
    addi x6, x0, 3         #INITILIZE # x6 = 3
    sll  x12, x5, x6       # x12 = 0x000000A8 (168)

# ---------- SRL / SRA ----------
# so sánh khác biệt giữa dịch phải logic và số học
    lui  x5, 0xF0000       #INITILIZE # x5 = 0xF0000000 (số âm theo signed)
    addi x6, x0, 4         #INITILIZE # x6 = 4
    srl  x13, x5, x6       # x13 = 0x0F000000 (dịch phải logic, thêm 0 vào MSB)
    sra  x14, x5, x6       # x14 = 0xFF000000 (dịch phải số học, kéo bit dấu 1)

# ---------- SLT / SLTU ----------
# signed: -5 < 10  => 1
    addi x5, x0, -5        #INITILIZE # x5 = 0xFFFFFFFB (-5)
    addi x6, x0, 10        #INITILIZE # x6 = 10
    slt  x15, x5, x6       # x15 = 1
# unsigned: 0xFFFFFFFB (4294967291) < 10 ? => 0
    sltu x16, x5, x6       # x16 = 0

# ---------- Kết thúc: vòng lặp vô hạn ----------
done:
    j done