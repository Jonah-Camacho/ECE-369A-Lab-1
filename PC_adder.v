module Pc_adder(
input [32:0] Pc_in;
output [32:0] Pc_out;
);

assign Pc_out  = Pc_in + 4;

endmodule

