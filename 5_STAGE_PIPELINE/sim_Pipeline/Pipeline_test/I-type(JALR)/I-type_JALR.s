    .text
    .globl _start
_start:
    addi x1, x0, 0x0040       # rs1 = 0x0040
    jalr x5, x1(0)            # -> t1 ; x5 = PC+4 = 0x00000008
    #jalr x5, 0(x1)
    # pad đến địa chỉ 0x0040 (16 lệnh trước t1, đã dùng 2 => thêm 14 NOP)
    addi x0,x0,0  #1
    addi x0,x0,0  #2
    addi x0,x0,0  #3
    addi x0,x0,0  #4
    addi x0,x0,0  #5
    addi x0,x0,0  #6
    addi x0,x0,0  #7
    addi x0,x0,0  #8
    addi x0,x0,0  #9
    addi x0,x0,0  #10
    addi x0,x0,0  #11
    addi x0,x0,0  #12
    addi x0,x0,0  #13
    addi x0,x0,0  #14

t1:                                   # tại ~0x0040
    addi x2, x0, 0x0080               # rs1 = 0x0080
    jalr x6, x2(0)                    # -> t2 ; x6 = 0x00000048
    #jalr x6, 0(x2)
    # pad đến địa chỉ 0x0080 (đã có 16 + 2 = 18 lệnh => thêm 14 NOP để thành 32)
    addi x0,x0,0  #1
    addi x0,x0,0  #2
    addi x0,x0,0  #3
    addi x0,x0,0  #4
    addi x0,x0,0  #5
    addi x0,x0,0  #6
    addi x0,x0,0  #7
    addi x0,x0,0  #8
    addi x0,x0,0  #9
    addi x0,x0,0  #10
    addi x0,x0,0  #11
    addi x0,x0,0  #12
    addi x0,x0,0  #13
    addi x0,x0,0  #14

t2:                                   # tại ~0x0080
    addi x3, x0, 0x00C1               # rs1 = 0x00C1 (odd)
    jalr x7, x3(-1)                   # target = (0x00C1-1)&~1 = 0x00C0 ; x7 = 0x00000088
    #jalr x7, -1(x3)
    # pad đến địa chỉ   (đã có 32 + 2 = 34 lệnh => thêm 14 NOP để thành 48)
    addi x0,x0,0  #1
    addi x0,x0,0  #2
    addi x0,x0,0  #3
    addi x0,x0,0  #4
    addi x0,x0,0  #5
    addi x0,x0,0  #6
    addi x0,x0,0  #7
    addi x0,x0,0  #8
    addi x0,x0,0  #9
    addi x0,x0,0  #10
    addi x0,x0,0  #11
    addi x0,x0,0  #12
    addi x0,x0,0  #13
    addi x0,x0,0  #14

t3:                                   # tại ~0x00C0
    addi x10, x0, 10                  # đánh dấu tới đích

done:
    j done
