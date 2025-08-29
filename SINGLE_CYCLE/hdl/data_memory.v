module data_memory #(
    parameter DMEM_WIDTH = 64  // number of 32-bit words
)(
    input  wire         clk,

    // RISC-V funct3 for load/store
    input  wire [2:0]   funct3,

    input  wire [31:0]  Address,   // byte address
    input  wire [31:0]  WD,        // data to store (rs2)
    input  wire         MemWriteEn,

    output reg  [31:0]  RD         // read data
);
    // load encodings (funct3)
    localparam LB   = 3'b000;
    localparam LH   = 3'b001;
    localparam LW   = 3'b010;
    localparam LBU  = 3'b100;
    localparam LHU  = 3'b101;

    // store encodings (funct3)
    localparam SB   = 3'b000;
    localparam SH   = 3'b001;
    localparam SW   = 3'b010;

    // 32-bit word memory
    reg [31:0] memory [0:DMEM_WIDTH-1];

    wire [31:0] word_r = memory[Address[31:2]];
    wire [1:0]  byte_off = Address[1:0];
    wire        half_sel = Address[1]; // 0: low half [15:0], 1: high half [31:16]

    // =======================
    // Stores: byte-masked
    // =======================
    always @(posedge clk) begin
        if (MemWriteEn) begin
            case (funct3)
                SB: begin
                    case (byte_off)
                        2'd0: memory[Address[31:2]] <= { word_r[31:8],  WD[7:0]       };
                        2'd1: memory[Address[31:2]] <= { word_r[31:16], WD[7:0], word_r[7:0] };
                        2'd2: memory[Address[31:2]] <= { word_r[31:24], WD[7:0], word_r[15:0]};
                        2'd3: memory[Address[31:2]] <= { WD[7:0],       word_r[23:0] };
                    endcase
                end
                SH: begin
                    if (half_sel)
                        memory[Address[31:2]] <= { WD[15:0], word_r[15:0] };
                    else
                        memory[Address[31:2]] <= { word_r[31:16], WD[15:0] };
                end
                SW: begin
                    memory[Address[31:2]] <= WD;
                end
                default: /* no-op */ ;
            endcase
        end
    end

    // =======================
    // Loads
    // =======================
    always @(funct3, byte_off, word_r)begin
        case (funct3)
            LB: begin
                case (byte_off)
                    2'd0: RD = {{24{word_r[7]}},   word_r[7:0]};
                    2'd1: RD = {{24{word_r[15]}},  word_r[15:8]};
                    2'd2: RD = {{24{word_r[23]}},  word_r[23:16]};
                    2'd3: RD = {{24{word_r[31]}},  word_r[31:24]};
                endcase
            end
            LH: begin
                RD = half_sel ? {{16{word_r[31]}}, word_r[31:16]}
                              : {{16{word_r[15]}}, word_r[15:0]};
            end
            LW: RD = word_r;

            LBU: begin
                case (byte_off)
                    2'd0: RD = {24'b0, word_r[7:0]};
                    2'd1: RD = {24'b0, word_r[15:8]};
                    2'd2: RD = {24'b0, word_r[23:16]};
                    2'd3: RD = {24'b0, word_r[31:24]};
                endcase
            end
            LHU: RD = half_sel ? {16'b0, word_r[31:16]}
                               : {16'b0, word_r[15:0]};

            default: RD = 32'b0;
        endcase
    end
endmodule
