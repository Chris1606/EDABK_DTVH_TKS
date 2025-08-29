    .text
    .globl _start
_start:
    # 0x00000000
    lui   x5,  0x00001       # x5 = 0x00001000
    # 0x00000004
    lui   x6,  0xABCDE       # x6 = 0xABCDE000

    # AUIPC: x[rd] = PC + (imm<<12)
    # 0x00000008
    auipc x7,  0x00001       # x7 = 0x00000008 + 0x00001000 = 0x00001008
    # 0x0000000C
    auipc x8,  0x00002       # x8 = 0x0000000C + 0x00002000 = 0x0000200C
    # 0x00000010
    auipc x9,  0x12345       # x9 = 0x00000010 + 0x12345000 = 0x12345010

done:
    beq   x0, x0, done       # loop
