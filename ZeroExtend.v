'timescale 1ns / 1ps

// What ZeroExtend will be used for

// andi:       Bitwise masking which does not use signed math
// ori:       Bitwise OR, no sign
// xori:       Bitwise XOR, so sign

module ZeroExtend (
  input [15:0] in, // 16 bit input
  output [31:0] out // 32 bit output
);

  assign out = {16'b0, in}; // Takes input and extends high 16 bits with 0

endmodule
