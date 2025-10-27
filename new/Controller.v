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
    output reg [1:0] ALUop,
    output reg [1:0] MemSize
);

    wire [5:0] opcode = Instruction[31:26];
    
    localparam [5:0] OP_RTYPE = 6'b000000;
    localparam [5:0] OP_MUL = 6'b011100;
    
    localparam [5:0] OP_ALUI = 6'b001???;
    localparam [5:0] OP_LOAD = 6'b100???;
    localparam [5:0] OP_STORE = 6'b101???;
    
    localparam [5:0] OP_BRANCH = 6'b0001??;
    localparam [5:0] OP_JUMP = 6'b000010;
    localparam [5:0] OP_JAL = 6'b000011;
    
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
        
       //May need extra control signals for Jump, beq, lh, lb, etc. in future
       casez(opcode)
            OP_RTYPE: begin
                RegWrite = 1;
                RegDst   = 1;
                ALUop    = 2'b10;
                
                if (funct == 6'b001000) begin // jr
                    RegWrite = 0;
                    JumpReg  = 1;
                end
            end
            
            OP_MUL: begin
                RegWrite = 1;
                RegDst = 1;
                ALUop = 2'b10;
            end
            
            OP_ALUI: begin
                RegWrite = 1;
                RegDst = 0;
                ALUSrc = 1;
                ALUop = 2'b11;
                if (opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110)
                    ExtOp = 0; //andi, ori, xori (0 ext)
            end
            
            OP_LOAD: begin
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
            
            OP_STORE: begin
                ALUSrc = 1;
                MemWrite = 1;
                
                case (opcode[1:0])
                    2'b00: MemSize = 2'b10; //sw
                    2'b01: MemSize = 2'b01; //sh
                    2'b10: MemSize = 2'b00; //sb
                endcase
            end
            
            OP_BRANCH: begin
                Branch = 1;
                ALUop = 2'b01;
            end
            
            OP_JUMP: begin
                Jump = 1;
            end
            
            OP_JAL: begin
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
    
