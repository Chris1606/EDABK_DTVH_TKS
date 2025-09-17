    .text
    .globl _start
_start:
    # Vùng 0x0000
#    jal  x5, t1        # x5 = 0x00000004, nhảy tới t1
    jal  x5, 0x0040
    # pad đến ~0x0040: đã dùng 1 lệnh => thêm 15 NOP
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
    addi x0,x0,0  #15

#t1: # ~0x0080
    jal  x6, 0x0080           # x6 = 0x00000044, nhảy tới t2
#    jal  x6, t2
    # pad đến ~0x0080: đã dùng 1 lệnh => thêm 15 NOP
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
    addi x0,x0,0  #15

#t2: # ~0x0080
#    jal  x7, t3              # x7 = 0x00000088, nhảy tới t3
    jal  x7, 0x00C0
    # pad đến ~0x00C0: đã dùng 1 lệnh => thêm 15 NOP
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
    addi x0,x0,0  #15

#t3: # ~0x00C0
    addi x10, x0, 10         # đánh dấu tới đích
done:
    jal  x0, done            # vòng lặp vô hạn (j done)
