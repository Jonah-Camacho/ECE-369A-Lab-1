`timescale 1ns / 1ps


module ProgramCounter(Address, PCWrite, PCResult, Reset, Clk);

	input [31:0] Address;
	input Reset, Clk;
	output reg [31:0] PCResult;
	input PCWrite;
	

    // Initialize to 0 for simulation
    initial begin
        PCResult = 32'h00000000;
    end

// On reset, set PC to 0; otherwise, update on rising edge
    always @(posedge Clk or posedge Reset) begin
        if (Reset)
            PCResult <= 32'h00000000; // start at address 0
        else if (PCWrite)
            PCResult <= Address; // load next PC
        else
            PCResult <= PCResult; // STALL: hold PC
    end
	
    /* Please fill in the implementation here... */

endmodule
