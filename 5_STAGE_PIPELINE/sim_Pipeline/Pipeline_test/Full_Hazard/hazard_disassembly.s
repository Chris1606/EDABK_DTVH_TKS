
00000000 <_start>:
    0:        00000093        addi x1 x0 0
    4:        12300193        addi x3 x0 291
    8:        0030a023        sw x3 0 x1
    c:        45600213        addi x4 x0 1110
    10:        0040a223        sw x4 4 x1
    14:        00700293        addi x5 x0 7
    18:        00300313        addi x6 x0 3
    1c:        006283b3        add x7 x5 x6
    20:        40638433        sub x8 x7 x6
    24:        005474b3        and x9 x8 x5
    28:        0064e533        or x10 x9 x6
    2c:        005545b3        xor x11 x10 x5
    30:        00158613        addi x12 x11 1
    34:        00c606b3        add x13 x12 x12
    38:        00d686b3        add x13 x13 x13
    3c:        0000a703        lw x14 0 x1
    40:        00e707b3        add x15 x14 x14
    44:        0040a803        lw x16 4 x1
    48:        40e808b3        sub x17 x16 x14
    4c:        0000a903        lw x18 0 x1
    50:        0120a423        sw x18 8 x1
    54:        0080a983        lw x19 8 x1
    58:        00c00113        addi x2 x0 12
    5c:        00208a33        add x20 x1 x2
    60:        000a2a83        lw x21 0 x20
    64:        001a8a93        addi x21 x21 1
    68:        0150a623        sw x21 12 x1
    6c:        00078b33        add x22 x15 x0
    70:        000b0463        beq x22 x0 8 <BR1_T>
    74:        00100b93        addi x23 x0 1

00000078 <BR1_T>:
    78:        40e70c33        sub x24 x14 x14
    7c:        000c0463        beq x24 x0 8 <BR2_T>
    80:        001b8b93        addi x23 x23 1

00000084 <BR2_T>:
    84:        0000ac83        lw x25 0 x1
    88:        00ec9463        bne x25 x14 8 <done>
    8c:        00500d13        addi x26 x0 5

00000090 <done>:
    90:        00000063        beq x0 x0 0 <done>
