`timescale 1ns / 1ps



module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [4:0] shamt, // used in SLL/SLR, worry about later.
    input [3:0] op,
    output reg [31:0] result,
    output reg Zero 
    );
    
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
      ALU_NOP       = 4'b1111,
      ALU_LUI       = 4'b1010;
    
    always @* begin
        case (op)
            ALU_ADD: begin;
                result = input1 + input2;
            end
            
            ALU_SUB: begin
                result = input1 - input2;
            end
            
            ALU_AND: begin
                result = input1 & input2;
            end
            
            ALU_OR: begin
                result = input1 | input2;
            end
            
            ALU_XOR: begin
                result = input1 ^ input2;
            end
            
            ALU_NOR: begin
                result = ~(input1 | input2);
            end
            
            ALU_SLT: begin
                result = ($signed(input1) < $signed(input2)) ? 32'd1 : 32'd0;
            end
            
            ALU_MUL:begin
                result = input1 * input2;
            end
            
            ALU_NOP:begin
                result = 32'b0;
            end
            
            ALU_SLL: begin
                result = input2 << shamt;
            end
            
            ALU_SRL: begin
                result = input2 >> shamt;
            end
            
            ALU_LUI: begin
                result = input2 << 16;
            end
            
            default: result = 32'b0;
        endcase
        
        Zero = (result == 32'b0);
    end
endmodule
