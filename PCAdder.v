`timescale 1ns / 1ps


module PCAdder(PCResult, PCAddResult);

    input [31:0] PCResult;

    output [31:0] PCAddResult;
    
    assign PCAddResult = PCResult + 4;
    /* Please fill in the implementation here... */

endmodule

