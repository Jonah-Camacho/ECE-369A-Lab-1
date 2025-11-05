module Shift_left_2_26(
input [25:0] in, 
output [27:0] out // we end with 28 
);


assign out = {in, 2'b00};

endmodule