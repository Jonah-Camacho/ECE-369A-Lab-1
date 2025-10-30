'timescale 1ns / 1ps

module DataMemory (
  input Clk,
  input MemWrite,
  input MemRead,
  input [1:0] MemSize,
  input LoadSigned,
  input [31:0] Address,
  input [31:0] WriteData,
  ouput reg [31:0] ReadData
);

    reg [31:0] memory [0:1023];

    initial $readmemh("data_memory.mem", memory);

    wire [9:0] word_addr = Address[11:2];
    wire [1:0] byte_off = Address[1:0];

    always @(posedge Clk) begin
        if (MemWrite) begin
            case (MemSize)
                2'b10: memory[word_addr] <= WriteData;
                2'b01: begin
                    if (!byte_off[1])
                        memory[word_addr][15:0] <= WriteData[15:0];
                    else
                        memory[word_addr][31:16] <= WriteData[15:0];
                end
                2'b00: begin
                    case (byte_off)
                        2'b00: memory[word_addr][7:0] <= WriteData[7:0];
                        2'b01: memory[word_addr][15:8] <= WriteData[7:0];
                        2'b10: memory[word_addr][23:16] <= WriteData[7:0];
                        2'b11: memory[word_addr][31:24] <= WriteData[7:0];
                    endcase
                end
            endcase
        end
    end

    always @(*) begin
        if (!MemRead)
            ReadData = 32'b0;
        else begin
            reg [31:0] w;
            reg [15:0] half;
            reg [7:0] byte_;
            w = memory[word_addr];
            case (MemSize)
                2'b10: ReadData = w;
                2'b01: begin
                    half = byte_off[1] ? w[31:16] : w[15:0];
                    ReadData = LoadSigned ? {{16{half[15]}}, half} : {16'b0, half};
                end
                2'b00: begin
                    case (byte_off)
                        2'b00: byte_ = w[7:0];
                        2'b01: byte_ = w[15:8];
                        2'b10: byte_ = w[23:16];
                        default: byte_ = w[31:24];
                    endcase
                    ReadData = LoadSigned ? {{24{byte_[7]}}, byte_} : {24'b0, byte_};
                end
                default: ReadData = 32'b0;
            endcase
        end
    end

endmodule
