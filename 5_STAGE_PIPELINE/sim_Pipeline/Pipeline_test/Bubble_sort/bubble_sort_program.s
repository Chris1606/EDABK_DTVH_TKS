# ======= Data =======
    
.data
N:      .word 10
array:  .word 1,2,3,4,5,6,7,8,9,12
# ======= Code =======
    .text
    .globl main

main:
    # auipc x5, 0x10000 # address base = 0x10000
    auipc x5, 0x00000   # address base = 0x00000
    addi  x5, x5, 0
    lw    x5, 0(x5)

iteration:
    addi  x6, x5, -1
    # auipc x7, 0x10000 # address base = 0x10000
    auipc x7, 0x00000   # address base = 0x00000
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

