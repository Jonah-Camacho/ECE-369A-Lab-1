`timescale 1ns / 1ps



module ALUcontrol(
    input [3:0] ALUop,
    input [5:0] funct,
    output reg [3:0] ALUctrl
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
      ALU_USE_FUNCT = 4'b1110,
      ALU_NOP       = 4'b1111,
      ALU_LUI       = 4'b1010;

    // R-type funct codes
   localparam [5:0]
      F_SLL  = 6'b000000,
      F_SRL  = 6'b000010,
      F_JR   = 6'b001000, // ALU not used; PC path handles this
      F_ADD  = 6'b100000,
      F_SUB  = 6'b100010,
      F_AND  = 6'b100100,
      F_OR   = 6'b100101,
      F_XOR  = 6'b100110,
      F_NOR  = 6'b100111,
      F_SLT  = 6'b101010;

    always @* begin
        ALUctrl = ALU_NOP; //safety sake, to make sure we always have an output
        if (ALUop == ALU_USE_FUNCT) begin
            case (funct)
                F_ADD:begin
                    ALUctrl = ALU_ADD;
                end
                F_SUB: begin
                    ALUctrl = ALU_SUB;
                end
                F_AND:begin
                    ALUctrl = ALU_AND;
                end
                F_OR:begin
                    ALUctrl = ALU_OR;
                 end
                F_XOR: begin
                    ALUctrl = ALU_XOR;
                end
                F_NOR:begin
                    ALUctrl = ALU_NOR;
                end
                F_SLT:begin
                    ALUctrl = ALU_SLT;
                end
                F_SLL:begin
                    ALUctrl = ALU_SLL;
                end
                F_SRL:begin
                    ALUctrl = ALU_SRL;
                end
                F_JR:begin
                    ALUctrl = ALU_NOP; // no ALU action for jr
                end
                default:begin
                    ALUctrl = ALU_NOP;
                end
            endcase
        end else begin
            case(ALUop)
                ALU_LUI: ALUctrl = ALU_LUI;
                default: ALUctrl = ALUop;
            endcase
        end
    end
endmodule
