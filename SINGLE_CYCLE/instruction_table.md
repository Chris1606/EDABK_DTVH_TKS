# Bảng tín hiệu điều khiển cho các lệnh RISC-V

| Lệnh  | PCSrc | ResultSrc | MemWrite | ALUControl | ALUSrc | ImmSrc | RegWrite |
|-------|-------|-----------|----------|------------|--------|--------|----------|
| **add rd, rs1, rs2**  | 0     | 00 (ALU)   | 0        | 000 (ADD) | 0      | xx     | 1 |
| **addi rd, rs1, imm** | 0     | 00 (ALU)   | 0        | 000 (ADD) | 1      | 00 (I) | 1 |
| **beq rs1, rs2, label** | 1 (branch) | x         | 0        | 001 (SUB) | 0      | 10 (B) | 0 |
| **sw rs2, offset(rs1)** | 0     | x         | 1        | 000 (ADD) | 1      | 01 (S) | 0 |
| **lw rd, offset(rs1)** | 0     | 01 (MEM)  | 0        | 000 (ADD) | 1      | 00 (I) | 1 |
| **jal rd, offset**     | 1 (PC+imm) | 10 (PC+4) | 0        | xxx      | x      | 11 (J) | 1 |
| **j offset** (pseudo)  | 1 (PC+imm) | x         | 0        | xxx      | x      | 11 (J) | 0 |

---

## Ghi chú
- **PCSrc**: chọn nguồn cập nhật PC (0 = PC+4, 1 = nhảy/branch).  
- **ResultSrc**: chọn giá trị ghi vào thanh ghi (00 = ALU, 01 = dữ liệu từ Memory, 10 = PC+4).  
- **MemWrite**: 1 nếu ghi bộ nhớ (store).  
- **ALUControl[2:0]**: mã điều khiển ALU (000=ADD, 001=SUB, …).  
- **ALUSrc**: chọn toán hạng B của ALU (0 = rs2, 1 = immediate).  
- **ImmSrc[1:0]**: chọn kiểu immediate (00=I-type, 01=S-type, 10=B-type, 11=J-type).  
- **RegWrite**: 1 nếu ghi vào thanh ghi.  
