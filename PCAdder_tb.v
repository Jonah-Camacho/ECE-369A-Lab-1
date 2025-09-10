`timescale 1ns / 1ps


module PCAdder_tb(

    );
    
    reg [31:0] PCResult;
    
    wire [31:0] PCAddResult;
    
    PCAdder u0(.PCResult(PCResult),.PCAddResult(PCAddResult));
    
    initial begin
    #20
    PCResult = 32'd10; #20
    PCResult = 32'd20; #20
    PCResult = 32'd100;
    end
    
    
endmodule
