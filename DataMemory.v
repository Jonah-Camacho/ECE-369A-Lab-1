`timescale 1ns / 1ps

module DataMemory (
    input Clk,
    input MemWrite,
    input MemRead,
    input [1:0] MemSize,      // 00=byte, 01=halfword, 10=word
    input LoadSigned,         // 1=signed load (LB/LH), 0=unsigned (LBU/LHU)
    input [31:0] Address,
    input [31:0] WriteData,
    output reg [31:0] ReadData
);
    // Memory array: 1024 words
    reg [31:0] memory [0:1023];
    
    // Initialize from file
    initial $readmemh("data_memory.mem", memory);
    
    // Address decoding
    wire [9:0] word_addr = Address[11:2];  // Word address
    wire [1:0] byte_off = Address[1:0];    // Byte offset within word
    
    // Temporary variables for read logic (MUST be declared outside always block)
    reg [31:0] w;
    reg [15:0] half;
    reg [7:0] byte_;
    
    // Write logic - synchronous
    always @(posedge Clk) begin
        if (MemWrite) begin
            case (MemSize)
                2'b10: begin  // Word (SW)
                    memory[word_addr] <= WriteData;
                end
                2'b01: begin  // Halfword (SH)
                    if (!byte_off[1])
                        memory[word_addr][15:0] <= WriteData[15:0];
                    else
                        memory[word_addr][31:16] <= WriteData[15:0];
                end
                2'b00: begin  // Byte (SB)
                    case (byte_off)
                        2'b00: memory[word_addr][7:0] <= WriteData[7:0];
                        2'b01: memory[word_addr][15:8] <= WriteData[7:0];
                        2'b10: memory[word_addr][23:16] <= WriteData[7:0];
                        2'b11: memory[word_addr][31:24] <= WriteData[7:0];
                    endcase
                end
                default: begin
                    // Do nothing for undefined MemSize
                end
            endcase
        end
    end
    
    // Read logic - combinational
    always @(*) begin
        if (!MemRead) begin
            ReadData = 32'b0;
        end
        else begin
            w = memory[word_addr];
            case (MemSize)
                2'b10: begin  // Word (LW)
                    ReadData = w;
                end
                2'b01: begin  // Halfword (LH/LHU)
                    half = byte_off[1] ? w[31:16] : w[15:0];
                    ReadData = LoadSigned ? {{16{half[15]}}, half} : {16'b0, half};
                end
                2'b00: begin  // Byte (LB/LBU)
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
