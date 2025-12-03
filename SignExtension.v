`timescale 1ns / 1ps



module SignExtension (
    input  wire [15:0] in,        // 16-bit immediate input
    input  wire        control,   // 0 = sign extend, 1 = zero extend
    output wire [31:0] out        // 32-bit extended output
);
    // Extension logic:
    // control = 0: Sign extend (replicate MSB) - used for ADDI, SLTI, LW, SW, etc.
    // control = 1: Zero extend (pad with zeros) - used for ANDI, ORI, XORI
    assign out = (control == 1'b0) ? {{16{in[15]}}, in}  // Sign extend
                                    : {16'b0, in};        // Zero extend

endmodule