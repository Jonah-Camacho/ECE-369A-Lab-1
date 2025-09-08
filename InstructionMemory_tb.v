`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory 
// Module - InstructionMemory_tb.v
// Description - Test the 'InstructionMemory_tb.v' module.
////////////////////////////////////////////////////////////////////////////////

module InstructionMemory_tb(); 

    wire [31:0] Instruction;

    reg [31:0] Address;

	InstructionMemory u0(
		.Address(Address),
        .Instruction(Instruction)
	);

	initial begin
        // Initialize Address
        Address = 0;

        // Test different address values
        #10 Address = 32'd0;    // Test with address 0
        

        #10 Address = 32'd4;    // Test with address 4 (next instruction)
        

        #10 Address = 32'd8;    // Test with address 8
       

        #10 Address = 32'd12;   // Test with address 12
        

        #10 Address = 32'd28;   // Test with address 28
        

        
        #10 Address = 32'd32;  // Test with address near the end of the memory
        

        // Test the last address
        #10 Address = 32'd128;  
        

      
    end


endmodule

