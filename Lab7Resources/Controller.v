`timescale 1ns / 1ps
module Controller(
    input  wire [31:0] Instruction,
    output reg  RegWrite,
    output reg  ALUSrc,
    output reg  ExtOp,        // 0=sign, 1=zero
    output reg  RegDst,       // 0=rt, 1=rd
    output reg  Branch,       // BEQ
    output reg  Jump,         // J/JAL
    output reg  Link,         // JAL
    output reg  JumpReg,      // JR
    output reg  MemWrite,
    output reg  MemRead,
    output reg  MemToReg,     // 0=ALU, 1=Mem
    output reg  [3:0] ALUop,  // must match ALUcontrol enums
    output reg  [1:0] MemSize,// 00=byte,01=half,10=word
    output reg  LoadSigned    // 1=signed (LB/LH), 0=unsigned (LBU/LHU)
);
    // Match ALUcontrol constants
    localparam [3:0]
      ALU_ADD       = 4'b0000,
      ALU_SUB       = 4'b0001,
      ALU_AND       = 4'b0010,
      ALU_OR        = 4'b0011,
      ALU_XOR       = 4'b0100,
      ALU_NOR       = 4'b0101,
      ALU_SLT       = 4'b0110,
      ALU_SLL       = 4'b0111,
      ALU_SRL       = 4'b1000,
      ALU_MUL       = 4'b1001,
      ALU_USE_FUNCT = 4'b1110,
      ALU_NOP       = 4'b1111,
      ALU_LUI       = 4'b1010;

    wire [5:0] opcode = Instruction[31:26];
    wire [5:0] funct  = Instruction[5:0];

    always @(*) begin
        // safe defaults
        RegWrite   = 1'b0;
        ALUSrc     = 1'b0;
        ExtOp      = 1'b0;     // sign extend default
        RegDst     = 1'b0;     // rt default
        Branch     = 1'b0;
        Jump       = 1'b0;
        Link       = 1'b0;
        JumpReg    = 1'b0;
        MemWrite   = 1'b0;
        MemRead    = 1'b0;
        MemToReg   = 1'b0;
        ALUop      = ALU_NOP;
        MemSize    = 2'b10;    // word
        LoadSigned = 1'b1;     // signed by default
        
       
        // Check for NOP first (all zeros)
        if (Instruction == 32'h00000000) begin
            // NOP - all defaults remain (do nothing)
            // RegWrite = 0, ALUop = NOP, etc.
        end
        else begin
            case (opcode)
                6'b000000: begin // R-type
                    // JR handled as a special R-type
                    if (funct == 6'b001000) begin // JR
                        JumpReg  = 1'b1;
                        ALUop    = ALU_NOP; // ALU unused
                    end else begin
                        RegWrite = 1'b1;
                        RegDst   = 1'b1;    // rd
                        ALUop    = ALU_USE_FUNCT; // let ALUcontrol use 'funct'
                    end
                end
    
                6'b001000: begin // ADDI
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b0; ALUop = ALU_ADD;
                end
                6'b001001: begin // ADDIU
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b0; ALUop = ALU_ADD;
                end
                6'b001100: begin // ANDI
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b1; ALUop = ALU_AND;
                end
                6'b001101: begin // ORI
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b1; ALUop = ALU_OR;
                end
                6'b001110: begin // XORI (if you support it)
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b1; ALUop = ALU_XOR;
                end
                6'b001010: begin // SLTI
                    RegWrite = 1'b1; ALUSrc = 1'b1; ExtOp = 1'b0; ALUop = ALU_SLT;
                end
    
                6'b100011: begin // LW
                    RegWrite = 1'b1; ALUSrc = 1'b1; MemRead = 1'b1; MemToReg = 1'b1;
                    ALUop = ALU_ADD; MemSize = 2'b10; LoadSigned = 1'b1;
                end
                6'b100000: begin // LB
                    RegWrite = 1'b1; ALUSrc = 1'b1; MemRead = 1'b1; MemToReg = 1'b1;
                    ALUop = ALU_ADD; MemSize = 2'b00; LoadSigned = 1'b1;
                end
                6'b100100: begin // LBU
                    RegWrite = 1'b1; ALUSrc = 1'b1; MemRead = 1'b1; MemToReg = 1'b1;
                    ALUop = ALU_ADD; MemSize = 2'b00; LoadSigned = 1'b0;
                end
                6'b100001: begin // LH
                    RegWrite = 1'b1; ALUSrc = 1'b1; MemRead = 1'b1; MemToReg = 1'b1;
                    ALUop = ALU_ADD; MemSize = 2'b01; LoadSigned = 1'b1;
                end
                6'b100101: begin // LHU
                    RegWrite = 1'b1; ALUSrc = 1'b1; MemRead = 1'b1; MemToReg = 1'b1;
                    ALUop = ALU_ADD; MemSize = 2'b01; LoadSigned = 1'b0;
                end
    
                6'b101011: begin // SW
                    ALUSrc = 1'b1; MemWrite = 1'b1; ALUop = ALU_ADD; MemSize = 2'b10;
                end
                6'b101000: begin // SB
                    ALUSrc = 1'b1; MemWrite = 1'b1; ALUop = ALU_ADD; MemSize = 2'b00;
                end
                6'b101001: begin // SH
                    ALUSrc = 1'b1; MemWrite = 1'b1; ALUop = ALU_ADD; MemSize = 2'b01;
                end
                6'b001111: begin // LUI
                    RegWrite = 1'b1;
                    ALUSrc   = 1'b1;   // uses immediate
                    ExtOp    = 1'b1;   // zero-extend (important!)
                    ALUop    = ALU_LUI;
                end
                6'b000100: begin // BEQ
                    Branch = 1'b1; ALUop = ALU_SUB; // compare via subtract?Zero
                end
    
                6'b000010: begin // J
                    Jump = 1'b1;
                end
    
                6'b000011: begin // JAL
                    Jump = 1'b1; Link = 1'b1; RegWrite = 1'b1; // WB writes $ra
                end
    
                default: begin
                    // leave defaults (NOP)
                end
            endcase
        end
     end
     
        
endmodule
    
