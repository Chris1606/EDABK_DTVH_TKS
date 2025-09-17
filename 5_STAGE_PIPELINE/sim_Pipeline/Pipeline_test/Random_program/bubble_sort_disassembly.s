
00000000 <main>:
    0:        00000297        auipc x5 0x0 <main>
    4:        00028293        addi x5 x5 0
    8:        0002a283        lw x5 0 x5

0000000c <iteration>:
    c:        fff28313        addi x6 x5 -1
    10:        00000397        auipc x7 0x0 <main>
    14:        ff438393        addi x7 x7 -12

00000018 <compare>:
    18:        0003ae03        lw x28 0 x7
    1c:        0043ae83        lw x29 4 x7
    20:        01de4463        blt x28 x29 8 <swap>
    24:        00c0006f        jal x0 12 <no_swap>

00000028 <swap>:
    28:        01d3a023        sw x29 0 x7
    2c:        01c3a223        sw x28 4 x7

00000030 <no_swap>:
    30:        00438393        addi x7 x7 4
    34:        fff30313        addi x6 x6 -1
    38:        fe0310e3        bne x6 x0 -32 <compare>
    3c:        fff28293        addi x5 x5 -1
    40:        00100f13        addi x30 x0 1
    44:        fde294e3        bne x5 x30 -56 <iteration>

00000048 <done>:
    48:        0000006f        jal x0 0 <done>



/// Chỉnh offset ở trên, code đúng ở dưới

# ======= Data =======
    
.data
N:      .word 10
array:  .word 1,2,3,4,5,6,7,8,9,12
# ======= Code =======
    .text
    .globl main

main:
    auipc x5, 0x10000
    addi  x5, x5, 0
    lw    x5, 0(x5)

iteration:
    addi  x6, x5, -1
    auipc x7, 0x10000
    addi  x7, x7, -12

compare:
    lw    x28, 0(x7)
    lw    x29, 4(x7)
    blt   x28, x29, swap
    jal   x0,  no_swap

swap:
    sw    x29, 0(x7)
    sw    x28, 4(x7)

no_swap:
    addi  x7, x7, 4
    addi  x6, x6, -1
    bne   x6, x0, compare
    addi  x5, x5, -1
    addi  x30, x0, 1
    bne   x5, x30, iteration

done:
    jal   x0, done

