
00000000 <_start>:
    0:        00500113        addi x2 x0 5
    4:        00a00193        addi x3 x0 10
    8:        00310663        beq x2 x3 12 <BEQ_T>
    c:        00000a13        addi x20 x0 0
    10:        00000463        beq x0 x0 8 <BEQ_D>

00000014 <BEQ_T>:
    14:        00100a13        addi x20 x0 1

00000018 <BEQ_D>:
    18:        00311663        bne x2 x3 12 <BNE_T>
    1c:        00000a93        addi x21 x0 0
    20:        00000463        beq x0 x0 8 <BNE_D>

00000024 <BNE_T>:
    24:        00100a93        addi x21 x0 1

00000028 <BNE_D>:
    28:        ff610113        addi x2 x2 -10
    2c:        00314663        blt x2 x3 12 <BLT_T>
    30:        00000b13        addi x22 x0 0
    34:        00000463        beq x0 x0 8 <BLT_D>

00000038 <BLT_T>:
    38:        00100b13        addi x22 x0 1

0000003c <BLT_D>:
    3c:        0021d663        bge x3 x2 12 <BGE_T>
    40:        00000b93        addi x23 x0 0
    44:        00000463        beq x0 x0 8 <BGE_D>

00000048 <BGE_T>:
    48:        00100b93        addi x23 x0 1

0000004c <BGE_D>:
    4c:        00316663        bltu x2 x3 12 <BLTU_T>
    50:        00000c13        addi x24 x0 0
    54:        00000463        beq x0 x0 8 <BLTU_D>

00000058 <BLTU_T>:
    58:        00100c13        addi x24 x0 1

0000005c <BLTU_D>:
    5c:        00317663        bgeu x2 x3 12 <BGEU_T>
    60:        00000c93        addi x25 x0 0
    64:        00000463        beq x0 x0 8 <done>

00000068 <BGEU_T>:
    68:        00100c93        addi x25 x0 1

0000006c <done>:
    6c:        00000063        beq x0 x0 0 <done>
