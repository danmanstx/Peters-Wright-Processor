`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:39:42 01/31/2011 
// Design Name: 
// Module Name:    n_bit_adder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module n_bit_adder(a,b,cin,s,cout);
	parameter n=4;
	input [n-1:0] a;
	input [n-1:0] b;
	input cin;
	output [n-1:0] s;
	output cout;
	wire [n:0] c;
	wire [n-1:0] w;
	
	genvar i;
	assign c[0]=cin;
	assign cout=c[n];
	
	generate
	for(i=0; i < n; i=i+1)
	begin:startgen
		xor XOR(w[i],b[i],cin);	//invert b when cin = 1
		BFA bitslice(a[i],w[i],c[i],s[i],c[i+1]);
	end
	endgenerate

endmodule

