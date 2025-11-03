module Shift_left_2(
input [25:0] value_in, 
output [27:0] value_out // we end with 28 
);


assign value_out = value_in << 2;

endmodule