    .text
    .globl _start
_start:
    # --- Khởi tạo ---
    addi x2, x0, 5          # x2 = 5
    addi x3, x0, 10         # x3 = 10

    # ---- BEQ: 5 == 10 ? (false) ----
    beq  x2, x3, BEQ_T
    addi x20, x0, 0         # not taken
    beq  x0, x0, BEQ_D
BEQ_T:
    addi x20, x0, 1         # taken
BEQ_D:

    # ---- BNE: 5 != 10 ? (true) ----
    bne  x2, x3, BNE_T
    addi x21, x0, 0         # not taken
    beq  x0, x0, BNE_D
BNE_T:
    addi x21, x0, 1         # taken
BNE_D:

    # --- Đổi x2 thành -5 để test signed/unsigned ---
    addi x2, x2, -10        # x2 = -5 (0xFFFFFFFB)

    # ---- BLT (signed): -5 < 10 ? (true) ----
    blt  x2, x3, BLT_T
    addi x22, x0, 0
    beq  x0, x0, BLT_D
BLT_T:
    addi x22, x0, 1
BLT_D:

    # ---- BGE (signed): 10 >= -5 ? (true) ----
    bge  x3, x2, BGE_T
    addi x23, x0, 0
    beq  x0, x0, BGE_D
BGE_T:
    addi x23, x0, 1
BGE_D:

    # ---- BLTU (unsigned): 0xFFFFFFFB < 10 ? (false) ----
    bltu x2, x3, BLTU_T
    addi x24, x0, 0
    beq  x0, x0, BLTU_D
BLTU_T:
    addi x24, x0, 1
BLTU_D:

    # ---- BGEU (unsigned): 0xFFFFFFFB >= 10 ? (true) ----
    bgeu x2, x3, BGEU_T
    addi x25, x0, 0
    beq  x0, x0, BGEU_D
BGEU_T:
    addi x25, x0, 1
BGEU_D:

done:
    beq  x0, x0, done       # loop
