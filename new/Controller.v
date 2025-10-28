`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2025 07:15:54 PM
// Design Name: 
// Module Name: Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller(
    input  [31:0] Instruction,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ExtOp,
    output reg RegDst,
    output reg Branch,
    output reg Jump,
    output reg Link,
    output reg JumpReg,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg [3:0] ALUop,
    output reg [1:0] MemSize
);

    wire [5:0] opcode = Instruction[31:26];
    
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
      ALU_USE_FUNCT = 4'b1110, // R-type ? decode funct
      ALU_NOP       = 4'b1111;
    
    wire [5:0] funct = Instruction[5:0];
    
        always @* begin
        RegWrite = 0;
        ALUSrc   = 0;
        ALUop    = 2'b00;
        RegDst   = 0;
        Branch   = 0;
        MemSize = 2'b10;
        ExtOp = 1;
        Link = 0;
        Jump = 0;
        MemWrite = 0;
        MemRead  = 0;
        MemToReg = 0;
        JumpReg = 0;
        ALUop = ALU_ADD;
        
       //May need extra control signals for Jump, beq, lh, lb, etc. in future
       casez(opcode)
            6'b000000: begin
                RegWrite = 1;
                RegDst   = 1;
                ALUop    = ALU_USE_FUNCT;
                
                if (funct == 6'b001000) begin // jr
                    RegWrite = 0;
                    JumpReg  = 1;
                end
            end
            
            //Mul
            6'b011100: begin
                RegWrite = 1;
                RegDst = 1;
                ALUop = ALU_MUL;
            end
            
            //ALUI (001???)
            6'b001???: begin
                RegWrite = 1;
                RegDst = 0;
                ALUSrc = 1;
                case (opcode)
                  6'b001000: ALUop = ALU_ADD; // addi
                  6'b001100: begin ALUop = ALU_AND; ExtOp = 0; end // andi
                  6'b001101: begin ALUop = ALU_OR;  ExtOp = 0; end // ori
                  6'b001110: begin ALUop = ALU_XOR; ExtOp = 0; end // xori
                  6'b001010: ALUop = ALU_SLT;       // slti
                  default:   ALUop = ALU_ADD;
                endcase
                if (opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110)
                    ExtOp = 0; //andi, ori, xori (0 ext)
            end
            
            //Loads (100???)
            6'b100???: begin
                RegWrite = 1;
                RegDst = 0;
                ALUSrc = 1;
                MemRead = 1;
                MemToReg = 1;
                
                case (opcode[1:0])
                    2'b00: MemSize = 2'b10; //lw
                    2'b01: MemSize = 2'b01; //lh
                    2'b10: MemSize = 2'b00; //lb
                endcase
            end
            
            //Stores (101???)
            6'b101???: begin
                ALUSrc = 1;
                MemWrite = 1;
                
                case (opcode[1:0])
                    2'b00: MemSize = 2'b10; //sw
                    2'b01: MemSize = 2'b01; //sh
                    2'b10: MemSize = 2'b00; //sb
                endcase
            end
            
            //Branches (0001??)
            6'b0001??: begin
                Branch = 1;
                ALUop = ALU_SUB;
            end
            
            //Jump
            6'b000010: begin
                Jump = 1;
            end
            
            //JAL
            6'b000011: begin
                Jump = 1;
                Link = 1;
                RegWrite = 1;
            end
            
            default: begin 
                //keep defaults (NOP)
            end
        endcase
    end
       
endmodule
    
