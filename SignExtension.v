'timescale 1ns / 1ps

module SignExtension (
  input [15:0] in, // the 16 bit input
  output [31:0] out // the 32 bit output
);

// Replicates the Most Significant Bit (bit 15) to fill the high 16 bits.
// Concatonates those 16 bits with the original 16 bit input
assign out = {{16{in[15]}}, in}; 

endmodule
