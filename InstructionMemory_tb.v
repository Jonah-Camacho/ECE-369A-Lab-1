`timescale 1ns / 1ps

module InstructionMemory_tb(); 

    wire [31:0] Instruction;
	reg [31:0] Address;

	InstructionMemory u0(.Address(Address),.Instruction(Instruction));

	initial begin
        // Initialize Address
        Address = 0;

        #10 Address = 32'd0;   
        #10 Address = 32'd4;    
        #10 Address = 32'd8;  
        #10 Address = 32'd12;   
        #10 Address = 32'd28;   
        #10 Address = 32'd32;  
        #10 Address = 32'd128;  
        

      
    end


endmodule

