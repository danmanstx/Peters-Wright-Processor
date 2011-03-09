
module MUX_nx1(in,sel,out);
	parameter n=4;
	input [2**n-1:0] in;
	input [n-1:0] sel;
	output reg out;
	integer i;
	
	always@(in or sel)
	begin
		i = sel;
		out = in[i];
	end
	
endmodule
