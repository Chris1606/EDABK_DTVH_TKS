import random

# Register map
REGISTERS = {f"x{i}": i for i in range(32)}

# Opcodes / funct3 / funct7
OPCODES = {
    "ADD":  ("R", 0b0110011, 0b000, 0b0000000),
    "SUB":  ("R", 0b0110011, 0b000, 0b0100000),
    "AND":  ("R", 0b0110011, 0b111, 0b0000000),
    "OR":   ("R", 0b0110011, 0b110, 0b0000000),
    "SLT":  ("R", 0b0110011, 0b010, 0b0000000),

    "LW":   ("I", 0b0000011, 0b010, None),
    "SW":   ("S", 0b0100011, 0b010, None),

    "BEQ":  ("B", 0b1100011, 0b000, None),
}

# --- encoders ---
def encode_rtype(funct7, rs2, rs1, funct3, rd, opcode):
    return ((funct7 & 0x7F) << 25 |
            (rs2 & 0x1F) << 20 |
            (rs1 & 0x1F) << 15 |
            (funct3 & 0x07) << 12 |
            (rd & 0x1F) << 7 |
            (opcode & 0x7F))

def encode_itype(imm, rs1, funct3, rd, opcode):
    return ((imm & 0xFFF) << 20 |
            (rs1 & 0x1F) << 15 |
            (funct3 & 0x07) << 12 |
            (rd & 0x1F) << 7 |
            (opcode & 0x7F))

def encode_stype(imm, rs2, rs1, funct3, opcode):
    imm11_5 = (imm >> 5) & 0x7F
    imm4_0  = imm & 0x1F
    return (imm11_5 << 25 |
            (rs2 & 0x1F) << 20 |
            (rs1 & 0x1F) << 15 |
            (funct3 & 0x07) << 12 |
            imm4_0 << 7 |
            (opcode & 0x7F))

def encode_btype(imm, rs2, rs1, funct3, opcode):
    imm12   = (imm >> 12) & 0x1
    imm10_5 = (imm >> 5) & 0x3F
    imm4_1  = (imm >> 1) & 0xF
    imm11   = (imm >> 11) & 0x1
    return (imm12 << 31 |
            imm10_5 << 25 |
            (rs2 & 0x1F) << 20 |
            (rs1 & 0x1F) << 15 |
            (funct3 & 0x07) << 12 |
            imm4_1 << 8 |
            imm11 << 7 |
            (opcode & 0x7F))

# --- assembler ---
def assemble(instr: str) -> int:
    parts = instr.replace(",", "").split()
    name = parts[0].upper()
    fmt, opcode, funct3, funct7 = OPCODES[name]

    if fmt == "R":
        rd, rs1, rs2 = [REGISTERS[p] for p in parts[1:]]
        return encode_rtype(funct7, rs2, rs1, funct3, rd, opcode)

    elif fmt == "I":  # lw
        rd, rs1, imm = parts[1], parts[2], int(parts[3])
        return encode_itype(imm, REGISTERS[rs1], funct3, REGISTERS[rd], opcode)

    elif fmt == "S":  # sw
        rs2, rs1, imm = parts[1], parts[2], int(parts[3])
        return encode_stype(imm, REGISTERS[rs2], REGISTERS[rs1], funct3, opcode)

    elif fmt == "B":  # beq
        rs1, rs2, imm = parts[1], parts[2], int(parts[3])
        return encode_btype(imm, REGISTERS[rs2], REGISTERS[rs1], funct3, opcode)

    else:
        raise ValueError("Unsupported")

# --- random generator ---
def random_reg():
    return f"x{random.randint(1,31)}"  # avoid x0 as destination

def random_imm(bits=12):
    return random.randint(-(2**(bits-1)), 2**(bits-1)-1)

def generate_random_instr():
    instr = random.choice(list(OPCODES.keys()))
    if instr in ["ADD","SUB","AND","OR","SLT"]:
        return f"{instr} {random_reg()}, {random_reg()}, {random_reg()}"
    elif instr == "LW":
        return f"LW {random_reg()}, {random_reg()}, {random_imm()}"
    elif instr == "SW":
        return f"SW {random_reg()}, {random_reg()}, {random_imm()}"
    elif instr == "BEQ":
        imm = random_imm(bits=13) & ~1  # branch offset multiple of 2
        return f"BEQ {random_reg()}, {random_reg()}, {imm}"

# --- main ---
with open("instructions.txt","w") as f:
    for _ in range(1000):
        asm = generate_random_instr()
        mc  = assemble(asm)
        f.write(f"{mc:08X}\n")   # <-- capitalized HEX

print("✅ Generated 1000 instructions into instructions.txt (uppercase hex)")
