`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// DataMemory.v
//  - 4 KB (1024 x 32) data RAM
//  - Byte / Halfword / Word accesses
//  - Signed/Unsigned loads (LB/LBU, LH/LHU, LW)
//  - Synchronous writes, combinational reads (single-cycle read)
//  - X-safe addressing guards to avoid propagating X when Address is unknown
//  - Optional hex preload with +LOAD_DMEM plusarg (file: data_memory.mem)
// -----------------------------------------------------------------------------
module DataMemory (
    input  wire        Clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [1:0]  MemSize,     // 00=byte, 01=halfword, 10=word
    input  wire        LoadSigned,  // 1=signed (LB/LH), 0=unsigned (LBU/LHU)
    input  wire [31:0] Address,
    input  wire [31:0] WriteData,
    output reg  [31:0] ReadData
);
    // 1024 words = 4096 bytes; address bits [11:2] select the word
    reg [31:0] memory [0:1023];

    integer i;

    // Initialize memory to zeros so reads never return X if no preload
    initial begin
        for (i = 0; i < 1024; i = i + 1) memory[i] = 32'h0000_0000;

        if ($test$plusargs("LOAD_DMEM")) begin
            $display("[DMEM] Loading data_memory.mem ...");
            // Place data_memory.mem in the simulator run directory.
            $readmemh("data_memory.mem", memory);
            $display("[DMEM] memory[0]=%h memory[1]=%h", memory[0], memory[1]);
        end
    end

    // Address guards: if any address bits are X early in sim, use 0 to avoid X fans
    wire [9:0] waddr    = (^Address[11:2] === 1'bX) ? 10'd0 : Address[11:2];
    wire [1:0] byte_off = (^Address[1:0]  === 1'bX) ? 2'b00 : Address[1:0];

    // --------------------
    // WRITE (synchronous)
    // --------------------
    always @(posedge Clk) begin
        if (MemWrite) begin
            case (MemSize)
                2'b10: begin
                    // SW
                    memory[waddr] <= WriteData;
                end
                2'b01: begin
                    // SH (little-endian within the 32-bit word)
                    if (byte_off[1] == 1'b0) begin
                        memory[waddr][15:0]  <= WriteData[15:0];
                    end else begin
                        memory[waddr][31:16] <= WriteData[15:0];
                    end
                end
                2'b00: begin
                    // SB
                    case (byte_off)
                        2'b00: memory[waddr][7:0]   <= WriteData[7:0];
                        2'b01: memory[waddr][15:8]  <= WriteData[7:0];
                        2'b10: memory[waddr][23:16] <= WriteData[7:0];
                        2'b11: memory[waddr][31:24] <= WriteData[7:0];
                    endcase
                end
                default: /* do nothing */ ;
            endcase
        end
    end

    // --------------------
    // READ (combinational)
    // --------------------
    reg [31:0] w;
    reg [15:0] half;
    reg  [7:0] byte_;

    always @* begin
        if (!MemRead) begin
            ReadData = 32'b0;
        end else begin
            w = memory[waddr];

            case (MemSize)
                2'b10: begin
                    // LW
                    ReadData = w;
                end
                2'b01: begin
                    // LH/LHU
                    half = (byte_off[1] == 1'b0) ? w[15:0] : w[31:16];
                    ReadData = LoadSigned ? {{16{half[15]}}, half} : {16'b0, half};
                end
                2'b00: begin
                    // LB/LBU
                    case (byte_off)
                        2'b00: byte_ = w[7:0];
                        2'b01: byte_ = w[15:8];
                        2'b10: byte_ = w[23:16];
                        2'b11: byte_ = w[31:24];
                    endcase
                    ReadData = LoadSigned ? {{24{byte_[7]}}, byte_} : {24'b0, byte_};
                end
                default: begin
                    ReadData = 32'b0;
                end
            endcase
        end
    end
endmodule
