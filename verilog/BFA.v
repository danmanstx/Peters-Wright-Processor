`timescale 1ns / 1ps
module BFA(a,b,cin,sum,cout);
	input a,b,cin;
	output sum,cout;
	
	assign cout = (a && b) || (b && cin) || (a && cin);
	assign sum = a ^ b ^ cin;
	/*
	always@(a or b or cin)
	begin
		cout = (a & b) | (b & cin) | (a & cin);
		sum = a ^ b ^ cin;
	end
	*/
endmodule
