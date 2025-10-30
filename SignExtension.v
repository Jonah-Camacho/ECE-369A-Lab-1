'timescale 1ns / 1ps

// Used for these Instructions:

// addi:                                           signed add
// slti:                                           signed compare
// lw / sw:                                        signed offset
// lb / lh / sb / sh:                              signed offset
// beq / bne / bgez / bgtz / blez / btlz:          signed branch displacement


module SignExtension (
  input [15:0] in, // the 16 bit input
  output [31:0] out // the 32 bit output
);

// Replicates the Most Significant Bit (bit 15) to fill the high 16 bits.
// Concatonates those 16 bits with the original 16 bit input
assign out = {{16{in[15]}}, in}; 

endmodule
